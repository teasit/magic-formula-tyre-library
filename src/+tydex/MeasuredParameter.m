classdef MeasuredParameter < tydex.Parameter
    properties (Access = public)
        Unit        char
        Factor      single
        MeasOffset  single
        PhysOffset  single
        Data        single
    end
    
    methods
        function param = MeasuredParameter(name,unit,data,factor,measOffset,physOffset)
            if nargin < 1
                error('name is required')
            end
            param.Name = name;
            if (~exist('unit', 'var'))
                param.Unit = '';
            else
                param.Unit = unit;
            end
            if (~exist('data', 'var'))
                param.Data = '';
            else
                param.Data = data;
            end
            if (~exist('factor', 'var'))
                param.Factor = 1;
            else
                param.Factor = factor;
            end
            if (~exist('measOffset', 'var'))
                param.MeasOffset = 0;
            else
                param.MeasOffset = measOffset;
            end
            if (~exist('measOffset', 'var'))
                param.PhysOffset = 0;
            else
                param.PhysOffset = physOffset;
            end
        end
    end
end