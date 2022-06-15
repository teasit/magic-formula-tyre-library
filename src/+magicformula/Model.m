classdef (Abstract) Model < matlab.mixin.Copyable
    properties (Abstract)
        Parameters magicformula.v62.Parameters
        File char
        Description string
        Version {isnumeric}
    end
    methods (Abstract)
        outputs = eval(mdl, inputs)
    end
end