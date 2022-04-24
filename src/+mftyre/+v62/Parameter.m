classdef Parameter
    properties
        Description string
        Value
    end
    methods
        function param = Parameter(value,desc)
            arguments
                value = []
                desc = ""
            end
            param.Value = value;
            param.Description = desc;
        end
    end
end