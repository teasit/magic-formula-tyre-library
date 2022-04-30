function len = length(measurements)
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
