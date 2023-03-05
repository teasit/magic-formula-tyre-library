classdef FSAETTC_SI_ISO_Mat < tydex.Parser
    properties (Access = protected)
        SteadyStateTolerances struct = struct(...
            'FZW',      150, ...    % [N]
            'INFLPRES', 5,   ...    % [kPa]
            'INCLANGL', 0.2, ...    % [deg]
            'SLIPANGL', 0.2)        % [deg]
    end
    methods (Static, Access = public)
        function measurements = fixSigns(measurements)
            %FIXSIGNS Convert SAE to ISO coordinates.
            arguments
                measurements tydex.Measurement
            end
            for num = 1:numel(measurements)
                measurement = measurements(num);
                for i = 1:numel(measurement.Measured)
                    param = measurement.Measured(i);
                    name = param.Name;
                    switch name
                        case {'SLIPANGL','FYW','MYW','MZW'}
                            param.Data = -param.Data;
                        case 'FZW'
                            param.Data = abs(param.Data);
                    end
                    measurement.Measured(i) = param;
                end
                for i = 1:numel(measurement.Constant)
                    param = measurement.Constant(i);
                    name = param.Name;
                    switch name
                        case {'SLIPANGL','FYW','MYW','MZW'}
                            param.Value = -param.Value;
                        case 'FZW'
                            param.Value = abs(param.Value);
                    end
                    measurement.Constant(i) = param;
                end
                measurements(num) = measurement;
            end
        end
        function measurements = fixUnits(measurements)
            %FIXUNITS Convert to base SI units.
            arguments
                measurements tydex.Measurement
            end
            import tydex.parsers.FSAETTC_SI_ISO_Mat.convertUnit
            
            for num = 1:numel(measurements)
                measurement = measurements(num);
                for i = 1:numel(measurement.Measured)
                    param = measurement.Measured(i);
                    [unit,factor] = convertUnit(param.Unit);
                    param.Unit = unit;
                    param.Data = param.Data*factor;
                    measurement.Measured(i) = param;
                end
                for i = 1:numel(measurement.Constant)
                    param = measurement.Constant(i);
                    [unit,factor] = convertUnit(param.Unit);
                    param.Unit = unit;
                    param.Value = param.Value*factor;
                    measurement.Constant(i) = param;
                end
                for i = 1:numel(measurement.ModelParameters)
                    param = measurement.ModelParameters(i);
                    [unit,factor] = convertUnit(param.Unit);
                    param.Unit = unit;
                    param.Value = param.Value*factor;
                    measurement.ModelParameters(i) = param;
                end
                measurements(num) = measurement;
            end
        end
        function [newUnit,factor] = convertUnit(unit)
            arguments
                unit char
            end
            switch unit
                case 'deg'
                    newUnit = 'rad';
                    factor = pi/180;
                case 'km/h'
                    newUnit = 'm/s';
                    factor = 1/3.6;
                case 'kPa'
                    newUnit = 'Pa';
                    factor = 1000;
                case {'s', 'N', 'Nm', '-', 'm/s', 'rad', 'rad/s'}
                    newUnit = unit;
                    factor = 1;
                otherwise
                    warning(['Unkown unit "' unit '"!' newline() ...
                        'This may result in failure of the solver.'])
            end
        end
    end
    methods (Access = protected)
        function [measurements, bins, binvalues] = parse(obj,file,options)
            arguments
                obj
                file char {mustBeFile}
                options.MinPeakTime {isinteger} = 5
            end
            import tydex.ConstantParameter
            import tydex.MeasuredParameter
            import tydex.Measurement
            import tydex.Metadata
            import tydex.ModelParameter
            
            data = load(file);
            [~,fileName] = fileparts(file);
            
            isCorneringTest = all(data.SL == 0);
            isDriveBrakeTest = ~isCorneringTest;
            
            [counts.FZW,     edges.FZW]      = histcounts(data.FZ);
            [counts.INFLPRES,edges.INFLPRES] = histcounts(data.P);
            [counts.INCLANGL,edges.INCLANGL] = histcounts(data.IA);
            [counts.SLIPANGL,edges.SLIPANGL] = histcounts(data.SA);
            [counts.LONGSLIP,edges.LONGSLIP] = histcounts(data.SL);
            
            dt = data.ET(2) - data.ET(1);
            nMinPeakHeight = options.MinPeakTime/dt;
            [~, locs.FZW] = findpeaks([counts.FZW(2) counts.FZW counts.FZW(end-1)], ...
                'MinPeakHeight', nMinPeakHeight);
            [~, locs.INFLPRES] = findpeaks([counts.INFLPRES(2) counts.INFLPRES counts.INFLPRES(end-1)], ...
                'MinPeakHeight', nMinPeakHeight);
            [~, locs.INCLANGL] = findpeaks([counts.INCLANGL(2) counts.INCLANGL counts.INCLANGL(end-1)], ...
                'MinPeakHeight', nMinPeakHeight);
            if isDriveBrakeTest
                [~, locs.SLIPANGL] = findpeaks([counts.SLIPANGL(2) counts.SLIPANGL counts.SLIPANGL(end-1)], ...
                    'MinPeakHeight', nMinPeakHeight);
            end
            
            binvalues.FZW       = unique(round(abs(edges.FZW(locs.FZW)),2));
            binvalues.INFLPRES  = unique(round(edges.INFLPRES(locs.INFLPRES),2));
            binvalues.INCLANGL  = unique(round(edges.INCLANGL(locs.INCLANGL),2));
            if isDriveBrakeTest
                binvalues.SLIPANGL  = unique(round(edges.SLIPANGL(locs.SLIPANGL),2));
            end
            
            eps = obj.SteadyStateTolerances;
            bins.FZW = abs(data.FZ) > (abs(binvalues.FZW)-eps.FZW) ...
                & abs(data.FZ) < (abs(binvalues.FZW)+eps.FZW);
            bins.INCLANGL = abs(data.IA) > (abs(binvalues.INCLANGL)-eps.INCLANGL) ...
                & abs(data.IA) < (abs(binvalues.INCLANGL)+eps.INCLANGL);
            bins.INFLPRES = abs(data.P) > (binvalues.INFLPRES-eps.INFLPRES) ...
                & abs(data.P) < (binvalues.INFLPRES+eps.INFLPRES);
            if isDriveBrakeTest
                bins.SLIPANGL = abs(data.SA) > (abs(binvalues.SLIPANGL)-eps.SLIPANGL) ...
                    & abs(data.SA) < (abs(binvalues.SLIPANGL)+eps.SLIPANGL);
            end
            
            if isDriveBrakeTest
                measurements(length(binvalues.FZW)...
                    *length(binvalues.INCLANGL)...
                    *length(binvalues.SLIPANGL)...
                    *length(binvalues.INFLPRES))...
                    = Measurement();
            else
                measurements(length(binvalues.FZW)...
                    *length(binvalues.INCLANGL)...
                    *length(binvalues.INFLPRES))...
                    = Measurement();
            end
            
            num = 1;
            if isDriveBrakeTest
                for i1 = 1:length(binvalues.FZW)
                    for i2 = 1:length(binvalues.INCLANGL)
                        for i3 = 1:length(binvalues.INFLPRES)
                            for i4 = 1:length(binvalues.SLIPANGL)
                                I = bins.FZW(:,i1)       &...
                                    bins.INCLANGL(:,i2)  &...
                                    bins.INFLPRES(:,i3)  &...
                                    bins.SLIPANGL(:,i4);
                                
                                LONGVEL     = MeasuredParameter('LONGVEL',  'km/h',  data.V(I));
                                WHROTSPD    = MeasuredParameter('WHROTSPD', 'rad/s', data.N(I)*2*pi);
                                FX          = MeasuredParameter('FX',       'N',     data.FX(I));
                                FYW         = MeasuredParameter('FYW',      'N',     data.FY(I));
                                MXW         = MeasuredParameter('MXW',      'Nm',    data.MX(I));
                                MZW         = MeasuredParameter('MZW',      'Nm',    data.MZ(I));
                                RUNTIME     = MeasuredParameter('RUNTIME',  's',     data.ET(I));
                                LONGSLIP    = MeasuredParameter('LONGSLIP', '-',     data.SL(I));
                                SLIPANGL    = MeasuredParameter('SLIPANGL', 'deg',   data.SA(I));
                                INCLANGL    = MeasuredParameter('INCLANGL', 'deg',   data.IA(I));
                                INFLPRES    = MeasuredParameter('INFLPRES', 'kPa',   data.P(I));
                                FZW         = MeasuredParameter('FZW',      'N',     data.FZ(I));
                                measurements(num).Measured = [
                                    LONGVEL RUNTIME INFLPRES WHROTSPD LONGSLIP FX FYW FZW MXW MZW SLIPANGL INCLANGL
                                    ];
                                
                                FZW = ConstantParameter('FZW',      'N',    binvalues.FZW(i1));
                                INCLANGL = ConstantParameter('INCLANGL', 'deg',  binvalues.INCLANGL(i2));
                                INFLPRES = ConstantParameter('INFLPRES', 'kPa',  binvalues.INFLPRES(i3));
                                SLIPANGL = ConstantParameter('SLIPANGL', 'deg',  binvalues.SLIPANGL(i4));
                                measurements(num).Constant = [
                                    FZW INCLANGL INFLPRES SLIPANGL
                                    ];
                                
                                FNOMIN  = ModelParameter('FNOMIN', 'N', binvalues.FZW(end));
                                NOMPRES = ModelParameter('NOMPRES', 'kPa', binvalues.INFLPRES(end));
                                measurements(num).ModelParameters = [
                                    FNOMIN NOMPRES
                                    ];
                                
                                RELEASE = Metadata('RELEASE','1.3');
                                MEASID = Metadata('MEASID', fileName);
                                SUPPLIER = Metadata('SUPPLIER','FSAE TTC');
                                
                                measurements(num).Metadata = [
                                    RELEASE
                                    MEASID
                                    SUPPLIER
                                    ];
                                
                                num = num+1;
                            end
                        end
                    end
                end
            else
                for i1 = 1:length(binvalues.FZW)
                    for i2 = 1:length(binvalues.INCLANGL)
                        for i3 = 1:length(binvalues.INFLPRES)
                            I = bins.FZW(:,i1)       &...
                                bins.INCLANGL(:,i2)  &...
                                bins.INFLPRES(:,i3);
                            
                            LONGVEL     = MeasuredParameter('LONGVEL',  'km/h',  data.V(I));
                            WHROTSPD    = MeasuredParameter('WHROTSPD', 'rad/s', data.N(I)*2*pi);
                            FX          = MeasuredParameter('FX',       'N',     data.FX(I));
                            FYW         = MeasuredParameter('FYW',      'N',     data.FY(I));
                            MXW         = MeasuredParameter('MXW',      'Nm',    data.MX(I));
                            MZW         = MeasuredParameter('MZW',      'Nm',    data.MZ(I));
                            RUNTIME     = MeasuredParameter('RUNTIME',  's',     data.ET(I));
                            LONGSLIP    = MeasuredParameter('LONGSLIP', '-',     data.SL(I));
                            SLIPANGL    = MeasuredParameter('SLIPANGL', 'deg',   data.SA(I));
                            INCLANGL    = MeasuredParameter('INCLANGL', 'deg',   data.IA(I));
                            INFLPRES    = MeasuredParameter('INFLPRES', 'kPa',   data.P(I));
                            FZW         = MeasuredParameter('FZW',      'N',     data.FZ(I));
                            measurements(num).Measured = [
                                LONGVEL RUNTIME WHROTSPD LONGSLIP SLIPANGL FZW INFLPRES INCLANGL FX FYW MXW MZW
                                ];
                            
                            FZW = ConstantParameter('FZW',      'N',    binvalues.FZW(i1));
                            LONGSLIP = ConstantParameter('LONGSLIP', '-',    0);
                            INCLANGL = ConstantParameter('INCLANGL', 'deg',  binvalues.INCLANGL(i2));
                            INFLPRES = ConstantParameter('INFLPRES', 'kPa',  binvalues.INFLPRES(i3));
                            measurements(num).Constant = [
                                FZW INCLANGL INFLPRES LONGSLIP
                                ];
                            
                            FNOMIN  = ModelParameter('FNOMIN', 'N', binvalues.FZW(end));
                            NOMPRES = ModelParameter('NOMPRES', 'kPa', binvalues.INFLPRES(end));
                            measurements(num).ModelParameters = [
                                FNOMIN NOMPRES
                                ];
                            
                            RELEASE = Metadata('RELEASE','1.3');
                            MEASID = Metadata('MEASID', fileName);
                            SUPPLIER = Metadata('SUPPLIER','FSAE TTC');
                            
                            measurements(num).Metadata = [
                                RELEASE
                                MEASID
                                SUPPLIER
                                ];
                            
                            num = num+1;
                        end
                    end
                end
            end
            measurements = obj.fixUnits(measurements);
            measurements = obj.fixSigns(measurements);
        end
    end
end
