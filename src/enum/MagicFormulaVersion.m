classdef (Hidden) MagicFormulaVersion < Simulink.IntEnumType
    enumeration
        v61 (61)
        v60 (60)
        v52 (52)
        v51 (51)
    end
    methods (Static)
        function obj = fromFITTYP(fittyp)
            if ~isnumeric(fittyp)
                fittyp = str2double(fittyp);
            end
            switch fittyp
                case 5
                    obj = MagicFormulaVersion.v51;
                case {6, 21}
                    obj = MagicFormulaVersion.v52;
                case 60
                    obj = MagicFormulaVersion.v60;
                case 61
                    obj = MagicFormulaVersion.v61;
                otherwise
                    error('Invalid FITTYP value ''%d''!', fittyp)
            end
        end
    end
end

