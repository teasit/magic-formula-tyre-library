classdef (Hidden, Abstract) FileInterface < handle    
    properties (Access = protected)
        KeywordsAll = {'HEADER', 'COMMENTS', 'CONSTANTS', 'MEASURCHANNELS', ...
            'MEASURDATA', 'MODELDEFINITION', 'MODELPARAMETERS', ...
            'MODELCOEFFICIENTS', 'MODELCHANNELS', 'MODELOUTPUTS', ...
            'MODELEND', 'END'}
        ColumnWidths = uint8([10 30 10 10 10 10])
        MaxLengthParameter = uint8(8)
        MaxLengthText = uint8(11)
        MaxLengthRow = uint8(80)
    end
end

