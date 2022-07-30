classdef FileWriter < tydex.FileInterface
    %TYDEX.FILEWRITER Writes TYDEX measurement objects to file.
    properties
        Measurements tydex.Measurement
    end
    methods
        function write(obj, dirpath)
            %WRITE Saves objects as TYDEX files (.tdx)
            measurements = obj.Measurements;
            if isempty(measurements)
                error('No measurements to write to files.')
            end
            if ~isfolder(dirpath)
                error('''%s'' is not a directory.')
            end
            
            widths = obj.ColumnWidths;
            
            printRow        = @(fileId,data) fprintf(fileId,'%-*s%-*s%-*s%-*s%-*s%-*s%-*s',data{:});
            printString     = @(fileId,str) fprintf(fileId,'%-s',str);
            printNumber     = @(fileId,width,prec,num) fprintf(fileId,'%-*.*f',width,prec,num);
            printLineBreak  = @(fileId) fprintf(fileId,'\n');
            
            comment = [...
                'https://github.com/teasit/magic-formula-tyre-library' newline() ...
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
                            widths(1), string(measurement.Metadata(idx).Name),...
                            widths(2), string(measurement.Metadata(idx).Desc),...
                            widths(4), string(measurement.Metadata(idx).Value)};
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
                            widths(1), measurement.Constant(i).Name,...
                            widths(2), measurement.Constant(i).Desc,...
                            widths(3), measurement.Constant(i).Unit,...
                            widths(4), num2str(measurement.Constant(i).Value)};
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
                            widths(1), num2str(measurement.Measured(i).Name),...
                            widths(2), num2str(measurement.Measured(i).Desc),...
                            widths(3), num2str(measurement.Measured(i).Unit),...
                            widths(4), num2str(measurement.Measured(i).Factor),...
                            widths(5), num2str(measurement.Measured(i).MeasOffset),...
                            widths(6), num2str(measurement.Measured(i).PhysOffset),...
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
                            widths(1), num2str(measurements(num).Constant(idx).Name),...
                            widths(2), num2str(measurements(num).Constant(idx).Desc),...
                            widths(3), num2str(measurements(num).Constant(idx).Unit),...
                            widths(4), num2str(measurements(num).Constant(idx).Value),...
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
end

