classdef MagicFormulaTyre < matlab.mixin.Copyable & matlab.mixin.CustomDisplay
    %MAGICFORMULATYRE Represents a single Magic Formula Tyre model.
    %   tyre = MAGICFORMULATYRE(file)
    %   tyre = MAGICFORMULATYRE(version)
    %
    % MAGICFORMULATYRE Properties:
    %   Parameters -    - Magic Formula parameter set (e.g. PCX1, PDX1, ...)
    %   File            - Tire Properties File (*.tir) attributed to object.
    %   Version         - Returns enum type from 'FITTYP' parameter.
    %
    % MAGICFORMULATYRE Methods:
    %   loadTIR         - Load parameters from Tire Properties File (*.tir).
    %   saveTIR         - Save parameters to Tire Properties File (*.tir).
    %   fit             - Fit magicformula to measurements using fmincon.
    %
    % See also: magicformula
    
    properties
        %PARAMETERS Magic Formula parameter set (e.g. PCX1, PDX1, ...)
        Parameters magicformula.Parameters = magicformula.v61.Parameters()
        %FILE Tire Properties File (*.tir) attributed to object.
        File char
    end
    properties (SetAccess = protected)
        %VERSION Returns enum type from 'FITTYP' parameter.
        % This property is inferred from parameters and therefore read-only.
        Version
    end
    methods
        function obj = MagicFormulaTyre(varargin)
            narginchk(0,1)
            if nargin() == 0
                params = magicformula.v61.Parameters();
                obj.Parameters = params;
                return
            end
            
            input = varargin{1};
            if ischar(input) && isfile(input)
                isTIR = endsWith(input, '.tir', 'IgnoreCase', true);
                assert(isTIR, 'Must be Tire Properties File (*.tir).')
                loadTIR(obj, input);
                return
            end
            
            version = MagicFormulaVersion(input);
            switch version
                case MagicFormulaVersion.v61
                    params = magicformula.v61.Parameters();
                otherwise
                    error('Version %s not supported yet.', version)
            end
            obj.Parameters = params;
        end
        function value = get.Version(obj)
            fittyp = obj.Parameters.FITTYP.Value;
            value = MagicFormulaVersion.fromFITTYP(fittyp);
        end
        function loadTIR(obj, file)
            %LOADTIR Load parameters from Tire Properties File (*.tir).
            mustBeFile(file)
            reader = magicformula.TyrePropertiesFileReader();
            parameters = reader.parse(file);
            obj.Parameters = parameters;
            obj.File = file;
        end
        saveTIR(obj, file)
        function fit(obj, measurements, fitmodes, options)
            %FIT Fit magicformula to measurements using fmincon.
            arguments
                obj
                measurements tydex.Measurement
                fitmodes magicformula.FitMode
                options struct = struct.empty
            end
            params = obj.Parameters;
            version = obj.Version;
            switch version
                case MagicFormulaVersion.v61
                    fitter = magicformula.v61.Fitter(measurements, params);
                otherwise
                    error('Version %s not supported', version)
            end
            fitter.FitModes = fitmodes;
            if ~isempty(options)
                fitter.Options = options;
            end
            fitter.run()
            params = fitter.ParametersFitted;
            obj.Parameters = params;
        end
    end
    methods (Access = protected)
        function header = getHeader(obj)
            if ~isscalar(obj)
                header = getHeader@matlab.mixin.CustomDisplay(obj);
                return
            end
            class = matlab.mixin.CustomDisplay.getClassNameForHeader(obj);
            version = char(obj.Version);
            header = sprintf('%s (%s)\n', class, version);
        end
        function groups = getPropertyGroups(obj)
            if isscalar(obj)
                mc = metaclass(obj);
                propList = {mc.PropertyList.Name};
                I = contains(propList, {'Version'});
                groups = matlab.mixin.util.PropertyGroup(propList(~I));
            else
                groups = getPropertyGroups@matlab.mixin.CustomDisplay(obj);
            end
        end
    end
end
