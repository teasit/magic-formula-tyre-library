classdef NoMeasurementForFitMode < MException
    methods
        function obj = NoMeasurementForFitMode(fitmode)
            arguments
                fitmode char
            end
            errId = 'MagicFormulaTyreLibrary:NoMeasurementForFitMode';
            msgtext = sprintf(...
                'Measurement has no data for fit-mode "%s".', fitmode);
            obj@MException(errId, msgtext)
        end
    end
end

