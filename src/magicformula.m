function [FX,FY,MZ,MY,MX] = magicformula(params,SX,SA,varargin)
%MAGICFORMULA Unofficial implementation of Pacejka's magic formula.
%   Orientation of inputs and outputs as defined per DIN ISO 8855:2011.
%
%   [FX,FY,MZ,MY,MX] = MAGICFORMULA(params,__)
%   [FX,FY,MZ,MY,MX] = MAGICFORMULA(file,__)
%   [FX,FY,MZ,MY,MX] = MAGICFORMULA(tyre,__)
%
%   [...] = MAGICFORMULA(__,SX,SA)
%   [...] = MAGICFORMULA(__,SX,SA,FZ)
%   [...] = MAGICFORMULA(__,SX,SA,FZ,IP)
%   [...] = MAGICFORMULA(__,SX,SA,FZ,IP,IA)
%   [...] = MAGICFORMULA(__,SX,SA,FZ,IP,IA,VX)
%   [...] = MAGICFORMULA(__,SX,SA,FZ,IP,IA,VX,side)
%   [...] = MAGICFORMULA(__,SX,SA,FZ,IP,IA,VX,side,version)
%
%   For code-generation, all inputs have to be specified:
%       [...] = MAGICFORMULA(__,SX,SA,FZ,IP,IA,VX,side,version)
%
%   Parameter input (mutually exclusive):
%       - params:   provide as 'magicformula.Parameters' or 'struct'
%       - file:     provide as Tire Properties File (*.tir)
%       - tyre:     provide as 'MagicFormulaTyre' object
%
%   Steady-state inputs:
%       Name    | Unit | Default    | Description
%       ==================================================================
%       SX      | -    | -          | Longitudinal slip ratio
%       SA      | rad  | -          | Slip angle
%       FZ      | N    | FNOMIN     | Vertical normal load
%       IP      | Pa   | INFLPRES   | Inflation pressure
%       IA      | rad  | 0          | Inclination angle
%       VX      | m/s  | LONGVL     | Velocity of wheel contact center
%   
%   Additional (optional) inputs:
%       Name    | Default   | Description
%       ==================================================================
%       side    | 0 (LEFT)  | Mounting side of tyre (Left=0, Right=1)
%       version | 61        | Taken from parameters if omitted.
%
%   Outputs:
%       Name    | Unit | Description
%       ==================================================================
%       FX      | N    | Longitudinal tire force
%       FY      | N    | Lateral tire force
%       MZ      | N*m  | Re-aligning torque
%       MY      | N*m  | Rolling-resistance torque
%       MX      | N*m  | Overturning moment
%
%   See also MagicFormulaTyre, magicformula.v61.Parameters.
%
nargoutchk(0,5)
if coder.target('MATLAB')
    [params,SX,SA,FZ,IP,IA,VX,side,version] = ...
        magicformula.InputParser.parse(params,SX,SA,varargin{:});
else
    [FZ,IP,IA,VX,side,version] = deal(varargin{:});
end
switch version
    case MagicFormulaVersion.v61
        f = @magicformula.v61.eval;
        if nargout() <= 2
            [FX,FY] = f(params,SX,SA,FZ,IP,IA,VX,side);
        elseif nargout() == 3
            [FX,FY,MZ] = f(params,SX,SA,FZ,IP,IA,VX,side);
        elseif nargout() == 4
            [FX,FY,MZ,MY] = f(params,SX,SA,FZ,IP,IA,VX,side);
        elseif nargout() == 5
            [FX,FY,MZ,MY,MX] = f(params,SX,SA,FZ,IP,IA,VX,side);
        end
    otherwise
        error('Version ''%d'' not supported yet.', version)
end
end