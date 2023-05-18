classdef Fitter < handle
    %FITTER Fits Magic Formula tyre models to measurement data.
    
    properties
        %Set the measurements to be used for fitting.
        Measurements tydex.Measurement
        
        %Set the initial parameter to be used for fitting.
        Parameters magicformula.v61.Parameters
        
        %Set the Fit-Modes to execute when using run() method.
        FitModes magicformula.FitMode
        
        %Solver options. Set max iterations, function evaluations etc.
        Options struct = magicformula.v61.Fitter.initOptimizerOptions()
    end
    properties (SetAccess = protected)
        %Fitted parameter values, updated after each Fit-Mode solve.
        ParametersFitted magicformula.v61.Parameters
        
        %Input fitmode name, map will return index array for measurements.
        FitModeFlags containers.Map
    end
    properties (SetAccess = protected, Transient)
        %Returns the Fit-Mode that is currently being solved.
        %In case the "OutputFcn" property in the Fitter options is used,
        %the user can make use of the ActiveFitMode property to print the
        %current equation being fitted, for example.
        ActiveFitMode magicformula.FitMode
    end
    methods
        function set.FitModes(fitter, fitmodes)
            fitmodes = unique(fitmodes);
            fitmodes = sort(fitmodes);
            fitter.FitModes = fitmodes;
        end
        function set.Measurements(fitter, measurements)
            fitter.Measurements = measurements;
            if isempty(measurements)
                return
            end
            fitter.qualifyMeasurements()
        end
    end
    methods
        function run(fitter)
            %RUN Fits all modes specified in "FitModes" property.
            import magicformula.FitMode
            import magicformula.exceptions.FitterFailed
            warning('off', 'MATLAB:nearlySingularMatrix')
            fitmodes = fitter.FitModes;
            fitter.ParametersFitted = fitter.Parameters;
            for i = 1:numel(fitmodes)
                fitmode = fitmodes(i);
                try
                    fprintf('Fitting %s...\n', char(fitmode))
                    tic; x = fitter.solve(fitmode); time = toc;
                    fprintf('Finished Fit-Mode: %s\n', char(fitmode))
                    fprintf('Time elapsed %.1fs.\n\n', time)
                    paramsFitted = fitter.ParametersFitted;
                    p = fitter.appendFitted(paramsFitted, x, fitmode);
                    fitter.ParametersFitted = p;
                catch ME
                    warning('on', 'MATLAB:nearlySingularMatrix')
                    E = FitterFailed(char(fitmode));
                    E = addCause(E, ME);
                    throw(E)
                end
            end
            warning('on', 'MATLAB:nearlySingularMatrix')
        end
        function fitter = Fitter(measurements, parameters)
            arguments
                measurements tydex.Measurement = tydex.Measurement.empty
                parameters magicformula.v61.Parameters = magicformula.v61.Parameters.empty
            end
            fitter.Measurements = measurements;
            fitter.Parameters = parameters;
        end
    end
    methods (Access = private)
        function x = solve(fitter,fitmode)
            %SOLVE Fit model only for one fitmode.
            arguments
                fitter  magicformula.v61.Fitter
                fitmode magicformula.FitMode
            end
            import magicformula.exceptions.NoMeasurementForFitMode
            import magicformula.exceptions.EmptyMeasurementChannel
            import magicformula.exceptions.EmptyMeasurement
            import magicformula.FitMode
            fitter.ActiveFitMode = fitmode;
            fitter.verifyHasMandatoryParameters(fitmode)
            
            measurements = fitter.Measurements;
            if isempty(measurements)
                E = EmptyMeasurement();
                throw(E)
            end
            
            I = fitter.FitModeFlags(char(fitmode));
            measurements = measurements(I);
            if isempty(measurements)
                E = NoMeasurementForFitMode(char(fitmode));
                throw(E)
            end
            
            p = fitter.ParametersFitted;
            mfinputs = fitter.preprocess(measurements);
            switch fitmode
                case {FitMode.Fx0, FitMode.Fx}
                    channel = 'FX';
                case {FitMode.Fy0, FitMode.Fy}
                    channel = 'FYW';
                case {FitMode.Mz0, FitMode.Mz}
                    channel = 'MZW';
                case FitMode.Mx
                    channel = 'MXW';
                case FitMode.My
                    channel = 'MYW';
                case FitMode.Fz
                    error('Fitmode ''%s'' not yet implemented', fitmode)
            end

            testdata = fitter.getTestData(measurements, channel);
            if isempty(testdata)
                e = EmptyMeasurementChannel(channel);
                throw(e)
            end
            
            costFun = @(x) fitter.costFun(x,p,mfinputs,testdata,fitmode);
            convert2fittable = @magicformula.v61.Fitter.convert2fittable;
            [x0,lb,ub] = convert2fittable(p,fitmode);
            nonlcon = @(x) fitter.constraints(x,p,fitmode,mfinputs);
            options = fitter.Options;
            x = fmincon(costFun,x0,[],[],[],[],lb,ub,nonlcon,options);
        end
        function qualifyMeasurements(fitter)
            % QUALITFYMEASUREMENTS Finds which measurements can be used for
            % which fit-mode. For example, data which only includes
            % slip-free slip angle sweeps can only be used to fit Fy0.
            %
            measurements = fitter.Measurements;
            if isempty(measurements)
                return
            end
            
            numMeas = numel(measurements);
            
            modes = enumeration(magicformula.FitMode.Fy0);
            keys = cell(numel(modes),1);
            for i = 1:numel(modes)
                keys{i} = char(modes(i));
            end
            vals = cell(size(keys));
            
            % Fx0 + My
            idx = zeros(numMeas,1);
            for i = 1:numMeas
                const = measurements(i).Constant;
                I = strcmp({const.Name},'SLIPANGL');
                idx(i) = any(I) && abs(const(I).Value) <= deg2rad(0.3);
            end
            fitmodes = [
                magicformula.FitMode.Fx0
                magicformula.FitMode.My
                ];
            for i = 1:numel(fitmodes)
                fitmode = fitmodes(i);
                key = find(strcmp(keys,char(fitmode)),1);
                vals{key} = find(idx);
            end
            
            % Fy0 + Mx + Mz + Mz0
            idx = zeros(numMeas,1);
            for i = 1:numMeas
                const = measurements(i).Constant;
                I = strcmp({const.Name},'LONGSLIP');
                idx(i) = any(I) && abs(const(I).Value) <= 0.005;
            end
            fitmodes = [
                magicformula.FitMode.Fy0
                magicformula.FitMode.Mx
                magicformula.FitMode.My
                magicformula.FitMode.Mz0
                ];
            for i = 1:numel(fitmodes)
                fitmode = fitmodes(i);
                key = find(strcmp(keys,char(fitmode)),1);
                vals{key} = find(idx);
            end
            
            % Fx + Fy + Fz + Mz (Combined Slip)
            idx = zeros(numMeas,1);
            for i = 1:numMeas
                const = measurements(i).Constant;
                I1 = strcmp({const.Name},'LONGSLIP');
                I2 = strcmp({const.Name},'SLIPANGL');
                idx(i) = ~(any(I1) && const(I1).Value == 0) ...
                    || (any(I2) && const(I2).Value == 0);
            end
            fitmodes = [
                magicformula.FitMode.Fx
                magicformula.FitMode.Fy
                magicformula.FitMode.Fz
                magicformula.FitMode.Mz
                ];
            for i = 1:numel(fitmodes)
                fitmode = fitmodes(i);
                key = find(strcmp(keys,char(fitmode)),1);
                vals{key} = find(idx);
            end
            
            fitModeFlagsMap = containers.Map(keys,vals);
            fitter.FitModeFlags = fitModeFlagsMap;
        end
        function verifyHasMandatoryParameters(fitter, fitmode)
            import magicformula.exceptions.MissingParameterToFit
            switch fitmode
                case {'Fx0','Fx','Fy0','Fy'}
                    mandatoryNames = {'FNOMIN','NOMPRES'};
                case {'Mz0','Mx','My'}
                    mandatoryNames = {'FNOMIN','NOMPRES','UNLOADED_RADIUS'};
                otherwise
                    mandatoryNames = {};
            end
            params = fitter.Parameters;
            try
                for i = 1:numel(mandatoryNames)
                    name = mandatoryNames{i};
                    param = params.(name);
                    value = param.Value;
                    mustBeNonempty(value)
                end
            catch
                exception = MissingParameterToFit(name, fitmode);
                throw(exception)
            end
        end
    end
    methods (Static, Access = private)
        function [testdata,normfacs] = getTestData(measurements, measuredName)
            testdata = cat(1,measurements.(measuredName));
            normfacs = ones(size(testdata));
            i0 = 1;
            for i = 1:numel(measurements)
                m = measurements(i);
                measuredData = m.(measuredName);
                i1 = i0 - 1 + length(measuredData);
                normfac = max(abs(measuredData));
                normfacs(i0:i1) = normfac;
                i0 = i1+1;
            end
        end
        function cost = costFun(x,params,mfinputs,testdata,fitmode)
            %COSTFUN Summed squares cost function for fmincon solver.
            arguments
                x        double
                params   magicformula.v61.Parameters
                mfinputs double
                testdata double
                fitmode  magicformula.FitMode
            end
            import magicformula.FitMode
            import magicformula.v61.Fx0
            import magicformula.v61.Fy0
            import magicformula.v61.Fx
            import magicformula.v61.Fy
            import magicformula.v61.Mz0
            import magicformula.v61.Mz
            import magicformula.v61.My
            import magicformula.v61.Mx
            
            appendFitted = @magicformula.v61.Fitter.appendFitted;
            params = appendFitted(params,x,fitmode);
            params = struct(params);
            
            switch fitmode
                case FitMode.Fx0
                    SX = mfinputs(:,2);
                    IP = mfinputs(:,7);
                    IA = mfinputs(:,4);
                    FZ = mfinputs(:,1);
                    modelout = Fx0(params,SX,FZ,IP,IA);
                case FitMode.Fy0
                    SA = mfinputs(:,3);
                    IP = mfinputs(:,7);
                    IA = mfinputs(:,4);
                    FZ = mfinputs(:,1);
                    modelout = Fy0(params,SA,FZ,IP,IA);
                case FitMode.Fx
                    SA = mfinputs(:,3);
                    SX = mfinputs(:,2);
                    IP = mfinputs(:,7);
                    IA = mfinputs(:,4);
                    FZ = mfinputs(:,1);
                    VX = mfinputs(:,8);
                    modelout = Fx(params,SX,SA,FZ,IP,IA,VX);
                case FitMode.Fy
                    SA = mfinputs(:,3);
                    SX = mfinputs(:,2);
                    IP = mfinputs(:,7);
                    IA = mfinputs(:,4);
                    FZ = mfinputs(:,1);
                    VX = mfinputs(:,8);
                    modelout = Fy(params,SX,SA,FZ,IP,IA,VX);
                case FitMode.Mz0
                    SA = mfinputs(:,3);
                    IP = mfinputs(:,7);
                    IA = mfinputs(:,4);
                    FZ = mfinputs(:,1);
                    VX = mfinputs(:,8);
                    modelout = Mz0(params,SA,FZ,IP,IA,VX);
                case FitMode.Mz
                    SX = mfinputs(:,2);
                    SA = mfinputs(:,3);
                    IP = mfinputs(:,7);
                    IA = mfinputs(:,4);
                    FZ = mfinputs(:,1);
                    VX = mfinputs(:,8);
                    FX = Fx(params,SX,SA,FZ,IP,IA,VX);
                    FY = Fy(params,SX,SA,FZ,IP,IA,VX);
                    modelout = Mz(params,SX,SA,FZ,IP,IA,VX,FX,FY);
                case FitMode.My
                    SX = mfinputs(:,2);
                    SA = mfinputs(:,3);
                    IP = mfinputs(:,7);
                    IA = mfinputs(:,4);
                    FZ = mfinputs(:,1);
                    VX = mfinputs(:,8);
                    FX = Fx(params,SX,SA,FZ,IP,IA,VX);
                    modelout = My(params,FZ,IP,IA,VX,FX);
                case FitMode.Mx
                    SX = mfinputs(:,2);
                    SA = mfinputs(:,3);
                    IP = mfinputs(:,7);
                    IA = mfinputs(:,4);
                    FZ = mfinputs(:,1);
                    VX = mfinputs(:,8);
                    FY = Fy(params,SX,SA,FZ,IP,IA,VX);
                    modelout = Mx(params,FZ,IP,IA,FY);
                case FitMode.My
                    warning('Not implemented yet')
                case FitMode.Fz
                    error('Fitmode ''%s'' not implemented yet.', fitmode)
            end
            cost = testdata-modelout;
            cost = sum(cost.^2);
            cost = double(cost);
        end
        function [c,ceq] = constraints(x,p,fitmode,mfinputs)
            %CONSTRAINTS Constraints for fmincon solver.
            arguments
                x double
                p magicformula.v61.Parameters
                fitmode magicformula.FitMode
                mfinputs double
            end
            import magicformula.FitMode
            
            c = []; ceq = [];
            p = magicformula.v61.Fitter.appendFitted(p,x,fitmode);
            p = struct(p);
            SX = mfinputs(:,2);
            SA = mfinputs(:,3);
            FZ = mfinputs(:,1);
            IP = mfinputs(:,7);
            IA = mfinputs(:,4);
            VX = mfinputs(:,8);
            switch fitmode
                case FitMode.Fx0
                    [~,~,Cx,Dx,Ex] = magicformula.v61.Fx0(p,SX,FZ,IP,IA);
                    c = [-Cx+eps;-Dx+eps;Ex-1];
                case FitMode.Fy0
                    [~,~,~,Cy,Ey] = magicformula.v61.Fy0(p,SA,FZ,IP,IA);
                    c = [-Cy+eps;Ey-1];
                case FitMode.Fx
                    [~,~,Gxa,Bxa,Exa] = ...
                        magicformula.v61.Fx(p,SX,SA,FZ,IP,IA,VX);
                    c = [-Gxa+eps;-Bxa+eps;Exa-1];
                case FitMode.Fy
                    [~,~,Gyk,Byk,Eyk] = ...
                        magicformula.v61.Fy(p,SX,SA,FZ,IP,IA,VX);
                    c = [-Gyk+eps;-Byk+eps;Eyk-1];
                case FitMode.Mz0
                    [~,Bt,Ct,~,Et] = ...
                        magicformula.v61.Mz0(p,SA,FZ,IP,IA,VX);
                    c = [-Bt+eps;-Ct+eps;Et-1];
                case {FitMode.Mz, FitMode.My, FitMode.Mx}
                    c = []; ceq = [];
                otherwise
                    error('Constraints for %s not yet implemented', fitmode)
            end
        end
        function mfinputs = preprocess(measurements)
            %PREPROCESS Returns one big matrix of test data for fitting.
            arguments
                measurements tydex.Measurement
            end
            param = {
                'FZW'
                'LONGSLIP'
                'SLIPANGL'
                'INCLANGL'
                ''
                'LONGVEL'
                'INFLPRES'
                'LONGVEL'
                };
            mfinputs = zeros(length(measurements),8);
            endIdx = 0;
            for num = 1:numel(measurements)
                startIdx = endIdx + 1;
                endIdx = endIdx + length(measurements(num));
                for i = 1:numel(param)
                    if isempty(param{i})
                        input = zeros(length(measurements(num)),1);
                    else
                        input = measurements(num).(param{i});
                        if isscalar(input)
                            input = input*ones(length(measurements(num)),1);
                        end
                    end
                    mfinputs(startIdx:endIdx,i) = input;
                end
            end
        end
    end
    methods (Static, Access = public)
        function [x,lb,ub] = convert2fittable(params,fitmode)
            arguments
                params magicformula.Parameters
                fitmode magicformula.FitMode
            end
            import magicformula.FitMode
            fn = fieldnames(params);
            fitparams = magicformula.v61.Fitter.getFitParamNames(fitmode);
            n = length(fitparams);
            allExist = numel(intersect(fn,fitparams)) == n;
            assert(allExist)
            x  = zeros(n, 1);
            lb = zeros(n, 1);
            ub = zeros(n, 1);
            for i = 1:numel(fitparams)
                name = fitparams{i};
                x(i)  = params.(name).Value;
                if params.(name).Fixed
                    lb(i) = params.(name).Value;
                    ub(i) = params.(name).Value;
                else
                    lb(i) = params.(name).Min;
                    ub(i) = params.(name).Max;
                end
            end
        end
        function opts = initOptimizerOptions()
            opts = optimset('fmincon');
            opts.MaxIter = 1000;
            opts.MaxFunEvals = 3000;
            opts.Algorithm = 'interior-point';
            opts.UseParallel = false;
            opts.Display = 'iter-detailed';
        end
        function params = appendFitted(params,x,fitmode)
            arguments
                params magicformula.Parameters
                x double
                fitmode magicformula.FitMode
            end
            fitparams = magicformula.v61.Fitter.getFitParamNames(fitmode);
            for i = 1:numel(fitparams)
                name = fitparams{i};
                params.(name).Value = x(i);
            end
        end
        function names = getFitParamNames(fitmode)
            % GETFITPARAMNAMES Returns the parameter names that are adjusted by the
            % optimization algorithm in each fitting mode. Usually, the pure slip
            % conditions are fitted first (Fx0, Fy0) and after those parameters are set
            % the combined slip conditions are fitted (Fx, Fy).
            %
            % Inputs:
            %   - fitmode   (magicformula.FitMode)
            %
            % Outputs:
            %   - names     (cell array of chars)
            %
            arguments
                fitmode magicformula.FitMode
            end
            import magicformula.FitMode
            switch fitmode
                case FitMode.Fx0
                    names = {
                        'PCX1'
                        'PDX1'
                        'PDX2'
                        'PDX3'
                        'PEX1'
                        'PEX2'
                        'PEX3'
                        'PEX4'
                        'PKX1'
                        'PKX2'
                        'PKX3'
                        'PHX1'
                        'PHX2'
                        'PVX1'
                        'PVX2'
                        'PPX1'
                        'PPX2'
                        'PPX3'
                        'PPX4'
                        };
                case FitMode.Fy0
                    names = {
                        'PCY1'
                        'PDY1'
                        'PDY2'
                        'PDY3'
                        'PEY1'
                        'PEY2'
                        'PEY3'
                        'PEY4'
                        'PEY5'
                        'PKY1'
                        'PKY2'
                        'PKY3'
                        'PKY4'
                        'PKY5'
                        'PKY6'
                        'PKY7'
                        'PHY1'
                        'PHY2'
                        'PVY1'
                        'PVY2'
                        'PVY3'
                        'PVY4'
                        'PPY1'
                        'PPY2'
                        'PPY3'
                        'PPY4'
                        'PPY5'
                        };
                case FitMode.Mz0
                    names = {
                        'QBZ1'
                        'QBZ2'
                        'QBZ3'
                        'QBZ4'
                        'QBZ5'
                        'QBZ9'
                        'QBZ10'
                        'QCZ1'
                        'QDZ1'
                        'QDZ2'
                        'QDZ3'
                        'QDZ4'
                        'QDZ6'
                        'QDZ7'
                        'QDZ8'
                        'QDZ9'
                        'QDZ10'
                        'QDZ11'
                        'QEZ1'
                        'QEZ2'
                        'QEZ3'
                        'QEZ4'
                        'QEZ5'
                        'QHZ1'
                        'QHZ2'
                        'QHZ3'
                        'QHZ4'
                        };
                case FitMode.Fx
                    names = {
                        'RBX1'
                        'RBX2'
                        'RBX3'
                        'RCX1'
                        'REX1'
                        'REX2'
                        'RHX1'
                        };
                case FitMode.Fy
                    names = {
                        'RBY1'
                        'RBY2'
                        'RBY3'
                        'RBY4'
                        'RCY1'
                        'REY1'
                        'REY2'
                        'RHY1'
                        'RHY2'
                        'RVY1'
                        'RVY2'
                        'RVY3'
                        'RVY4'
                        'RVY5'
                        'RVY6'
                        };
                case FitMode.Mx
                    names = {
                        'QSX1'
                        'QSX2'
                        'QSX3'
                        'QSX4'
                        'QSX5'
                        'QSX6'
                        'QSX7'
                        'QSX8'
                        'QSX9'
                        'QSX10'
                        'QSX11'
                        'QSX12'
                        'QSX13'
                        'QSX14'
                        'PPMX1'
                        };
                case FitMode.My
                    names = {
                        'QSY1'
                        'QSY2'
                        'QSY3'
                        'QSY4'
                        'QSY5'
                        'QSY6'
                        'QSY7'
                        'QSY8'
                        };
                case FitMode.Mz
                    names = {
                        'SSZ1'
                        'SSZ2'
                        'SSZ3'
                        'SSZ4'
                        'PPZ1'
                        'PPZ2'
                        };
                otherwise
                    error('%s not implemented yet.', fitmode)
            end
        end
    end
end