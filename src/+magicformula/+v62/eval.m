function [Fx,Fy,Mz,mux,muy] = eval(p,SX,SA,IA,FZ,VX,IP,usemode)
% EVAL Evaluates magic formula parameter set and calculates tyre forces.
% This function serves as a convenience function to avoid calling the
% respective Magic Formula sub-equations directly (Fx0/Fy0/Fx/Fy...).
% In case the tyre is mounted on a side other than it was tested on,
% the FYW forces are mirrored assuming skew-symmetry.
%
% Inputs:
%   - p         Magic Formula parameters passed as a struct.
%   - SX [1]    Slip ratio (unitless) as defined by DIN ISO 8855.
%   - SA [rad]  Slip angle in radians as defined by DIN ISO 8855.
%   - IA [rad]  Inclination angle in radians as defined by DIN ISO 8855.
%   - FZ [N]    Tyre normal force (FZW) in newton as defined by DIN ISO
%               8855. (Load on tyre is always positive)
%   - VX [m/s]  Slip point or wheel centerpoint longitudinal velocity.
%               Theoretically the slip point velocity should be used, but
%               the wheel centerpoint velocity is often more practical.
%   - IP [Pa]   Tyre inflation pressure in pascal.
%   - usemode   Integer that controls execution behavior. As of now, only
%               the tyre mounting side is set using this parameter.
%               In case the tyre is mounted on a side other than it was
%               tested on, the tyre curves are mirrored assuming skew-
%               symmetry. For example, if data was recorded with LEFT (0)
%               tyre but 'tyreSide' is provided as RIGHT (1), mirroring
%               takes place. Provide as:
%                   LEFT:  0
%                   RIGHT: 1
%
% Outputs:
%   - Fx [N]    Longitudinal tyre force.
%   - Fy [N]    Lateral tyre force.
%   - Mz [N*m]  Self-aligning torque.
%   - mux [1]   Longitudinal tyre friction coefficient.
%   - muy [1]   Lateral tyre friction coefficient.

narginchk(8,8)

if isempty(IP); IP = p.INFLPRES; end
if isempty(usemode); usemode = p.TYRESIDE; end

tyreside = usemode;
mirrorCurve = tyreside ~= p.TYRESIDE;
SA = (-1).^mirrorCurve.*SA;
[Fx,mux] = magicformula.v62.equations.Fx(p,SA,SX,IA,IP,FZ);
[Fy,muy] = magicformula.v62.equations.Fy(p,SA,SX,IA,IP,FZ);
% todo: Mz0 temporarily in place of Mz
Mz = magicformula.v62.equations.Mz0(p,SA,IA,IP,FZ);
Fy = (-1).^mirrorCurve.*Fy;
end