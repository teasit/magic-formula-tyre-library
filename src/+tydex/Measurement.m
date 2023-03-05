classdef Measurement
    %MEASUREMENT TYDEX 1.3 formatted Measurement (Tyre Data Exchange Format)
    properties (Access = public)
        Metadata (:,1) tydex.Metadata
        Constant (:,1) tydex.ConstantParameter
        Measured (:,1) tydex.MeasuredParameter
        ModelParameters (:,1) tydex.ModelParameter
    end
    properties (Access = private)
        ConstantNames cell
        MeasuredNames cell
        ModelParameterNames cell
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
        function obj = Measurement(file)
            arguments
                file char = []
            end
            if isempty(file)
                return
            else
                mustBeFile(file)
                isTYDEX = endsWith(file, '.tdx', 'IgnoreCase', true);
                assert(isTYDEX, 'Must end with ''*.tdx''!')
            end
            reader = tydex.FileReader();
            obj = reader.read(file);
        end
        function measurements = index(measurements)
            arguments
                measurements tydex.Measurement
            end
            for num = 1:numel(measurements)
                measurement = measurements(num);
                measurement.ConstantNames = {measurement.Constant.Name};
                measurement.MeasuredNames = {measurement.Measured.Name};
                measurement.ModelParameterNames = {measurement.ModelParameters.Name};
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
        function [SX,SA,FZ,IP,IA,VX,FX,FY,MZ,MY,MX,W,T] = unpack(measurement)
            arguments
                measurement tydex.Measurement {mustBeScalarOrEmpty}
            end
            if isempty(measurement)
                return
            end
            SX = measurement.LONGSLIP;
            SA = measurement.SLIPANGL;
            FZ = measurement.FZW;
            IP = measurement.INFLPRES;
            IA = measurement.INCLANGL;
            VX = measurement.LONGVEL;
            FX = measurement.FX;
            FY = measurement.FYW;
            MZ = measurement.MZW;
            MY = measurement.MYW;
            MX = measurement.MXW;
            W = measurement.WHROTSPD;
            T = measurement.RUNTIME;
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
            isConstant = strcmp(meas.ConstantNames,name);
            isMeasured = strcmp(meas.MeasuredNames,name);
            isMdlParam = strcmp(meas.ModelParameterNames,name);
            if any(isConstant)
                param = meas.Constant(isConstant).Value;
            elseif any(isMeasured)
                param = meas.Measured(isMeasured).Data;
            elseif any(isMdlParam)
                param = meas.ModelParameters(isMdlParam).Value;
            else
                param = [];
            end
        end
    end
end
