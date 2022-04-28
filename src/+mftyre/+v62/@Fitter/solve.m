function paramsOpt = solve(fitter,fitmode)
arguments
    fitter  mftyre.v62.Fitter
    fitmode mftyre.v62.FitMode
end
import('mftyre.v62.FitMode')
fitter.ActiveFitMode = fitmode;

%% Initialize all required data
idx = fitter.FitModeFlags(char(fitmode));
meas = fitter.Measurements(idx);
params = fitter.Parameters;
meas = downsample(meas,3,0);
mfinputs = fitter.preprocess(meas);

%% Confine measurement data to relevant parts
switch fitmode
    case {FitMode.Fx0, FitMode.Fx}
        testdata = cat(1,meas.FX);
    case {FitMode.Fy0, FitMode.Fy}
        testdata = cat(1,meas.FYW);
    case FitMode.Mz0
        error('Not yet implemented')
    case FitMode.Mx
        error('Not yet implemented')
    case FitMode.My
        error('Not yet implemented')
    case FitMode.Fz
        error('Not yet implemented')
    case FitMode.Mz
        error('Not yet implemented')
    otherwise
        error('Fit mode invalid.')
end

%% Set solver inputs
costFun = @(x) fitter.costFun(x,params,mfinputs,testdata,fitmode);
[x0,lb,ub] = convert2fittable(params,fitmode);
%TODO: change inputs of nonlcon (put big array of measurement data into it
%and then internally filter it, same for costFun
nonlcon = @(x) fitter.constraints(x,params,fitmode,mfinputs);
options = fitter.Options;

%% Start solving
warning('off','all')
try
    tic
    paramsOpt = fmincon(costFun,x0,[],[],[],[],lb,ub,nonlcon,options);
    t = toc;
    display(['Time elapsed: ' num2str(t)])
catch ME
    rethrow(ME)
end
warning('on','all')

end

