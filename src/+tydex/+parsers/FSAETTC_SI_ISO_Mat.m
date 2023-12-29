classdef FSAETTC_SI_ISO_Mat < tydex.Parser
    properties
        % Looking at the histogram, these thresholds decide which 'bins'
        % will be grouped together into one steady-state cluster.
        SteadyStateTolerances struct = struct(...
            'FZW',      150, ...        % [N]
            'INFLPRES', 5E3, ...        % [Pa]
            'INCLANGL', pi/300, ...     % [rad]
            'SLIPANGL', pi/300, ...     % [rad]
            'LONGSLIP', 0.01);          % [-]

        % Names of FSAE TTC variables are mapped to internal (TYDEX) names.
        Mapping struct = struct(...
            'LONGVEL',  struct('InputName', 'V',  'InputUnit', 'km/h'), ...
            'WHROTSPD', struct('InputName', 'N',  'InputUnit', '1/s'),  ...
            'FX',       struct('InputName', 'FX', 'InputUnit', 'N'),    ...
            'FYW',      struct('InputName', 'FY', 'InputUnit', 'N'),    ...
            'MXW',      struct('InputName', 'MX', 'InputUnit', 'Nm'),   ...
            'MZW',      struct('InputName', 'MZ', 'InputUnit', 'Nm'),   ...
            'RUNTIME',  struct('InputName', 'ET', 'InputUnit', 's'),    ...
            'LONGSLIP', struct('InputName', 'SL', 'InputUnit', '-'),    ...
            'SLIPANGL', struct('InputName', 'SA', 'InputUnit', 'deg'),  ...
            'INCLANGL', struct('InputName', 'IA', 'InputUnit', 'deg'),  ...
            'INFLPRES', struct('InputName', 'P',  'InputUnit', 'kPa'),  ...
            'FZW',      struct('InputName', 'FZ', 'InputUnit', 'N'));

        % Steady-state is achieved when data exists for 'x' seconds.
        MinSteadyStateTime {isinteger} = 5

        % Steady-state (bin) values are rounded to be more readable.
        SteadyStateNumberOfDigits (1,1) double = 2
    end
    methods (Static, Access = private)
        function [newUnit,factor] = convertUnit(unit)
            mustBeA(unit, 'char')
            unit = strtrim(unit);
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
                case {'1/s', 'Hz'}
                    newUnit = 'rad/s';
                    factor = 2*pi;
                case {'s', 'N', 'Nm', '-', 'm/s', 'rad', 'rad/s'}
                    newUnit = unit;
                    factor = 1;
                otherwise
                    warning('Unknown unit ''%s''.', unit)
            end
        end
        function indices = findLocalMaxima(x, xmin)
            %FINDLOCALMAXIMA using first and second derivatives.
            % Equal neighbors are eliminated to get steady data.
            % Local maxima will have a negative second derivative.
            % Maxima with only very few samples can be discarded with xMin.
            if length(x) == 1
                indices = 1;
                return
            end
            x = [x(:); 0];
            indices = 1:numel(x);
            isEqualToPrev = [false; ~(x(2:end)-x(1:end-1))];
            x(isEqualToPrev) = [];
            indices(isEqualToPrev) = [];
            dx = [0; diff(x)];
            ds = sign(dx);
            dds = [diff(ds); 0];
            I = dds < 0 & x > xmin;
            indices = indices(I);
        end
        function idx = getIndexCombinations(s)
            %GETINDEXCOMBINATIONS From R2023a 'combinations' can be used.
            % Every steady-state combination is possible. Meaning, each
            % inflation pressure could be tested with each normal load,
            % then again for each slip angle --- and so on.
            f = @(varargin) cellfun(varargin{:}, 'UniformOutput', false);
            c = struct2cell(s);
            idxFields = f(@(x) 1:numel(x), c);
            idxGrid = cell(1, numel(idxFields));
            [idxGrid{:}] = ndgrid(idxFields{:});
            idxCell = f(@(x) x(:), idxGrid);
            idx = cell2mat(idxCell);
        end
        function metadata = getMetadata(measId, supplier)
            import tydex.Metadata
            version = tydex.version();
            metadata = [
                Metadata('RELEASE', version)
                Metadata('MEASID', measId)
                Metadata('SUPPLIER', supplier)
                ];
        end
        function measured = getMeasured(data, units, indices)
            import tydex.MeasuredParameter
            names = fieldnames(data);
            n = numel(names);
            measured = cell(n,1);
            for i = 1:n
                name = names{i};
                unit = units{i};
                values  = data.(name)(indices);
                measured{i} = MeasuredParameter(name, unit, values);
            end
            measured = [measured{:}];
        end
        function constant = getConstant(vars_SS, vals_SS, units_SS)
            import tydex.ConstantParameter
            n = numel(vars_SS);
            constant = cell(n,1);
            for i = 1:n
                var  = vars_SS{i};
                val  = vals_SS(:,i);
                unit = units_SS{i};
                constant{i} = ConstantParameter(var, unit, val);
            end
            constant = vertcat(constant{:});
        end
        function modelpar = getModelPar(vars_SS, vals_SS, units_SS)
            import tydex.ModelParameter

            idx = strcmpi(vars_SS, 'FZW');
            val = max(vals_SS(:,idx));
            unit = units_SS{idx};
            FNOMIN = ModelParameter('FNOMIN', unit, val);

            idx = strcmpi(vars_SS, 'INFLPRES');
            val = max(vals_SS(:,idx));
            unit = units_SS{idx};
            NOMPRES = ModelParameter('NOMPRES', unit, val);

            modelpar = [FNOMIN; NOMPRES];
        end
        function [vals_SS, units_SS, I_SS] = getSteadyStateValuesAndIndices(...
                vars_SS, data, units, bins, binvalues, idxCombinations)
            nSamples = length(data.RUNTIME);

            vars = fieldnames(data);
            n = size(idxCombinations, 1);
            m = numel(vars_SS);
            vals_SS = nan(n,m);

            noData = false(n,1);
            I_SS = false(n, nSamples);
            for i = 1:n
                I_SS_comb = true(nSamples, 1);
                for j = 1:numel(vars_SS)
                    idx = idxCombinations(i,j);
                    var = vars_SS{j};
                    val = binvalues.(var)(idx);
                    I_SS_var = bins.(var)(:,idx);
                    I_SS_comb = I_SS_comb & I_SS_var;
                    vals_SS(i,j) = val;
                end
                noData(i) = sum(I_SS_comb) == 0;
                I_SS(i,:) = I_SS_comb(:);
            end
            I_SS(noData,:) = [];
            vals_SS(noData,:) = [];

            units_SS = repmat({char.empty},1,m);
            for i = 1:m
                var = vars_SS{i};
                unit = units{strcmpi(vars, var)};
                units_SS{i} = unit;
            end
        end
    end
    methods (Access = private)
        function [output,units,vars_SS] = preprocessInputData(obj, input)
            mapping = obj.Mapping;
            vars = fieldnames(mapping);
            nvars = numel(vars);
            output = struct();
            units = cell(nvars,1);
            for i = 1:nvars
                outputName = vars{i};
                inputName = mapping.(outputName).InputName;
                inputUnit = mapping.(outputName).InputUnit;
                values = input.(inputName);
                switch outputName
                    case {'SLIPANGL','FYW','MYW','MZW'}
                        values = -values;
                    case 'FZW'
                        values = abs(values);
                end
                [unit,factor] = obj.convertUnit(inputUnit);
                output.(outputName) = values*factor;
                units{i} = unit;
            end

            if all(output.LONGSLIP == 0)
                vars_SS = {'FZW','INFLPRES','INCLANGL','LONGSLIP'};
            else
                vars_SS = {'FZW','INFLPRES','INCLANGL','SLIPANGL'};
            end
        end
        function [bins, binvalues] = getHistogramBins(obj, data, vars_SS)
            time = data.RUNTIME;
            dt = diff(time(1:2));
            nSamplesMin = obj.MinSteadyStateTime/dt;
            tolerances = obj.SteadyStateTolerances;
            nDigits = obj.SteadyStateNumberOfDigits;
            for i = 1:numel(vars_SS)
                var = vars_SS{i};
                valRaw = data.(var);
                [counts,edges] = histcounts(valRaw);
                idx = obj.findLocalMaxima(counts, nSamplesMin);
                b = (edges(idx) + edges(idx+1))/2;
                b = round(b, nDigits);
                b = unique(b);
                eps = tolerances.(var);
                xmin = abs(b) - eps;
                xmax = abs(b) + eps;
                x = abs(valRaw);
                bins.(var) = x > xmin & x < xmax;
                binvalues.(var) = b;
            end
        end
    end
    methods (Access = protected)
        function [measurements, bins, binvalues] = parse(obj,file,options)
            arguments
                obj
                file char {mustBeFile}
                options.MeasurementID char = ''
                options.Supplier char = 'FSAE TTC'
            end
            import tydex.Measurement

            dataRaw = load(file);
            [data,units,vars_SS] = preprocessInputData(obj, dataRaw);

            supplier = options.Supplier;
            measId = options.MeasurementID;
            if isempty(measId)
                [~,measId] = fileparts(file);
            end

            % Data is grouped into steady-state 'bins'. If you want to see
            % what is happening, you can visualize the results of
            % 'histcounts(x)' more easily with 'histogram(x)'.
            % This strategy assumes the data contains certain steady-state
            % levels, for example 5 different slip angles being held
            % constant for a long time respectively. If one variable is
            % beeing 'sweeped' (e.g. wheel is steered from left to right)
            % this will not work. Therefore the steady-state variables have
            % to be identified beforehand.
            [bins, binvalues] = obj.getHistogramBins(data, vars_SS);

            % Technically, all combinations between all steady-state
            % binvalues are possible. This function generates and index
            % array containing all those possible combinations.
            idxCombinations = obj.getIndexCombinations(binvalues);

            % For each of these combinations, we will try to find data. If
            % no data exists, we delete this combination of steady-state
            % values.
            [vals_SS,units_SS,I_SS] = obj.getSteadyStateValuesAndIndices(...
                vars_SS, data, units, bins, binvalues, idxCombinations);

            % Translation of previous results into TYDEX model objects.
            n = size(I_SS, 1);
            measurements(n) = Measurement();
            for i = 1:n
                I = I_SS(i,:);

                measured = obj.getMeasured(data, units, I);
                constant = obj.getConstant(vars_SS, vals_SS(i,:), units_SS);
                modelpar = obj.getModelPar(vars_SS, vals_SS, units_SS);
                metadata = obj.getMetadata(measId, supplier);

                measurements(i).Measured = measured;
                measurements(i).Constant = constant;
                measurements(i).ModelParameters = modelpar;
                measurements(i).Metadata = metadata;
            end
        end
    end
end
