function params = appendFitted(params,x,fitmode)
    arguments
        params mftyre.v62.Parameters
        x double
        fitmode mftyre.v62.FitMode
    end
    import('mftyre.v62.FitMode')
    import('mftyre.v62.getFitParamNames')
    fitparams = getFitParamNames(fitmode);
    for i=1:numel(fitparams)
        params.(fitparams{i}).Value = x(i);
    end
    end
    
    