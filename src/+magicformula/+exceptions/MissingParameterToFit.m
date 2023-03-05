classdef (Hidden) MissingParameterToFit < MException
    properties
        ParameterName char
    end
    methods
        function obj = MissingParameterToFit(name, fitmode)
            arguments
                name char
                fitmode magicformula.FitMode
            end
            errId = 'MagicFormulaTyreLibrary:MissingParameterToFit';
            msgtext = 'Parameter ''%s'' is required to fit ''%s''.\n';
            msgtext = sprintf(msgtext, name, fitmode);
            obj@MException(errId, msgtext)
            obj.ParameterName = name;
        end
    end
end

