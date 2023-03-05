classdef (Hidden) ParameterFittable < magicformula.Parameter
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
        function param = ParameterFittable(name,value,min,max,fixd)
            arguments
                name
                value = 0
                min = -inf
                max = inf
                fixd = false
            end
            param@magicformula.Parameter(name, value)
            param.Min = min;
            param.Max = max;
            param.Fixed = fixd;
        end
    end
end

