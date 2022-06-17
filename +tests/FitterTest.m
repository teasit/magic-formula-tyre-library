classdef FitterTest < matlab.unittest.TestCase
    properties
        Fitter magicformula.v62.Fitter
        TyreModel magicformula.v62.Model
        Measurements tydex.Measurement
        MeasurementFileCornering char {mustBeFile} = ...
            fullfile('doc', 'examples', 'fsae-ttc-data', 'fsaettc_obscured_testbench_cornering.mat')
        MeasurementFileDriveBrake char {mustBeFile} = ...
            fullfile('doc', 'examples', 'fsae-ttc-data', 'fsaettc_obscured_testbench_drivebrake.mat')
        %Average RMSE of model versus data across fitted measurements must
        %be lower than this value or test will fail.
        ThresholdAverageRMSE = 0.15;
    end
    methods (TestClassSetup)
        function setupMeasurements(testCase)
            parser = tydex.parsers.FSAETTC_SI_ISO_Mat_Cornering();
            measurements1 = parser.run(testCase.MeasurementFileCornering);
            
            parser = tydex.parsers.FSAETTC_SI_ISO_Mat_DriveBrake();
            measurements2 = parser.run(testCase.MeasurementFileDriveBrake);
            
            testCase.Measurements = [measurements1 measurements2];
        end
        function setupTyreModel(testCase)
            tyre = magicformula.v62.Model();
            tyre.Parameters.UNLOADED_RADIUS.Value = 0.20574;
            testCase.TyreModel = tyre;
        end
        function setupFitter(testCase)
            tyre = testCase.TyreModel;
            params = tyre.Parameters;
            measurements = testCase.Measurements;
            fitter = magicformula.v62.Fitter(measurements, params);
            testCase.Fitter = fitter;
        end
    end
    methods (Test)
        function fitFx0(testCase)
            fitmode = magicformula.v62.FitMode.Fx0;
            
            fitter = testCase.Fitter;
            fitter.FitModes = fitmode;
            fitter.run()
            
            tyre = testCase.TyreModel;
            tyre.Parameters = fitter.ParametersFitted;
            
            I = fitter.FitModeFlags(char(fitmode));
            measurements = testCase.Measurements(I);
            rmse = zeros(numel(measurements), 1);
            for i = 1:numel(measurements)
                measurement = measurements(i);
                SA = measurement.SLIPANGL;
                SX = measurement.LONGSLIP;
                IA = measurement.INCLANGL;
                IP = measurement.INFLPRES;
                FZ = measurement.FZW;
                FX = measurement.FX;
                FX_mdl = tyre.eval(SA,SX,IA,IP,FZ,0);
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
            fitmode = magicformula.v62.FitMode.Fy0;
            
            fitter = testCase.Fitter;
            fitter.FitModes = fitmode;
            fitter.run()
            
            tyre = testCase.TyreModel;
            tyre.Parameters = fitter.ParametersFitted;
            
            I = fitter.FitModeFlags(char(fitmode));
            measurements = testCase.Measurements(I);
            rmse = zeros(numel(measurements), 1);
            for i = 1:numel(measurements)
                measurement = measurements(i);
                SA = measurement.SLIPANGL;
                SX = measurement.LONGSLIP;
                IA = measurement.INCLANGL;
                IP = measurement.INFLPRES;
                FZ = measurement.FZW;
                FY = measurement.FYW;
                [~,FY_mdl] = tyre.eval(SA,SX,IA,IP,FZ,0);
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
            fitmode = magicformula.v62.FitMode.Mz0;
            
            fitter = testCase.Fitter;
            fitter.FitModes = fitmode;
            fitter.run()
            
            tyre = testCase.TyreModel;
            tyre.Parameters = fitter.ParametersFitted;
            
            I = fitter.FitModeFlags(char(fitmode));
            measurements = testCase.Measurements(I);
            rmse = zeros(numel(measurements), 1);
            for i = 1:numel(measurements)
                measurement = measurements(i);
                SA = measurement.SLIPANGL;
                SX = measurement.LONGSLIP;
                IA = measurement.INCLANGL;
                IP = measurement.INFLPRES;
                FZ = measurement.FZW;
                MZ = measurement.MZW;
                [~,~,MZ_mdl] = tyre.eval(SA,SX,IA,IP,FZ,0);
                MZ_max = max(abs([MZ MZ_mdl]), [], 'all');
                MZ_nrm = [MZ MZ_mdl]/MZ_max;
                rmse(i) = sqrt(mean((MZ_nrm(:,1)-MZ_nrm(:,2)).^2));
            end
            rmseMean = mean(rmse);
            rmseThrd = testCase.ThresholdAverageRMSE;
            testCase.verifyLessThanOrEqual(rmseMean, rmseThrd, ...
                sprintf('Average RMSE is larger than %.2f%%', rmseThrd))
        end
    end
end