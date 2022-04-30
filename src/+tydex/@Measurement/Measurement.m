classdef Measurement
    %MEASUREMENT TYDEX 1.3 formatted Measurement (Tyre Data Exchange Format).
    properties (Access = public)
        Metadata tydex.Metadata
        Constant tydex.ConstantParameter
        Measured tydex.MeasuredParameter
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
        meas = index(meas)
        len = length(meas)
        meas = downsample(meas,n,phase)
        save(meas,dirpath)
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
    methods (Access = private)
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
