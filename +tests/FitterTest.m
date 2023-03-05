classdef FitterTest < matlab.unittest.TestCase
    properties
        Fitter magicformula.v61.Fitter
        Tyre MagicFormulaTyre
        Measurements tydex.Measurement
        MeasurementFileCornering char {mustBeFile} = 'doc/examples/fsae-ttc-data/fsaettc_obscured_testbench_cornering.mat'
        MeasurementFileDriveBrake char {mustBeFile} = 'doc/examples/fsae-ttc-data/fsaettc_obscured_testbench_drivebrake.mat'
        %Average RMSE of model versus data across fitted measurements must
        %be lower than this value or test will fail.
        ThresholdAverageRMSE = 0.3;
    end
    methods (TestClassSetup)
        function setupMeasurements(testCase)
            parser = tydex.parsers.FSAETTC_SI_ISO_Mat();
            measurements1 = parser.run(testCase.MeasurementFileCornering);
            measurements2 = parser.run(testCase.MeasurementFileDriveBrake);
            measurements = [measurements1 measurements2];
            measurements = measurements.downsample(10, 0);
            testCase.Measurements = measurements;
        end
        function setupTyreModel(testCase)
            tyre = MagicFormulaTyre();
            tyre.Parameters.UNLOADED_RADIUS.Value = 0.20574;
            testCase.Tyre = tyre;
        end
        function setupFitter(testCase)
            tyre = testCase.Tyre;
            params = tyre.Parameters;
            measurements = testCase.Measurements;
            fitter = magicformula.v61.Fitter(measurements, params);
            fitter.Options.MaxFunctionEvaluations = 300; % TODO: temporary
            testCase.Fitter = fitter;
        end
    end
    methods (Test)
        function fitFx0(testCase)
            fitmode = magicformula.FitMode.Fx0;
            
            fitter = testCase.Fitter;
            fitter.FitModes = fitmode;
            fitter.run()
            
            tyre = testCase.Tyre;
            tyre.Parameters = fitter.ParametersFitted;
            
            I = fitter.FitModeFlags(char(fitmode));
            measurements = testCase.Measurements(I);
            rmse = zeros(numel(measurements), 1);
            for i = 1:numel(measurements)
                measurement = measurements(i);
                [SX,SA,FZ,IP,IA,VX,FX] = unpack(measurement);
                FX_mdl = magicformula(tyre,SX,SA,FZ,IP,IA,VX);
                FX_max = max(abs([FX FX_mdl]), [], 'all');
                FX_nrm = [FX FX_mdl]/FX_max;
                rmse(i) = sqrt(mean((FX_nrm(:,1)-FX_nrm(:,2)).^2));
            end
            rmseMean = mean(rmse);
            rmseThrd = testCase.ThresholdAverageRMSE;
            testCase.verifyLessThanOrEqual(rmseMean, rmseThrd, ...
                sprintf('Average RMSE is larger than %.2f%%', rmseThrd))
        end
        function fitFy0(testCase)
            fitmode = magicformula.FitMode.Fy0;
            
            fitter = testCase.Fitter;
            fitter.FitModes = fitmode;
            fitter.run()
            
            tyre = testCase.Tyre;
            tyre.Parameters = fitter.ParametersFitted;
            
            I = fitter.FitModeFlags(char(fitmode));
            measurements = testCase.Measurements(I);
            rmse = zeros(numel(measurements), 1);
            for i = 1:numel(measurements)
                measurement = measurements(i);
                [SX,SA,FZ,IP,IA,VX,~,FY] = unpack(measurement);
                [~, FY_mdl] = magicformula(tyre,SX,SA,FZ,IP,IA,VX);
                FY_max = max(abs([FY FY_mdl]), [], 'all');
                FY_nrm = [FY FY_mdl]/FY_max;
                rmse(i) = sqrt(mean((FY_nrm(:,1)-FY_nrm(:,2)).^2));
            end
            rmseMean = mean(rmse);
            rmseThrd = testCase.ThresholdAverageRMSE;
            testCase.verifyLessThanOrEqual(rmseMean, rmseThrd, ...
                sprintf('Average RMSE is larger than %.2f%%', rmseThrd))
        end
        function fitMz0(testCase)
            fitmode = magicformula.FitMode.Mz0;
            
            fitter = testCase.Fitter;
            fitter.FitModes = fitmode;
            fitter.run()
            
            tyre = testCase.Tyre;
            tyre.Parameters = fitter.ParametersFitted;
            
            I = fitter.FitModeFlags(char(fitmode));
            measurements = testCase.Measurements(I);
            rmse = zeros(numel(measurements), 1);
            for i = 1:numel(measurements)
                measurement = measurements(i);
                [SX,SA,FZ,IP,IA,VX,~,~,MZ] = unpack(measurement);
                [~,~,MZ_mdl] = magicformula(tyre,SX,SA,FZ,IP,IA,VX);
                MZ_max = max(abs([MZ MZ_mdl]), [], 'all');
                MZ_nrm = [MZ MZ_mdl]/MZ_max;
                rmse(i) = sqrt(mean((MZ_nrm(:,1)-MZ_nrm(:,2)).^2));
            end
            rmseMean = mean(rmse);
            rmseThrd = testCase.ThresholdAverageRMSE;
            testCase.verifyLessThanOrEqual(rmseMean, rmseThrd, ...
                sprintf('Average RMSE is larger than %.2f%%', rmseThrd))
        end
        function fitFx(testCase)
            fitmode = magicformula.FitMode.Fx;
            
            fitter = testCase.Fitter;
            fitter.FitModes = fitmode;
            fitter.run()
            
            tyre = testCase.Tyre;
            tyre.Parameters = fitter.ParametersFitted;
            
            I = fitter.FitModeFlags(char(fitmode));
            measurements = testCase.Measurements(I);
            rmse = zeros(numel(measurements), 1);
            for i = 1:numel(measurements)
                measurement = measurements(i);
                [SX,SA,FZ,IP,IA,VX,FX] = unpack(measurement);
                FX_mdl = magicformula(tyre,SX,SA,FZ,IP,IA,VX);
                FX_max = max(abs([FX FX_mdl]), [], 'all');
                FX_nrm = [FX FX_mdl]/FX_max;
                rmse(i) = sqrt(mean((FX_nrm(:,1)-FX_nrm(:,2)).^2));
            end
            rmseMean = mean(rmse);
            rmseThrd = testCase.ThresholdAverageRMSE;
            testCase.verifyLessThanOrEqual(rmseMean, rmseThrd, ...
                sprintf('Average RMSE is larger than %.2f%%', rmseThrd))
        end
        function fitFy(testCase)
            fitmode = magicformula.FitMode.Fy;
            
            fitter = testCase.Fitter;
            fitter.FitModes = fitmode;
            fitter.run()
            
            tyre = testCase.Tyre;
            tyre.Parameters = fitter.ParametersFitted;
            
            I = fitter.FitModeFlags(char(fitmode));
            measurements = testCase.Measurements(I);
            rmse = zeros(numel(measurements), 1);
            for i = 1:numel(measurements)
                measurement = measurements(i);
                [SX,SA,FZ,IP,IA,VX,~,FY] = unpack(measurement);
                [~, FY_mdl] = magicformula(tyre,SX,SA,FZ,IP,IA,VX);
                FY_max = max(abs([FY FY_mdl]), [], 'all');
                FY_nrm = [FY FY_mdl]/FY_max;
                rmse(i) = sqrt(mean((FY_nrm(:,1)-FY_nrm(:,2)).^2));
            end
            rmseMean = mean(rmse);
            rmseThrd = testCase.ThresholdAverageRMSE;
            testCase.verifyLessThanOrEqual(rmseMean, rmseThrd, ...
                sprintf('Average RMSE is larger than %.2f%%', rmseThrd))
        end
    end
end