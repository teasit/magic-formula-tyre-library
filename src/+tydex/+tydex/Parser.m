classdef (Abstract) Parser < handle
    %PARSER Abstract class defining interfaces for custom parsers.
    %   When implementing a parser to map an arbitrary file(s) to a TYDEX
    %   measurement object, please make sure the physical units of the
    %   output data are adhere to the following convention. This is needed
    %   to guarantee expected behaviour of tools working with this module.
    %       pressures: Kilopascal
    %       angles: Degree
    %       forces: Newton
    %       slip ratio: 1 (no unit)
    %
    methods (Abstract, Access = protected)
        [measurements, bins, binvalues] = parse(obj,file)
    end
    methods
        function [measurements, bins, binvalues] = run(obj, file)
            [measurements, bins, binvalues] = parse(obj, file);
            measurements = measurements.index();
        end
    end
end

