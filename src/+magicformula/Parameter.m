classdef (Hidden) Parameter < matlab.mixin.Heterogeneous
    properties
        Name char
        Value
    end
    properties (SetAccess = private)
        Description string
    end
    methods
        function param = Parameter(name,value)
            arguments
                name char
                value = []
            end
            param.Name = name;
            param.Value = value;
        end
        function desc = get.Description(param)
            import magicformula.ParameterDescriptions
            name = param.Name;
            try
                desc = ParameterDescriptions.(name);
            catch
                desc = string.empty;
            end
        end
    end
end