classdef Fitter < handle
    properties
        Measurements tydex.Measurement
        Parameters mftyre.v62.Parameters
        FitModeFlags containers.Map
        Options optim.options.SolverOptions = optimoptions('fmincon')
    end
    properties (Transient)
        ActiveFitMode mftyre.v62.FitMode
    end
    methods
        function fitter = Fitter(meas,params)
            arguments
                meas tydex.Measurement = tydex.Measurement.empty
                params mftyre.v62.Parameters = mftyre.v62.Parameters.empty
            end
            fitter.Parameters = params;
            fitter.Measurements = meas;
            fitter.Options.Display = 'iter-detailed';
            fitter.qualifyMeasurements();
        end
        paramsOpt = solve(fitter,fitmode)
        qualifyMeasurements(fitter)
    end
    methods (Static)
        cost = costFun(x,params,mfinputs,testdata,fitmode)
        [c,ceq] = constraints(x,params,fitmode,mfinputs)
        mfinputs = preprocess(meas)
    end
end