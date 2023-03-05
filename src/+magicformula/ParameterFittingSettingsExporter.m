classdef (Hidden) ParameterFittingSettingsExporter < handle
    %PARAMETERFITTINGSETTINGSEXPORTER Writes min/max/fixed to text file.
    
    methods (Static)
        function export(file, params)
            arguments
                file char
                params magicformula.Parameters
            end
            widthTableColumn = 20;
            w = num2str(widthTableColumn);
            fmtHdr = ['| %-' w 's | %-' w 's | %-' w 's | %-' w 's |\n'];
            fmtVal = ['| %-' w 's | %-' w 'E | %-' w 'E | %-' w 's |\n'];
            
            mc = metaclass(params);
            defaults = [mc.PropertyList.DefaultValue];
            classFittable = 'magicformula.ParameterFittable';
            isFittable = false(size(defaults));
            for i = 1:numel(defaults)
                default = defaults(i);
                isFittable(i) = isa(default, classFittable);
            end
            vars = properties(params);
            vars = vars(isFittable);
            vars = sort(vars);
            
            [mins,maxs,fixs] = deal(cell(size(vars)));
            for i = 1:numel(vars)
                var = vars{i};
                param = params.(var);
                mins{i} = param.Min;
                maxs{i} = param.Max;
                fixs{i} = mat2str(param.Fixed);
            end
            
            headers = {'Parameter'; 'Min'; 'Max'; 'Fixed'};
            
            dashes = repmat('-', 1, widthTableColumn);
            dashes = repmat({dashes}, 4, 1);
            
            data = [vars mins maxs fixs];
            data = data';
            
            fileID = fopen(file, 'w');
            try
                fprintf(fileID, fmtHdr, headers{:});
                fprintf(fileID, fmtHdr, dashes{:});
                fprintf(fileID, fmtVal, data{:});
                fclose(fileID);
            catch exception
                fclose(fileID);
                rethrow(exception)
            end
        end
    end
end

