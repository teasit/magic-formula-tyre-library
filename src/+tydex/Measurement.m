classdef Measurement
    %MEASUREMENT TYDEX 1.3 formatted Measurement (Tyre Data Exchange Format)
    properties (Access = public)
        Metadata tydex.Metadata
        Constant tydex.ConstantParameter
        Measured tydex.MeasuredParameter
    end
    properties (Access = private)
        ConstantNames cell
        MeasuredNames cell
    end
    properties (Dependent)
        INCLANGL
        INFLPRES
        LONGSLIP
        FNOMIN
        NOMPRES
        SLIPANGL
        LONGVEL
        RUNTIME
        WHROTSPD
        FX
        FYW
        FZW
        MXW
        MYW
        MZW
    end
    methods
        function measurements = index(measurements)
            arguments
                measurements tydex.Measurement
            end
            for num = 1:numel(measurements)
                measurement = measurements(num);
                measurement.ConstantNames = {measurement.Constant.Name};
                measurement.MeasuredNames = {measurement.Measured.Name};
                measurements(num) = measurement;
            end
        end
        function len = length(measurements)
            %LENGTH Returns length of all measurements combined
            arguments
                measurements tydex.Measurement
            end
            len = 0;
            for num = 1:numel(measurements)
                measurement = measurements(num);
                data = measurement.Measured(1).Data;
                len = len + length(data);
            end
        end
        function measurements = downsample(measurements, n, phase)
            %DOWNSAMPLE Wrapper for MATLAB function downsample
            arguments
                measurements tydex.Measurement
                n double
                phase double
            end
            for num = 1:numel(measurements)
                measurement = measurements(num);
                for i = 1:numel(measurement.Measured)
                    measured = measurement.Measured(i);
                    data = measured.Data;
                    downsampled = downsample(data, n, phase);
                    measurements(num).Measured(i).Data = downsampled;
                end
            end
        end
        function save(measurements,dirpath)
            %SAVE Saves objects as TYDEX files (.tdx)
            arguments
                measurements tydex.Measurement
                dirpath char {mustBeFolder} = uigetdir()
            end
            
            if dirpath == 0
                return
            end
            
            if isempty(measurements)
                return
            end
            
            map = containers.Map;
            map('colWidth1') = uint8(10);
            map('colWidth2') = uint8(30);
            map('colWidth3') = uint8(10);
            map('colWidth4') = uint8(10);
            map('colWidth5') = uint8(10);
            map('colWidth6') = uint8(10);
            map('maxLengthParameter') = uint8(8);
            map('maxLengthText') = uint8(11);
            map('maxLengthRow') = uint8(80);
            
            printRow        = @(fileId,data) fprintf(fileId,'%-*s%-*s%-*s%-*s%-*s%-*s%-*s',data{:});
            printString     = @(fileId,str) fprintf(fileId,'%-s',str);
            printNumber     = @(fileId,width,prec,num) fprintf(fileId,'%-*.*f',width,prec,num);
            printLineBreak  = @(fileId) fprintf(fileId,'\n');
            
            comment = [...
                'TYDEX Exporter by Tom Teasdale 2022' newline() ...
                newline() ...
                'TYDEX standard was implemented according to:' newline() ...
                '   TYDEX-format: Description and Reference Manual. Release 1.3' newline() ...
                '   Dipl.-Ing. H.-J. Unrau, Universität Karlsruhe (TH)' newline() ...
                '   Dr.-Ing. J. Zamow, Dr.Ing.h.c.F.Porsche AG' newline() ...
                '   09.01.1997' newline() ...
                '   https://www.fast.kit.edu/download/DownloadsFahrzeugtechnik/TY100531_TYDEX_V1_3.pdf'];
            
            nominalParams = {
                'FNOMIN';
                'NOMPRES';
                };
            
            headerParams = {
                'RELEASE';
                'MEASID';
                'SUPPLIER';
                'DATE';
                'CLCKTIME'
                };
            
            numMeas = numel(measurements);
            
            measurementIds = measurements.getMetadataParameter('MEASID');
            names = {measurementIds.Value};
            names = strrep(names, ' ', '_');
            [names, I] = sort(names);
            measurements = measurements(I);
            fileCtrs = ones(size(names));
            for i = 2:numMeas
                name0 = names{i-1};
                name1 = names{i};
                if ~strcmp(name0, name1)
                    fileCtrs(i) = 1;
                else
                    fileCtrs(i) = fileCtrs(i-1) + 1;
                end
            end
            
            for num = 1:numMeas
                measurement = measurements(num);
                
                numMaxDigits = numel(num2str(numMeas));
                name = names{num};
                formatSpec = [name '_%0' num2str(numMaxDigits) 'd.tdx'];
                fileCtr = fileCtrs(num);
                filename = sprintf(formatSpec, fileCtr);
                file = fullfile(dirpath, filename);
                fileId = fopen(file,'w');
                
                %%% HEADER
                printString(fileId,'**HEADER');
                printLineBreak(fileId);
                for i=1:numel(headerParams)
                    idx = find(strcmp({measurement.Metadata.Name},headerParams{i}));
                    try
                        data = {
                            map('colWidth1'),string(measurement.Metadata(idx).Name),...
                            map('colWidth2'),string(measurement.Metadata(idx).Desc),...
                            map('colWidth4'),string(measurement.Metadata(idx).Value)};
                        if data{2} == ""; continue; end
                        printRow(fileId,data);
                    catch
                    end
                    printLineBreak(fileId);
                end
                
                %%% COMMENTS
                printLineBreak(fileId);
                printString(fileId,'**COMMENTS');
                printLineBreak(fileId);
                printString(fileId,comment);
                printLineBreak(fileId);
                
                %%% CONSTANTS
                printLineBreak(fileId);
                printString(fileId,'**CONSTANTS');
                printLineBreak(fileId);
                
                for i=1:numel(measurement.Constant)
                    try
                        idx = find(strcmp({measurement.Constant(i).Name},nominalParams), 1);
                        if ~isempty(idx)
                            continue
                        end
                        data = {
                            map('colWidth1'),measurement.Constant(i).Name,...
                            map('colWidth2'),measurement.Constant(i).Desc,...
                            map('colWidth3'),measurement.Constant(i).Unit,...
                            map('colWidth4'),num2str(measurement.Constant(i).Value)};
                        if data{2} == ""; continue; end
                        printRow(fileId,data);
                    catch
                    end
                    printLineBreak(fileId);
                end
                
                %%% MEASURCHANNELS
                printLineBreak(fileId);
                printString(fileId,'**MEASURCHANNELS');
                printLineBreak(fileId);
                for i=1:numel(measurement.Measured)
                    try
                        data = {
                            map('colWidth1'),num2str(measurement.Measured(i).Name),...
                            map('colWidth2'),num2str(measurement.Measured(i).Desc),...
                            map('colWidth3'),num2str(measurement.Measured(i).Unit),...
                            map('colWidth4'),num2str(measurement.Measured(i).Factor),...
                            map('colWidth5'),num2str(measurement.Measured(i).MeasOffset),...
                            map('colWidth6'),num2str(measurement.Measured(i).PhysOffset),...
                            };
                        printRow(fileId,data);
                    catch
                    end
                    printLineBreak(fileId);
                end
                
                %%% MEASURDATA
                colWidth = 10;
                numPrec = 3;
                printLineBreak(fileId);
                printString(fileId,'**MEASURDATA');
                printLineBreak(fileId);
                idx = 1;
                while idx <= length(measurements(num).Measured(1).Data)
                    try
                        for i=1:length(measurements(num).Measured)
                            data = measurements(num).Measured(i).Data(idx);
                            if ~isempty(data)
                                printNumber(fileId,colWidth,numPrec,data);
                            else
                                printString(fileId,'NOTAVAIL')
                            end
                        end
                        printLineBreak(fileId);
                        idx = idx + 1;
                    catch
                    end
                end
                
                %%% MODELPARAMETERS
                printLineBreak(fileId);
                printString(fileId,'**MODELPARAMETERS');
                printLineBreak(fileId);
                
                for i=1:numel(nominalParams)
                    try
                        idx = find(strcmp({measurements(num).Constant.Name},nominalParams{i}));
                        data = {
                            map('colWidth1'),num2str(measurements(num).Constant(idx).Name),...
                            map('colWidth2'),num2str(measurements(num).Constant(idx).Desc),...
                            map('colWidth3'),num2str(measurements(num).Constant(idx).Unit),...
                            map('colWidth4'),num2str(measurements(num).Constant(idx).Value),...
                            };
                        printRow(fileId,data);
                    catch
                    end
                    printLineBreak(fileId);
                end
                printLineBreak(fileId);
                printString(fileId,'**MODELEND');
                printLineBreak(fileId);
                printString(fileId,'**END');
                fclose(fileId);
            end
        end
    end
    methods
        function FX = get.FX(meas); FX = getParameter(meas,'FX'); end
        function FYW = get.FYW(meas); FYW = getParameter(meas,'FYW'); end
        function FZW = get.FZW(meas); FZW = getParameter(meas,'FZW'); end
        function MXW = get.MXW(meas); MXW = getParameter(meas,'MXW'); end
        function MYW = get.MYW(meas); MYW = getParameter(meas,'MYW'); end
        function MZW = get.MZW(meas); MZW = getParameter(meas,'MZW'); end
        function LONGVEL = get.LONGVEL(meas); LONGVEL = getParameter(meas,'LONGVEL'); end
        function RUNTIME = get.RUNTIME(meas); RUNTIME = getParameter(meas,'RUNTIME'); end
        function WHROTSPD = get.WHROTSPD(meas); WHROTSPD = getParameter(meas,'WHROTSPD'); end
        function INCLANGL = get.INCLANGL(meas); INCLANGL = getParameter(meas,'INCLANGL'); end
        function INFLPRES = get.INFLPRES(meas); INFLPRES = getParameter(meas,'INFLPRES'); end
        function LONGSLIP = get.LONGSLIP(meas); LONGSLIP = getParameter(meas,'LONGSLIP'); end
        function FNOMIN = get.FNOMIN(meas); FNOMIN = getParameter(meas,'FNOMIN'); end
        function NOMPRES = get.NOMPRES(meas); NOMPRES = getParameter(meas,'NOMPRES'); end
        function SLIPANGL = get.SLIPANGL(meas); SLIPANGL = getParameter(meas,'SLIPANGL'); end
    end
    methods (Access = private)
        function param = getMetadataParameter(meas, name)
            metadata = [meas.Metadata];
            [N,M] = size(metadata);
            metadataNames = cell(N,M);
            for n = 1:N
                metadataNames(n,:) = {metadata(n,:).Name};
            end
            I = strcmp(metadataNames, name);
            param = metadata(I);
        end
        function param = getParameter(meas, name)
            idx = strcmp(meas.ConstantNames,name);
            if any(idx)
                param = meas.Constant(idx).Value;
            else
                idx = strcmp(meas.MeasuredNames,name);
                param = meas.Measured(idx).Data;
            end
        end
    end
end
