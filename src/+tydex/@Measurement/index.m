function meas = index(meas)
arguments
    meas tydex.Measurement
end
for num = 1:numel(meas)
    meas(num).ConstantNames = {meas(num).Constant.Name};
    meas(num).MeasuredNames = {meas(num).Measured.Name};
end
end
