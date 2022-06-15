function [Fx,Fy,mux,muy] = eval(params,slipangl,longslip,inclangl,...
    pressure,tyreNormF,tyreSide)
% EVAL Evaluates magic formula parameter set and calculates tyre forces.
% This function serves as a convenience function to avoid calling the
% respective Magic Formula sub-equations directly (Fx0/Fy0/Fx/Fy...).
% In case the tyre is mounted on a side other than it was tested on,
% the FYW forces are mirrored assuming skew-symmetry.
%
% Note:
%   Currently, equations (4.E7) and (4.E8) are ignored, the scaling factor
%   for the tyre friction coefficient does not change depending on speeed.
%   Also, the equations for FZ and MZ are not implemented.
%
% Inputs:
%   - params    Magic Formula parameters passed as a struct.
%   - slipangl  Slip angle in radians as defined by DIN ISO 8855.
%   - longslip  Slip ratio (unitless) as defined by DIN ISO 8855.
%   - inclangl  Inclination angle in radians as defined by DIN ISO 8855.
%   - pressure  Tyre inflation pressure in pascal as defined by DIN ISO
%               8855.
%   - tyreNormF Tyre normal force (FZW) in newton as defined by DIN ISO
%               8855. (Load on tyre is always positive)
%   - tyreSide  In case the tyre is mounted on a side other than it was
%               tested on, the tyre curves are mirrored assuming skew-
%               symmetry. For example, if data was recorded with 'LEFT' (0)
%               tyre but 'tyreSide' is provided as 'RIGHT' (1), mirroring
%               takes place. Provide as:
%                   0: LEFT
%                   1: RIGHT
%
% Outputs:
%   - Fx        Longitudinal tyre force.
%   - Fy        Lateral tyre force.
%   - mux       Longitudinal tyre friction coefficient.
%   - muy       Lateral tyre friction coefficient.
%
narginchk(7,7)
mirrorCurve = tyreSide ~= params.TYRESIDE;
slipangl = (-1).^mirrorCurve.*slipangl;
[Fx,mux] = magicformula.v62.equations.Fx(params,...
    slipangl,longslip,inclangl,pressure,tyreNormF);
[Fy,muy] = magicformula.v62.equations.Fy(params,...
    slipangl,longslip,inclangl,pressure,tyreNormF);
Fy = (-1).^mirrorCurve.*Fy;
end

