classdef (Abstract) FSAETTC_SI_ISO_Mat < tydex.Parser
    properties (Access = protected)
        SteadyStateTolerances struct = struct(...
            'FZW',      150, ...    % [N]
            'INFLPRES', 5,   ...    % [kPa]
            'INCLANGL', 0.2, ...    % [deg]
            'SLIPANGL', 0.2)        % [deg]
    end
    methods (Static, Access = public)
        function measurements = fixUnits(measurements)
            arguments
                measurements tydex.Measurement
            end
            import tydex.parsers.FSAETTC_SI_ISO_Mat.convertUnit
            
            for num = 1:numel(measurements)
                measurement = measurements(num);
                for i = 1:numel(measurement.Measured)
                    param = measurement.Measured(i);
                    [unit,factor] = convertUnit(param.Unit);
                    param.Unit = unit;
                    param.Data = param.Data*factor;
                    measurement.Measured(i) = param;
                end
                for i = 1:numel(measurement.Constant)
                    param = measurement.Constant(i);
                    [unit,factor] = convertUnit(param.Unit);
                    param.Unit = unit;
                    param.Value = param.Value*factor;
                    measurement.Constant(i) = param;
                end
                measurements(num) = measurement;
            end
        end
        function [newUnit,factor] = convertUnit(unit)
            arguments
                unit char
            end
            switch unit
                case 'deg'
                    newUnit = 'rad';
                    factor = pi/180;
                case 'km/h'
                    newUnit = 'm/s';
                    factor = 1/3.6;
                case 'kPa'
                    newUnit = 'Pa';
                    factor = 1000;
                case {'s', 'N', 'Nm', '-', 'm/s', 'rad', 'rad/s'}
                    newUnit = unit;
                    factor = 1;
                otherwise
                    warning(['Unkown unit "' unit '"!' newline() ...
                        'This may result in failure of the solver.'])
            end
        end
    end
end
