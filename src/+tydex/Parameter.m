classdef (Abstract) Parameter
    properties (Access = public)
        Name    char
        Desc    char
    end
    
    properties (Access = protected)
        DescMap containers.Map
    end
    
    methods
        function param = Parameter()
            param.DescMap = param.initDescMap();
        end
        function param = set.Name(param, name)
            param.Name = name;
            param = param.setDescription(name);
        end
    end
    
    methods (Access = protected)
        function param = setDescription(param, name)
            try param.Desc = param.DescMap(name);catch;end
        end
    end
    
    methods (Static)
        function map = initDescMap()
            map = containers.Map;
            map('RELEASE')  = 'Release of TYDEX-format';
            map('MEASID')   = 'measurement id.';
            map('SUPPLIER') = 'Data supplier';
            map('DATE')     = 'Date';
            map('CLCKTIME') = 'Clocktime';
            map('TESTMETH') = 'test method';
            map('NOMWIDTH') = 'nominal section width of tyre';
            map('TYSTRUCT') = 'tyre structure';
            map('NOMDIAME') = 'nominal diameter of tyre';
            map('RIMDIAME') = 'nominal rim diameter';
            map('MANUFACT') = 'manufacturer';
            map('PARTNUM')  = 'part number';
            map('OVALLDIA') = 'overall diameter';
            map('RFREE')    = 'Unloaded radius';
            map('FNOMIN')   = 'Nominal vertical load';
            map('NOMPRES')  = 'Nominal inflation pressure';
            map('RUNTIME')  = 'Running Time';
            map('LONGVEL')  = 'longitudinal velocity';
            map('WHROTSPD') = 'WHEEL rotation speed';
            map('SLIPANGL') = 'slip angle';
            map('INCLANGL') = 'inclination angle';
            map('INFLPRES') = 'inflation pressure';
            map('FX')       = 'longitudinal force';
            map('FYW')      = 'lateral force';
            map('FZW')      = 'vertical force';
            map('MXW')      = 'overturning moment';
            map('MZW')      = 'aligning moment';
            map('LGFCCOEF') = 'long. force coefficient';
            map('LTFCCOEF') = 'lateral force coefficient';
            map('LONGSLIP') = 'longitudinal slip';
            map('TRCKTEMP') = 'temperature of track';
            map('TRDTEMP')  = 'tread surface temperature';
            map('AMBITEMP') = 'ambient temperature';
        end
    end
end