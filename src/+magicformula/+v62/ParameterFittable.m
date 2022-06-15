classdef ParameterFittable < magicformula.v62.Parameter
    properties
        Min double
        % Minimum value the optimizer will set
        Max double
        % Maximum value the optimizer will set
        Fixed logical
        % If parameter is FIXED, it will not be considered by optimizer
        % while fitting the tyre model to the data
    end
    methods
        function param = ParameterFittable(value,min,max,desc,fixd)
            arguments
                value = 0
                min = -inf
                max = inf
                desc = ""
                fixd = false
            end
            param.Value = value;
            param.Min = min;
            param.Max = max;
            param.Description = desc;
            param.Fixed = fixd;
        end
        function param = set.Fixed(param,tf)
            arguments
                param magicformula.v62.ParameterFittable
                tf logical
            end
            param.Fixed = tf;
        end
    end
end

