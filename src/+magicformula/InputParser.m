classdef (Hidden) InputParser
    %MAGICFORMULA.INPUTPARSER Parses magic formula input arguments.
    methods (Static)
        function [p,SX,SA,FZ,IP,IA,VX,side,ver] = parse(p,SX,SA,varargin)
            versions = enumeration('MagicFormulaVersion');
            isValidVersion = @(x) mustBeMember(x, versions);
            isValidNumericVector = @(x) isnumeric(x) && isvector(x);
            isValidTyreSide = @(x) mustBeMember(x, [0, 1]);

            getNonempty = @magicformula.InputParser.getNonempty;
            p    = magicformula.InputParser.parseParams(p);
            FZ   = getNonempty(p.FNOMIN, 1E3);
            IP   = getNonempty(p.INFLPRES, p.NOMPRES, 80E3);
            IA   = 0;
            VX   = getNonempty(p.LONGVL, p.VXLOW, 10);
            side = getNonempty(p.TYRESIDE, 'LEFT');
            ver  = MagicFormulaVersion.fromFITTYP(p.FITTYP);
            ver  = getNonempty(ver,versions(1));

            parser = inputParser();
            parser.addRequired('SX',isValidNumericVector);
            parser.addRequired('SA',isValidNumericVector);
            parser.addOptional('FZ',FZ,isValidNumericVector);
            parser.addOptional('IP',IP,isValidNumericVector);
            parser.addOptional('IA',IA,isValidNumericVector);
            parser.addOptional('VX',VX,isValidNumericVector);
            parser.addOptional('side',side,isValidTyreSide);
            parser.addOptional('version',ver,isValidVersion);
            parser.parse(SX, SA, varargin{:});

            results = parser.Results;
            SX   = results.SX;
            SA   = results.SA;
            FZ   = results.FZ;
            IP   = results.IP;
            IA   = results.IA;
            VX   = results.VX;
            side = results.side;
            ver  = results.version;
        end
    end
    methods (Static, Hidden)
        function arg = getNonempty(varargin)
            for i = 1:nargin()
                arg = varargin{i};
                if ~isempty(arg)
                    return
                end
            end
        end
        function p = parseParams(p)
            isValidParameters = @(x) isstruct(x) ...
                || isa(x, 'MagicFormulaTyre') ...
                || isa(x, 'magicformula.Parameters') ...
                || isfile(x);
            parser = inputParser();
            parser.addRequired('params',isValidParameters);
            parser.parse(p);
            results = parser.Results;
            p = results.params;
            switch class(p)
                case 'MagicFormulaTyre'
                    tyre = p;
                    p = tyre.Parameters;
                    p = struct(p);
                case 'char'
                    file = p;
                    tyre = MagicFormulaTyre(file);
                    p = tyre.Parameters;
                    p = struct(p);
                otherwise
                    p = struct(p);
            end
        end
    end
end
