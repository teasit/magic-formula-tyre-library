classdef TyrePropertiesFileReader < handle
    %TYREPROPERTIESFILEREADER Can read a .tir file and parse it into a tire
    %model parameter set
    
    properties
        FullFilePath char = char.empty
        ModelParameters magicformula.v62.Parameters = magicformula.v62.Parameters.empty
    end
    
    methods (Access = private, Static)
        function filetext = removeCommentsFromText(filetext)
            sectionComment = '\$[-]+[-]*[\w\s]*\n'; % e.g. $-----...---units
            sectionHeader = '\[\w*\]\s*\n'; % e.g. %[MDI_HEADER]
            inlineComment = '\$[^\n]*';
            expressions = {sectionComment, sectionHeader, inlineComment};
            deleteIndices = false(size(filetext));
            for j = 1:numel(expressions)
                [i0, i1] = regexp(filetext, expressions{j});
                for i = 1:numel(i0)
                    range = i0(i):i1(i);
                    deleteIndices(range) = true;
                end
            end
            filetext(deleteIndices) = [];
        end
    end
    
    methods
        function obj = TyrePropertiesFileReader(file)
            arguments
                file {ischar} = char.empty
            end
            if ~isempty(file)
                obj.parse(file)
                obj.FullFilePath = file;
            end
        end
        
        function [params, errors] = parse(obj, file)
            if ~isfile(file)
                error("File '%s' does not exist!", file)
            end
            filetext = fileread(file);
            filetext = obj.removeCommentsFromText(filetext);
            
            formatSpec = '%s%s%s';
            scan = textscan(filetext, formatSpec, ...
                'EndOfLine', '\n', ...
                'Delimiter', {'=','$'}, ...
                'MultipleDelimsAsOne', false);
            scan = strtrim(scan);
            
            paramNames = scan{1};
            paramValues = scan{2};
            
            params_ = magicformula.v62.Parameters;
            numParams = numel(paramNames);
            clear errors
            errors(1:numParams) = exceptions.UnknownModelParameter('');
            for i = 1:numParams
                try
                    name = paramNames{i};
                    value = paramValues{i};
                    valueNum = str2double(value);
                    if ~isnan(valueNum)
                        value = valueNum;
                    else
                        singleQuote = char(39);
                        value = strrep(value, singleQuote, '');
                    end
                    params_.(name).Value = value;
                catch cause
                    exception = exceptions.UnknownModelParameter(name);
                    exception = addCause(exception, cause);
                    errors(i) = exception;
                end
            end
            noError = strcmp({errors.ParameterName}, '');
            errors(noError) = [];
            obj.ModelParameters = params_;
            
            if nargout > 0
                params = params_;
            end
        end
    end
end

