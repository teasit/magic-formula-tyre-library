classdef (Hidden) EmptyMeasurementChannel < MException
    properties (SetAccess = private)
        Channel char
    end
    methods
        function obj = EmptyMeasurementChannel(channelName)
            arguments
                channelName char
            end
            errId = 'MagicFormulaTyreLibrary:EmptyMeasurementChannel';
            msgtext = sprintf(...
                'Measurement channel "%s" is empty.', channelName);
            obj@MException(errId, msgtext)
            obj.Channel = channelName;
        end
    end
end

