classdef (Hidden) InputParser
    %MAGICFORMULA.INPUTPARSER Parses magic formula input arguments.
    methods (Static)
        function [p,SX,SA,FZ,IP,IA,VX,side,ver] = parse(p,SX,SA,varargin)
            versions = enumeration('MagicFormulaVersion');
            isVersion = @(x) mustBeMember(x, versions);
            isVector = @(x) isnumeric(x) && isvector(x);
            isTyreSide = @(x) mustBeMember(x, [0, 1]);
            isWithinBounds = @(x,lb,ub) isVector(x) && all(x>lb & x<ub);

            getNonempty = @magicformula.InputParser.getNonempty;
            p    = magicformula.InputParser.parseParams(p);
            FZ   = getNonempty(p.FNOMIN, 1E3);
            IP   = getNonempty(p.INFLPRES, p.NOMPRES, 80E3);
            IA   = 0;
            VX   = getNonempty(p.LONGVL, p.VXLOW, 10);
            side = getNonempty(p.TYRESIDE, 'LEFT');
            ver  = MagicFormulaVersion.fromFITTYP(p.FITTYP);
            ver  = getNonempty(ver,versions(1));

            FZMAX = getNonempty(p.FZMAX, inf);
            FZMIN = getNonempty(p.FZMIN, eps);
            KPUMAX = getNonempty(p.KPUMAX, +1);
            KPUMIN = getNonempty(p.KPUMIN, -1);
            PRESMAX = getNonempty(p.PRESMAX, inf);
            PRESMIN = getNonempty(p.PRESMIN, eps);
            ALPMAX = getNonempty(p.ALPMAX, +pi);
            ALPMIN = getNonempty(p.ALPMIN, -pi);
            CAMMAX = getNonempty(p.CAMMAX, +pi/2);
            CAMMIN = getNonempty(p.CAMMIN, -pi/2);

            isValidFZ = @(FZ) isWithinBounds(FZ, FZMIN, FZMAX);
            isValidIP = @(IP) isWithinBounds(IP, PRESMIN, PRESMAX);
            isValidSX = @(SX) isWithinBounds(SX, KPUMIN, KPUMAX);
            isValidSA = @(SA) isWithinBounds(SA, ALPMIN, ALPMAX);
            isValidIA = @(IA) isWithinBounds(IA, CAMMIN, CAMMAX);

            parser = inputParser();
            parser.addRequired('SX', isValidSX);
            parser.addRequired('SA', isValidSA);
            parser.addOptional('FZ', FZ, isValidFZ);
            parser.addOptional('IP', IP, isValidIP);
            parser.addOptional('IA', IA, isValidIA);
            parser.addOptional('VX', VX, isVector);
            parser.addOptional('side', side, isTyreSide);
            parser.addOptional('version', ver, isVersion);
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
