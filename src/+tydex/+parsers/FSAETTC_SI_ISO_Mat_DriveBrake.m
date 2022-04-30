classdef FSAETTC_SI_ISO_Mat_DriveBrake < tydex.parsers.FSAETTC_SI_ISO_Mat
    methods (Access = protected)
        function [measurements, bins, binvalues] = parse(obj,file)
            arguments
                obj
                file char {mustBeFile}
            end
            import tydex.ConstantParameter
            import tydex.MeasuredParameter
            import tydex.Measurement
            import tydex.Metadata
            
            data = load(file);
            [~,fileName] = fileparts(file);
            
            [counts.FZW,     edges.FZW]      = histcounts(data.FZ);
            [counts.INFLPRES,edges.INFLPRES] = histcounts(data.P);
            [counts.INCLANGL,edges.INCLANGL] = histcounts(data.IA);
            [counts.SLIPANGL,edges.SLIPANGL] = histcounts(data.SA);
            
            tMinPeak = 5;  % (sec) minimum time to count as steady-state
            dt = data.ET(2) - data.ET(1);
            nMinPeakHeight = tMinPeak/dt;
            [~, locs.FZW]       = findpeaks([counts.FZW(2)      counts.FZW counts.FZW(end-1)],              'MinPeakHeight', nMinPeakHeight);
            [~, locs.INFLPRES]  = findpeaks([counts.INFLPRES(2) counts.INFLPRES counts.INFLPRES(end-1)],    'MinPeakHeight', nMinPeakHeight);
            [~, locs.INCLANGL]  = findpeaks([counts.INCLANGL(2) counts.INCLANGL counts.INCLANGL(end-1)],    'MinPeakHeight', nMinPeakHeight);
            [~, locs.SLIPANGL]  = findpeaks([counts.SLIPANGL(2) counts.SLIPANGL counts.SLIPANGL(end-1)],    'MinPeakHeight', nMinPeakHeight);
            
            binvalues.FZW       = unique(round(abs(edges.FZW(locs.FZW)),2));
            binvalues.INFLPRES  = unique(round(edges.INFLPRES(locs.INFLPRES),2));
            binvalues.INCLANGL  = unique(round(edges.INCLANGL(locs.INCLANGL),2));
            binvalues.SLIPANGL  = unique(round(edges.SLIPANGL(locs.SLIPANGL),2));
            
            eps = obj.SteadyStateTolerances;
            bins.FZW      = abs(data.FZ)     >(abs(binvalues.FZW)-eps.FZW)            &   abs(data.FZ)    <(abs(binvalues.FZW)+eps.FZW);
            bins.INCLANGL = abs(data.IA)     >(abs(binvalues.INCLANGL)-eps.INCLANGL)  &   abs(data.IA)    <(abs(binvalues.INCLANGL)+eps.INCLANGL);
            bins.SLIPANGL = abs(data.SA)     >(abs(binvalues.SLIPANGL)-eps.SLIPANGL)  &   abs(data.SA)    <(abs(binvalues.SLIPANGL)+eps.SLIPANGL);
            bins.INFLPRES = abs(data.P)      >(binvalues.INFLPRES-eps.INFLPRES)       &   abs(data.P)     <(binvalues.INFLPRES+eps.INFLPRES);
            
            measurements(length(binvalues.FZW)...
                *length(binvalues.INCLANGL)...
                *length(binvalues.SLIPANGL)...
                *length(binvalues.INFLPRES))...
                = Measurement();
            
            num = 1;
            for i1 = 1:length(binvalues.FZW)
                for i2 = 1:length(binvalues.INCLANGL)
                    for i3 = 1:length(binvalues.SLIPANGL)
                        for i4 = 1:length(binvalues.INFLPRES)
                            I = bins.FZW(:,i1)       &...
                                bins.INCLANGL(:,i2)  &...
                                bins.SLIPANGL(:,i3)  &...
                                bins.INFLPRES(:,i4);
                            
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
                            
                            FZW         = ConstantParameter('FZW',      'N',    binvalues.FZW(i1));
                            INCLANGL    = ConstantParameter('INCLANGL', 'deg',  binvalues.INCLANGL(i2));
                            INFLPRES    = ConstantParameter('INFLPRES', 'kPa',  binvalues.INFLPRES(i4));
                            SLIPANGL    = ConstantParameter('SLIPANGL', 'deg',  binvalues.SLIPANGL(i3));
                            FNOMIN      = ConstantParameter('FNOMIN',   'N',    binvalues.FZW(end));
                            NOMPRES     = ConstantParameter('NOMPRES',  'kPa',  binvalues.INFLPRES(end));
                            measurements(num).Constant = [
                                FZW INCLANGL INFLPRES SLIPANGL FNOMIN NOMPRES
                                ];
                            
                            RELEASE  = Metadata('RELEASE','1.3');
                            MEASID   = Metadata('MEASID', fileName);
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
        end
    end
end
