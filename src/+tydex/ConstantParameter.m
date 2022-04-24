classdef ConstantParameter < tydex.Parameter
    properties
        Unit    char
        Value
    end
    methods
        function param = ConstantParameter(name,unit,value)
            if nargin < 1
                error('Name property is required.')
            end
            param.Name = name;
            if (~exist('unit', 'var'))
                param.Unit = '';
            else
                param.Unit = unit;
            end
            if (~exist('value', 'var'))
                param.Value = '';
            else
                param.Value = value;
            end
        end
    end
end

