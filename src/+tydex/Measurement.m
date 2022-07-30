classdef Measurement
    %MEASUREMENT TYDEX 1.3 formatted Measurement (Tyre Data Exchange Format)
    properties (Access = public)
        Metadata (:,1) tydex.Metadata
        Constant (:,1) tydex.ConstantParameter
        Measured (:,1) tydex.MeasuredParameter
    end
    properties (Access = private)
        ConstantNames cell
        MeasuredNames cell
    end
    properties (Dependent)
        INCLANGL
        INFLPRES
        LONGSLIP
        FNOMIN
        NOMPRES
        SLIPANGL
        LONGVEL
        RUNTIME
        WHROTSPD
        FX
        FYW
        FZW
        MXW
        MYW
        MZW
    end
    methods
        function measurements = index(measurements)
            arguments
                measurements tydex.Measurement
            end
            for num = 1:numel(measurements)
                measurement = measurements(num);
                measurement.ConstantNames = {measurement.Constant.Name};
                measurement.MeasuredNames = {measurement.Measured.Name};
                measurements(num) = measurement;
            end
        end
        function len = length(measurements)
            %LENGTH Returns length of all measurements combined
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
        function measurements = downsample(measurements, n, phase)
            %DOWNSAMPLE Wrapper for MATLAB function downsample
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
        function save(measurements,dirpath)
            %SAVE Saves objects as TYDEX files (.tdx)
            arguments
                measurements tydex.Measurement
                dirpath char {mustBeFolder} = uigetdir()
            end
            writer = tydex.FileWriter();
            writer.Measurements = measurements;
            writer.write(dirpath)
        end
    end
    methods
        function FX = get.FX(meas); FX = getParameter(meas,'FX'); end
        function FYW = get.FYW(meas); FYW = getParameter(meas,'FYW'); end
        function FZW = get.FZW(meas); FZW = getParameter(meas,'FZW'); end
        function MXW = get.MXW(meas); MXW = getParameter(meas,'MXW'); end
        function MYW = get.MYW(meas); MYW = getParameter(meas,'MYW'); end
        function MZW = get.MZW(meas); MZW = getParameter(meas,'MZW'); end
        function LONGVEL = get.LONGVEL(meas); LONGVEL = getParameter(meas,'LONGVEL'); end
        function RUNTIME = get.RUNTIME(meas); RUNTIME = getParameter(meas,'RUNTIME'); end
        function WHROTSPD = get.WHROTSPD(meas); WHROTSPD = getParameter(meas,'WHROTSPD'); end
        function INCLANGL = get.INCLANGL(meas); INCLANGL = getParameter(meas,'INCLANGL'); end
        function INFLPRES = get.INFLPRES(meas); INFLPRES = getParameter(meas,'INFLPRES'); end
        function LONGSLIP = get.LONGSLIP(meas); LONGSLIP = getParameter(meas,'LONGSLIP'); end
        function FNOMIN = get.FNOMIN(meas); FNOMIN = getParameter(meas,'FNOMIN'); end
        function NOMPRES = get.NOMPRES(meas); NOMPRES = getParameter(meas,'NOMPRES'); end
        function SLIPANGL = get.SLIPANGL(meas); SLIPANGL = getParameter(meas,'SLIPANGL'); end
    end
    methods (Hidden)
        function param = getMetadataParameter(meas, name)
            metadata = [meas.Metadata];
            [N,M] = size(metadata);
            metadataNames = cell(N,M);
            for n = 1:N
                metadataNames(n,:) = {metadata(n,:).Name};
            end
            I = strcmp(metadataNames, name);
            param = metadata(I);
        end
        function param = getParameter(meas, name)
            idx = strcmp(meas.ConstantNames,name);
            if any(idx)
                param = meas.Constant(idx).Value;
            else
                idx = strcmp(meas.MeasuredNames,name);
                param = meas.Measured(idx).Data;
            end
        end
    end
end
