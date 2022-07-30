classdef ModelParameter
    %TYDEX.MODELPARAMETER
    properties
        Name
        Unit
        Value
        Description
    end
    methods
        function param = ModelParameter(name, unit, value, desc)
            arguments
                name char
                unit char = char.empty
                value = char.empty
                desc = char.empty
            end
            param.Name = name;
            param.Unit = unit;
            param.Value = value;
            param.Description = desc;
        end
    end
end