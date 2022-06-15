classdef FitterFailed < MException
    methods
        function obj = FitterFailed(fitmode)
            arguments
                fitmode char
            end
            errId = 'MagicFormulaTyreLibrary:FitterFailed';
            msgtext = sprintf('Fitter failed to solve fit-mode "%s".', fitmode);
            obj@MException(errId, msgtext)
        end
    end
end

