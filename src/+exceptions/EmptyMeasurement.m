classdef EmptyMeasurement < MException
    methods
        function obj = EmptyMeasurement()
            errId = 'MagicFormulaTyreLibrary:EmptyMeasurement';
            msgtext = sprintf('Error due to empty measurement.');
            obj@MException(errId, msgtext)
        end
    end
end

