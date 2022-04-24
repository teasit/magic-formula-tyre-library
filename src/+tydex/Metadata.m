classdef Metadata < tydex.Parameter
    properties
        Value
    end
    methods
        function param = Metadata(name, value)
            arguments
                name char
                value = char.empty
            end
            param.Name = name;
            param.Value = value;
        end
    end
end