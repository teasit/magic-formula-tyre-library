function names = getFitParamNames(fitmode)
% GETFITPARAMNAMES Returns the parameter names that are adjusted by the
% optimization algorithm in each fitting mode. Usually, the pure slip
% conditions are fitted first (Fx0, Fy0) and after those parameters are set
% the combined slip conditions are fitted (Fx, Fy).
%
% Inputs:
%   - fitmode   (magicformula.v62.FitMode)
%
% Outputs:
%   - names     (cell array of chars)
%
arguments
    fitmode magicformula.v62.FitMode
end

import('magicformula.v62.FitMode')

names = {};
switch fitmode
    case FitMode.Fx0
        names = {
            'PCX1'
            'PDX1'
            'PDX2'
            'PDX3'
            'PEX1'
            'PEX2'
            'PEX3'
            'PEX4'
            'PKX1'
            'PKX2'
            'PKX3'
            'PHX1'
            'PHX2'
            'PVX1'
            'PVX2'
            'PPX1'
            'PPX2'
            'PPX3'
            'PPX4'
            'PTX1'
            'PTX2'
            'PTX3'
            };
    case FitMode.Fy0
        names = {
            'PCY1'
            'PDY1'
            'PDY2'
            'PDY3'
            'PEY1'
            'PEY2'
            'PEY3'
            'PEY4'
            'PEY5'
            'PKY1'
            'PKY2'
            'PKY3'
            'PKY4'
            'PKY5'
            'PKY6'
            'PKY7'
            'PHY1'
            'PHY2'
            'PVY1'
            'PVY2'
            'PVY3'
            'PVY4'
            'PPY1'
            'PPY2'
            'PPY3'
            'PPY4'
            'PPY5'
            };
    case FitMode.Mz0
        names = {
            'QBZ1'
            'QBZ2'
            'QBZ3'
            'QBZ4'
            'QBZ5'
            'QBZ9'
            'QBZ10'
            'QCZ1'
            'QDZ1'
            'QDZ2'
            'QDZ3'
            'QDZ4'
            'QDZ6'
            'QDZ7'
            'QDZ8'
            'QDZ9'
            'QDZ10'
            'QDZ11'
            'QEZ1'
            'QEZ2'
            'QEZ3'
            'QEZ4'
            'QEZ5'
            'QHZ1'
            'QHZ2'
            'QHZ3'
            'QHZ4'
            };
    case FitMode.Fx
        names = {
            'RBX1'
            'RBX2'
            'RBX3'
            'RCX1'
            'REX1'
            'REX2'
            'RHX1'
            };
    case FitMode.Fy
        names = {
            'RBY1'
            'RBY2'
            'RBY3'
            'RBY4'
            'RCY1'
            'REY1'
            'REY2'
            'RHY1'
            'RHY2'
            'RVY1'
            'RVY2'
            'RVY3'
            'RVY4'
            'RVY5'
            'RVY6'
            };
    case FitMode.Mx
        names = {
            'QSX1'
            'QSX2'
            'QSX3'
            'QSX4'
            'QSX5'
            'QSX6'
            'QSX7'
            'QSX8'
            'QSX9'
            'QSX10'
            'QSX11'
            'QSX12'
            'QSX13'
            'QSX14'
            'PPMX1'
            };
    case FitMode.My
        names = {
            'QSY1'
            'QSY2'
            'QSY3'
            'QSY4'
            'QSY5'
            'QSY6'
            'QSY7'
            'QSY8'
            };
    case FitMode.Fz
        warning('Fitting of Fz is not implemented yet.')
    case FitMode.Mz
        names = {
            'SSZ1'
            'SSZ2'
            'SSZ3'
            'SSZ4'
            'PPZ1'
            'PPZ2'
            };
end
end

