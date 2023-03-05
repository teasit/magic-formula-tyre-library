classdef (Hidden) NoMeasurementForFitMode < MException
    properties (SetAccess = protected)
        FitMode magicformula.FitMode
    end
    methods
        function obj = NoMeasurementForFitMode(fitmode)
            arguments
                fitmode char
            end
            errId = 'MagicFormulaTyreLibrary:NoMeasurementForFitMode';
            msgtext = sprintf(...
                'Measurement has no data for fit-mode "%s".', fitmode);
            obj@MException(errId, msgtext)
            obj.FitMode = fitmode;
        end
    end
end

