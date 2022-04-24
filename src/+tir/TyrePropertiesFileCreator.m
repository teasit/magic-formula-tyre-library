classdef TyrePropertiesFileCreator
    %TYREPROPERTIESFILECREATOR Interface for easily creating ".tir" files.
    %   Please pass the fileId that is acquired after opening a file using
    %   the FOPEN function.
    
    properties (Access = private)
        LengthSeparatorColumn = 71
        MaxCharsNumbers = 13
        ColumnWidthParameterValue = 18
        ColumnWidthParameterName = 29
    end 
    
    properties (Access = public)
        FileId
    end
    
    methods
        function obj = TyrePropertiesFileCreator(fileId)
            obj.FileId = fileId;
        end
        
        function printSection(obj,name,printSeparator)
            if ~exist('printSeparator','var')
                printSeparator = true;
            end
            if printSeparator
                obj.printSectionSeparator(name)
            end
            obj.printSectionHeader(name)
        end
        
        function printParameter(obj, name, value, comment)
            if isempty(value)
                fprintf("Skipping empty parameter '%s'\n",name) 
                return
            end
            if ~exist('comment','var')
                comment = '';
            else
                comment = ['$' comment];
            end
            value = obj.formatNumber(value);
            data = {
                obj.ColumnWidthParameterName
                name
                '= '
                obj.ColumnWidthParameterValue
                value
                comment
                };
            fprintf(obj.FileId,'%-*s%s%-*s%-s\n',data{:}); 
        end
    end
    
    methods (Access = private)
        function printSectionSeparator(obj,name)
            name = lower(name);
            name = regexprep(name, '_', ' ');
            numHypens = obj.LengthSeparatorColumn - strlength(name) -1;
            str = "$";
            for i = 1:numHypens
                str = append(str,'-');
            end
            str = append(str,name);
            fprintf(obj.FileId,'%-s\n',str);
        end
        
        function printSectionHeader(obj, name)
            name = upper(name);
            name = regexprep(name, ' ', '_');
            str = ['[' name ']'];
            fprintf(obj.FileId,'%-s\n',str);
        end
        
        function value = formatNumber(obj, value)
            try value = num2str(value); catch; end
            if strlength(value) > obj.MaxCharsNumbers
                value = extractBefore(value, obj.MaxCharsNumbers);
            end
        end
    end
end

