function [c,ceq] = constraints(x,params,fitmode,mfinputs)
arguments
    x double
    params mftyre.v62.Parameters
    fitmode mftyre.v62.FitMode
    mfinputs double
end
c = []; ceq = [];
import('mftyre.v62.FitMode')
params = appendFitted(params,x,fitmode);
longslip = mfinputs(:,2);
slipangl = mfinputs(:,3);
inclangl = mfinputs(:,4);
pressure = mfinputs(:,7);
Fz = mfinputs(:,1);
switch fitmode
    case FitMode.Fx0
        [~,Cx,Dx,Ex] = mftyre.v62.equations.Fx0(struct(params),...
            longslip,inclangl,pressure,Fz);
        c = [-Cx+eps;-Dx+eps;Ex-1];
    case FitMode.Fy0
        [~,Cy,Ey] = mftyre.v62.equations.Fy0(struct(params),...
            slipangl,inclangl,pressure,Fz);
        c = [-Cy+eps;Ey-1];
    case FitMode.Fx
        slipangl = - slipangl; % TODO: fix
        [~,Gxa,Bxa,Exa] = mftyre.v62.equations.Fx(struct(params),...
            slipangl,longslip,inclangl,pressure,Fz);
        c = [-Gxa+eps;-Bxa+eps;Exa-1];
    case FitMode.Fy
        slipangl = - slipangl; % TODO: fix
        [~,Gyk,Byk,Eyk] = mftyre.v62.equations.Fy(struct(params),...
            slipangl,longslip,inclangl,pressure,Fz);
        c = [-Gyk+eps;-Byk+eps;Eyk-1];
    case FitMode.Mz0
        warning('Constraints for Mz0 not yet implemented')
    case FitMode.Mz
        warning('Constraints for Mz not yet implemented')
    case FitMode.Mx
        warning('Constraints for Mx not yet implemented')
    case FitMode.My
        warning('Constraints for My not yet implemented')
    case FitMode.Fz
        warning('Constraints for Fz not yet implemented')
end
end