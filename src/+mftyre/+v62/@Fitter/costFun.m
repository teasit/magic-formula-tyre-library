function cost = costFun(x,params,mfinputs,testdata,fitmode)
arguments
    x        double
    params   mftyre.v62.Parameters
    mfinputs double
    testdata double
    fitmode  mftyre.v62.FitMode
end
import('mftyre.v62.FitMode')
import('mftyre.v62.equations.Fx0')
import('mftyre.v62.equations.Fy0')
import('mftyre.v62.equations.Fx')
import('mftyre.v62.equations.Fy')

params = appendFitted(params,x,fitmode);
params = struct(params);

switch fitmode
    case FitMode.Fx0
        longslip = mfinputs(:,2);
        pressure = mfinputs(:,7);
        inclangl = mfinputs(:,4);
        Fz       = mfinputs(:,1);
        modelout = Fx0(params,longslip,inclangl,pressure,Fz);
    case FitMode.Fy0
        slipangl = mfinputs(:,3);
        pressure = mfinputs(:,7);
        inclangl = mfinputs(:,4);
        Fz       = mfinputs(:,1);
        modelout = Fy0(params,slipangl,inclangl,pressure,Fz);
    case FitMode.Fx
        slipangl = -mfinputs(:,3); %TODO fix
        longslip = mfinputs(:,2);
        pressure = mfinputs(:,7);
        inclangl = mfinputs(:,4);
        Fz       = mfinputs(:,1);
        modelout = Fx(params,slipangl,longslip,inclangl,pressure,Fz);
    case FitMode.Fy
        slipangl = -mfinputs(:,3); %TODO fix
        longslip = mfinputs(:,2);
        pressure = mfinputs(:,7);
        inclangl = mfinputs(:,4);
        Fz       = mfinputs(:,1);
        modelout = Fy(params,slipangl,longslip,inclangl,pressure,Fz);
    case FitMode.Fz
        warning('Not implemented yet')
    case FitMode.Mx
        warning('Not implemented yet')
    case FitMode.My
        warning('Not implemented yet')
    case {FitMode.Mz0, FitMode.Mz}
        warning('Not implemented yet')
end

cost = sum((testdata-modelout).^2);
cost = double(cost);
end
