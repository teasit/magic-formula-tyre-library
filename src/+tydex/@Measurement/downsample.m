function meas = downsample(meas,n,phase)
    arguments
        meas tydex.Measurement
        n double
        phase double
    end
    for num = 1:numel(meas)
        for i = 1:numel(meas(num).Measured)
            downsampled = downsample(meas(num).Measured(i).Data,n,phase);
            meas(num).Measured(i).Data = downsampled;
        end
    end
end