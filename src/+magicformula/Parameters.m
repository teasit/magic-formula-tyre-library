classdef (Abstract, Hidden) Parameters < matlab.mixin.CustomDisplay
    %MAGICFORMULA.PARAMETERS
    methods
        function tf = eq(params1, params2)
            tf = true;
            
            n1 = numel(params1);
            n2 = numel(params2);
            
            if n1 ~= n2
                tf = false;
                return
            end
            
            mc = metaclass(params1);
            names = {mc.PropertyList.Name};
            for i = 1:n1
                name = names{i};
                try
                    param1 = params1.(name);
                    param2 = params2.(name);
                    value1 = param1.Value;
                    value2 = param2.Value;
                    if value1 ~= value2
                        tf = false;
                        return
                    end
                catch
                    tf = false;
                    return
                end
            end
        end
        function tf = ne(params1, params2)
            tf = eq(params1, params2);
            tf = ~tf;
        end
        function p = struct(params)
            paramNames = fieldnames(params);
            p = struct;
            for i = 1:length(paramNames)
                name = paramNames{i};
                value = params.(name).Value;
                if strcmp(name, 'TYRESIDE') && ischar(value)
                    value = strcmpi(value, 'RIGHT');
                end
                p.(name) = value;
            end
        end
        function saveFittingSettings(params, file)
            exporter = magicformula.ParameterFittingSettingsExporter();
            exporter.export(file, params);
        end
        function params = readFittingSettings(params, file)
            importer = magicformula.ParameterFittingSettingsImporter();
            params = importer.import(file, params);
        end
    end
    methods (Access = protected)
        function groups = getPropertyGroups(obj)
            if isscalar(obj)
                mc = metaclass(obj);
                propList = {mc.PropertyList.Name};
                propListStruct = struct();
                for i = 1:length(propList)
                    propName = propList{i};
                    propValue = obj.(propName).Value;
                    propListStruct.(propName) = propValue;
                end
                
                groups = matlab.mixin.util.PropertyGroup(propListStruct);
            else
                groups = getPropertyGroups@matlab.mixin.CustomDisplay(obj);
            end
        end
    end
end

