function measurements = downsample(measurements,n,phase)
    arguments
        measurements tydex.Measurement
        n double
        phase double
    end
    for num = 1:numel(measurements)
        measurement = measurements(num);
        for i = 1:numel(measurement.Measured)
            measured = measurement.Measured(i);
            data = measured.Data;
            downsampled = downsample(data, n, phase);
            measurements(num).Measured(i).Data = downsampled;
        end
    end
end