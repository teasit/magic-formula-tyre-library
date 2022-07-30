classdef FileReader < tydex.FileInterface
    %TYDEX.FILEREADER Reads TYDEX files into memory.
    
    properties
        % Prints warnings to console if any issues arose during reading.
        ShowWarnings logical = false
        
        % Measurements objects read from files.
        Measurement tydex.Measurement
        
        % Tyre Mmodel parameter objects read from files.
        ModelParameters tydex.ModelParameter
    end
    properties (Transient, Access = private)
        File char
        Text char
        Keywords cell
        KeywordsContentRange (:,2)
    end
    properties (Constant, Access = private)
        MandatoryKeywords cell = {'HEADER', 'END'}
    end
    methods
        function measurement = read(obj, file)
            arguments
                obj tydex.FileReader
                file char = char.empty
            end
            if isempty(file)
                file = obj.File;
            else
                obj.File = file;
            end
            obj.Measurement = tydex.Measurement();
            obj.ModelParameters = tydex.ModelParameter.empty();
            mustBeFile(file)
            readFileText(obj)
            
            findKeywords(obj)
            assert(hasMandatoryKeywords(obj), 'Mandatory keywords missing.')
            readKeywords(obj)
            
            measurement = obj.Measurement;
            measurement = measurement.index();
            obj.Measurement = measurement;
        end
    end
    methods (Access = private)
        function readFileText(obj)
            file = obj.File;
            text = fileread(file);
            obj.Text = text;
        end
        function readKeywords(obj)
            keywords = obj.Keywords;
            keywordsAll = obj.KeywordsAll;
            for i = 1:numel(keywordsAll)
                keyword = keywordsAll{i};
                if ~contains(keywords, keyword)
                    continue
                end
                readKeyword(obj, keyword)
            end
        end
        function readKeyword(obj, keyword)
            measurement = obj.Measurement;
            
            text = obj.Text;
            keywords = obj.Keywords;
            
            I = regexpi(keywords, ['^' keyword '$']);
            I = ~cellfun(@isempty, I);
            
            range = obj.KeywordsContentRange(I,:);
            text = text(range(1):range(2));
            text = strip(text);
            
            switch keyword
                case 'COMMENTS'
                    return
                case 'HEADER'
                    format = '%10s%30s%s';
                    scan = textscan(text, format, 'Delimiter', '\n');
                    scan = strtrim(scan);
                    vars = scan{1};
                    vals = scan{3};
                    for i = 1:numel(vars)
                        var = vars{i};
                        val = vals{i};
                        metadata = tydex.Metadata(var, val);
                        measurement.Metadata = [
                            measurement.Metadata; metadata];
                    end
                case 'CONSTANTS'
                    format = '%10s%30s%10s%f';
                    scan = textscan(text, format, 'Delimiter', '\n');
                    scan(1:3) = strtrim(scan(1:3));
                    vars = scan{1};
                    units = scan{3};
                    vals = scan{4};
                    for i = 1:numel(vars)
                        var = vars{i};
                        val = vals(i);
                        unit = units{i};
                        measured = tydex.ConstantParameter(var, unit, val);
                        measurement.Constant = [
                            measurement.Constant; measured];
                    end
                case 'MEASURCHANNELS'
                    format = '%10s%30s%10s%10f%10f%10f';
                    scan = textscan(text, format, 'Delimiter', '\n');
                    scan(1:3) = strtrim(scan(1:3));
                    vars = scan{1};
                    units = scan{3};
                    factors = scan{4};
                    offsetsMeasured = scan{5};
                    offsetsPhysical = scan{6};
                    for i = 1:numel(vars)
                        var = vars{i};
                        unit = units{i};
                        factor = factors(i);
                        offset1 = offsetsMeasured(i);
                        offset2 = offsetsPhysical(i);
                        measured = tydex.MeasuredParameter(...
                            var, unit, [], factor, offset1, offset2);
                        measurement.Measured = [
                            measurement.Measured; measured];
                    end
                case 'MEASURDATA'
                    measurement = obj.Measurement;
                    n = numel(measurement.Measured);
                    format = repmat('%10f', 1, n);
                    scan = textscan(text, format, 'Delimiter', '\n');
                    for i = 1:n
                        measured = measurement.Measured(i);
                        data = scan{i};
                        measured.Data = data;
                        measurement.Measured(i) = measured;
                    end
                case 'MODELPARAMETERS'
                    format = '%10s%30s%10s%10s';
                    scan = textscan(text, format, 'Delimiter', '\n');
                    scan = strtrim(scan);
                    vars = scan{1};
                    descs = scan{2};
                    units = scan{3};
                    vals = scan{4};
                    for i = 1:numel(vars)
                        var = vars{i};
                        val = vals{i};
                        [i0,i1] = regexp(val ,'\d+');
                        isNumeric = (i1-i0+1) == numel(val);
                        if isNumeric
                            val = str2double(val);
                        end
                        unit = units{i};
                        desc = descs{i};
                        param = tydex.ModelParameter(var, unit, val, desc);
                        obj.ModelParameters = [obj.ModelParameters; param];
                    end
                case {'MODELDEFINITION', 'MODELCOEFFICIENTS', ...
                        'MODELCHANNELS', 'MODELOUTPUTS', 'MODELEND', 'END'}
                    if obj.ShowWarnings
                        warning('Skipped TYDEX keyword ''%s''.\n', keyword)
                    end
                    return
                otherwise
                    error('Unknown keyword ''%s'' found.', keyword)
            end
            
            obj.Measurement = measurement;
        end
        function findKeywords(obj)
            text = obj.Text;
            [I0,I1] = regexpi(text, '[*]{2}\w*');
            n = numel(I0);
            keywords = cell(n,1);
            for i = 1:numel(I0)
                indices = I0(i):I1(i);
                keyword = text(indices);
                keywords{i} = keyword;
            end
            keywords = erase(keywords, '*');
            keywords = strtrim(keywords);
            keywords = upper(keywords);
            obj.Keywords = keywords;
            
            range0 = (I1+1)';
            range1 = [I0(2:end)-1 length(text)]';
            range = [range0 range1];
            obj.KeywordsContentRange = range;
        end
        function tf = hasMandatoryKeywords(obj)
            tf = true;
            keywords = obj.Keywords;
            keywordsMandatory = obj.MandatoryKeywords;
            for i = 1:numel(keywordsMandatory)
                expression = ['^' keywordsMandatory{i} '$'];
                I = regexpi(keywords, expression);
                keywordFound = any(~cellfun(@isempty, I));
                if ~keywordFound
                    tf = false;
                    return
                end
            end
        end
    end
end

