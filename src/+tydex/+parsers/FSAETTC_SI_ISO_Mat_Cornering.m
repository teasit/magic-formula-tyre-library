classdef FSAETTC_SI_ISO_Mat_Cornering < tydex.parsers.FSAETTC_SI_ISO_Mat
    methods (Access = protected)
        function [measurements, bins, binvalues] = parse(obj, file)
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
            
            [~, locs.FZW]       = findpeaks([counts.FZW(2)      counts.FZW counts.FZW(end-1)],              'MinPeakHeight', 500);
            [~, locs.INFLPRES]  = findpeaks([counts.INFLPRES(2) counts.INFLPRES counts.INFLPRES(end-1)],    'MinPeakHeight', 1000);
            [~, locs.INCLANGL]  = findpeaks([counts.INCLANGL(2) counts.INCLANGL counts.INCLANGL(end-1)],    'MinPeakHeight', 1000);
            
            binvalues.FZW       = unique(round(abs(edges.FZW(locs.FZW)),2));
            binvalues.INFLPRES  = unique(round(edges.INFLPRES(locs.INFLPRES),2));
            binvalues.INCLANGL  = unique(round(edges.INCLANGL(locs.INCLANGL),2));
            
            eps = obj.SteadyStateTolerances;
            bins.FZW      = abs(data.FZ) >(binvalues.FZW-eps.FZW)                &   abs(data.FZ)   <(binvalues.FZW+eps.FZW);
            bins.INCLANGL = abs(data.IA) >(abs(binvalues.INCLANGL)-eps.INCLANGL) &   abs(data.IA)   <(abs(binvalues.INCLANGL)+eps.INCLANGL);
            bins.INFLPRES = abs(data.P)  >(binvalues.INFLPRES-eps.INFLPRES)      &   abs(data.P)    <(binvalues.INFLPRES+eps.INFLPRES);
            
            measurements(length(binvalues.FZW)...
                *length(binvalues.INCLANGL)...
                *length(binvalues.INFLPRES))...
                = Measurement();
            
            num = 1;
            for i1 = 1:length(binvalues.FZW)
                for i2 = 1:length(binvalues.INCLANGL)
                    for i3 = 1:length(binvalues.INFLPRES)
                        idx = ...
                            bins.FZW(:,i1)       &...
                            bins.INCLANGL(:,i2)  &...
                            bins.INFLPRES(:,i3);
                        
                        LONGVEL     = MeasuredParameter('LONGVEL',  'km/h', data.V(idx));
                        WHROTSPD    = MeasuredParameter('WHROTSPD', 'rad/s',data.N(idx)*2*pi);
                        SLIPANGL    = MeasuredParameter('SLIPANGL', 'deg',  data.SA(idx));
                        FX          = MeasuredParameter('FX',       'N',    data.FX(idx));
                        FYW         = MeasuredParameter('FYW',      'N',    data.FY(idx));
                        MXW         = MeasuredParameter('MXW',      'Nm',   data.MX(idx));
                        MZW         = MeasuredParameter('MZW',      'Nm',   data.MZ(idx));
                        RUNTIME     = MeasuredParameter('RUNTIME',  's',    data.ET(idx));
                        LONGSLIP    = MeasuredParameter('LONGSLIP', '-',    data.SL(idx));
                        INCLANGL    = MeasuredParameter('INCLANGL', 'deg',  data.IA(idx));
                        INFLPRES    = MeasuredParameter('INFLPRES', 'kPa',  data.P(idx));
                        FZW         = MeasuredParameter('FZW',      'N',    data.FZ(idx));
                        measurements(num).Measured = [
                            LONGVEL RUNTIME WHROTSPD SLIPANGL FX FYW MXW MZW LONGSLIP INCLANGL INFLPRES FZW];
                        
                        FZW         = ConstantParameter('FZW',      'N',    binvalues.FZW(i1));
                        INCLANGL    = ConstantParameter('INCLANGL', 'deg',  binvalues.INCLANGL(i2));
                        INFLPRES    = ConstantParameter('INFLPRES', 'kPa',  binvalues.INFLPRES(i3));
                        LONGSLIP    = ConstantParameter('LONGSLIP', '-',    0);
                        FNOMIN      = ConstantParameter('FNOMIN',   'N',    binvalues.FZW(end));
                        NOMPRES     = ConstantParameter('NOMPRES',  'kPa',  binvalues.INFLPRES(end));
                        measurements(num).Constant = [
                            FZW INCLANGL INFLPRES LONGSLIP FNOMIN NOMPRES
                            ];
                        
                        RELEASE  = tydex.Metadata('RELEASE','1.3');
                        MEASID   = tydex.Metadata('MEASID', fileName);
                        SUPPLIER = tydex.Metadata('SUPPLIER','FSAE TTC');
                        
                        
                        measurements(num).Metadata = [
                            RELEASE
                            MEASID
                            SUPPLIER
                            ];
                        
                        num = num+1;
                    end
                end
            end
            measurements = obj.fixUnits(measurements);
        end
    end
end
