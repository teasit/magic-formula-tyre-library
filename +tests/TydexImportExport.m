classdef TydexImportExport < matlab.unittest.TestCase
    properties
        TdxSaveDir char = fullfile(tempdir(), 'tdx-test');
        MeasurementsParsed tydex.Measurement
    end
    methods (TestClassSetup)
        function parseMeasurements(testCase)
            file = fullfile('doc', 'examples', 'fsae-ttc-data', ...
                'fsaettc_obscured_testbench_drivebrake.mat');
            parser = tydex.parsers.FSAETTC_SI_ISO_Mat_DriveBrake();
            measurements = parser.run(file);
            testCase.MeasurementsParsed = measurements;
        end
        function createTempFolder(testCase) 
            savedir = testCase.TdxSaveDir;
            mkdir(savedir)
        end
    end
    methods (TestClassTeardown)
        function deleteTdxFromTempFolder(testCase)
            state = recycle();
            recycle('off')
            savedir = testCase.TdxSaveDir;
            rmdir(savedir, 's')
            recycle(state)
        end
    end
    methods (Test)
        function testWrite(testCase)
            writer = tydex.FileWriter();
            writer.Measurements = testCase.MeasurementsParsed;
            savedir = testCase.TdxSaveDir;
            writer.write(savedir)
        end
        function testImport(testCase)
            reader = tydex.FileReader();
            savedir = testCase.TdxSaveDir;
            listing = dir(savedir);
            isdir = [listing.isdir];
            files = {listing(~isdir).name};
            measurements = tydex.Measurement.empty;
            measurementsParsed = testCase.MeasurementsParsed;
            for i = 1:numel(files)
                file = files{i};
                file = fullfile(savedir, file);
                measurement = reader.read(file);
                measurements(1,i) = measurement;
            end
            verifyLength(testCase, measurements, length(measurementsParsed))
            verifyNumElements(testCase, measurements, numel(measurementsParsed))
            %             for i = 1:numel(measurements)
            %                 measurement = measurements(i);
            %                 measurementreadd = MeasurementsParsed(i);
            %                 names = properties(measurement);
            %                 for j = 1:numel(names)
            %                     name = names{j};
            %                     val = measurement.(name);
            %                     valreadd = measurementreadd.(name);
            %                     verifyEqual(testCase, val, valreadd)
            %                 end
            %             end
        end
    end
end