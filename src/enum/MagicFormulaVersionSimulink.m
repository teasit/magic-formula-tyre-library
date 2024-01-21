classdef MagicFormulaVersionSimulink < Simulink.IntEnumType
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
                    obj = MagicFormulaVersionSimulink.v51;
                case {6, 21}
                    obj = MagicFormulaVersionSimulink.v52;
                case 60
                    obj = MagicFormulaVersionSimulink.v60;
                case 61
                    obj = MagicFormulaVersionSimulink.v61;
                otherwise
                    error('Invalid FITTYP value ''%d''!', fittyp)
            end
        end
    end
end

