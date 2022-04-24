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

    