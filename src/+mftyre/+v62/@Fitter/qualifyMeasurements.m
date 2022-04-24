function qualifyMeasurements(fitter)
% QUALITFYMEASUREMENTS  This function searches all Measurements stored in
% the Tyre instance attached to the fitter. It then writes to the
% FitModeFlags property of the fitter a matrix that can be used to get the
% indices to measurement data suitable for certain Fitting stages (Fy0 Fx0,
% Mz0 etc).
arguments
    fitter mftyre.v62.Fitter
end

meas = fitter.Measurements;
if isempty(meas); return; end

numMeas = numel(meas);

%% Creating keys for map
modes = enumeration(mftyre.v62.FitMode.Fy0);
keys = cell(numel(modes),1);
for i = 1:numel(modes)
    keys{i} = char(modes(i));
end
vals = cell(size(keys));

%% Fx0
idx = zeros(numMeas,1);
for i = 1:numMeas
    const = meas(i).Constant;
    I = strcmp({const.Name},'SLIPANGL');
    if any(I) && const(I).Value == 0; idx(i) = 1; end
end
key = find(strcmp(keys,char(mftyre.v62.FitMode.Fx0)),1);
vals{key} = find(idx);

%% Fy0 + Mz0
idx = zeros(numMeas,1);
for i = 1:numMeas
    const = meas(i).Constant;
    I = strcmp({const.Name},'LONGSLIP');
    if any(I) && const(I).Value == 0; idx(i) = 1; end
end
key = find(strcmp(keys,char(mftyre.v62.FitMode.Fy0)),1);
vals{key} = find(idx);
key = find(strcmp(keys,char(mftyre.v62.FitMode.Mz0)),1);
vals{key} = find(idx);

%% Mz + Fx + Fy + Fz + Mx + My (Combined Slip)
idx = zeros(numMeas,1);
for i = 1:numMeas
    const = meas(i).Constant;
    I1 = strcmp({const.Name},'LONGSLIP');
    I2 = strcmp({const.Name},'SLIPANGL');
    if (any(I1) && const(I1).Value == 0) || (any(I2) && const(I2).Value == 0)
        idx(i) = 0;
    else
        idx(i) = 1;
    end
end
key = find(strcmp(keys,char(mftyre.v62.FitMode.Mz)),1);
vals{key} = find(idx);
key = find(strcmp(keys,char(mftyre.v62.FitMode.Fx)),1);
vals{key} = find(idx);
key = find(strcmp(keys,char(mftyre.v62.FitMode.Fy)),1);
vals{key} = find(idx);
key = find(strcmp(keys,char(mftyre.v62.FitMode.Mx)),1);
vals{key} = find(idx);
key = find(strcmp(keys,char(mftyre.v62.FitMode.My)),1);
vals{key} = find(idx);
key = find(strcmp(keys,char(mftyre.v62.FitMode.Fz)),1);
vals{key} = find(idx);

%% Creating map
fitter.FitModeFlags = containers.Map(keys,vals);
end
