classdef (Hidden) ParameterFittingSettingsImporter < handle
    %PARAMETERFITTINGSETTINGSEXPORTER Reads min/max/fixed from text file.
    
    methods (Static)
        function params = import(file, params)
            arguments
                file char
                params magicformula.Parameters
            end
            fmtRead = '| %s | %f | %f | %s |';
            fileID = fopen(file, 'r');
            try
                data = textscan(fileID, fmtRead, 'HeaderLines', 2);
                fclose(fileID);
            catch exception
                fclose(fileID);
                rethrow(exception)
            end
            
            vars = data{1};
            mins = data{2};
            maxs = data{3};
            fixs = data{4};
            fixs = strcmpi(fixs, 'true');
            
            for i = 1:numel(vars)
                var = vars{i};
                param = params.(var);
                param.Min = mins(i);
                param.Max = maxs(i);
                param.Fixed = fixs(i);
                params.(var) = param;
            end
        end
    end
end
