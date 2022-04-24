function len = length(meas)
arguments
    meas tydex.Measurement
end
len = 0;
for num = 1:numel(meas)
    len = len + length(meas(num).Measured(1).Data);
end
end
