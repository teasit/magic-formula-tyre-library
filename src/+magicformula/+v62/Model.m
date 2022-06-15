classdef Model < magicformula.Model
    properties
        Parameters magicformula.v62.Parameters = magicformula.v62.Parameters()
        Description string
        File char
        Version
    end
    properties (Constant, Access = private)
        % The minimal set of parameters required by Siemens NX to work
        MinimalSetOfParameters = {
            'VERTICAL_STIFFNESS'
            'PDX1'
            'PKX1'
            'PDY1'
            'PKY1'
            'PKY2'
            'INFLPRES'
            'UNLOADED_RADIUS'
            'WIDTH'
            'RIM_RADIUS'
            'FNOMIN'
            };
    end
    methods
        function mdl = Model(file)
            arguments
                file char = char.empty
            end
            if ~isempty(file)
                mustBeFile(file)
                mdl.importTyrePropertiesFile(file);
            end
        end
        function [Fx,Fy,mux,muy] = eval(mdl,slipangl,longslip,inclangl,...
                pressure,tyreNormF,tyreSide)
            params = struct(mdl.Parameters);
            [Fx,Fy,mux,muy] = magicformula.v62.eval(params,...
                slipangl,longslip,inclangl,pressure,tyreNormF,tyreSide);
        end
        function value = get.Version(mdl)
            value = mdl.Parameters.FITTYP.Value;
        end
        function importTyrePropertiesFile(mdl, fileName)
            reader = tir.TyrePropertiesFileReader();
            mdl.Parameters = reader.parse(fileName);
            mdl.File = fileName;
        end
        function exportTyrePropertiesFile(mdl, fileName)
            fprintf("\nPrinting model parameters to '%s'...\n\n",fileName)
            p = mdl.Parameters;
            fileid = fopen(fileName,'wt');
            try
                doc = tir.TyrePropertiesFileCreator(fileid);
                
                doc.printSection('MDI_HEADER',false)
                doc.printParameter('FILE_TYPE', "'tir'")
                doc.printParameter('FILE_VERSION', '3')
                doc.printParameter('FILE_FORMAT', "'ASCII'")
                
                doc.printSection('UNITS')
                doc.printParameter('LENGTH', "'meter'")
                doc.printParameter('FORCE', "'newton'")
                doc.printParameter('ANGLE', "'radians'")
                doc.printParameter('MASS', "'kg'")
                doc.printParameter('TIME', "'second'")
                
                doc.printSection('MODEL')
                doc.printParameter('FITTYP', p.FITTYP.Value)
                doc.printParameter('TYRESIDE', strcat("'",p.TYRESIDE.Value,"'"))
                doc.printParameter('LONGVL', p.LONGVL.Value)
                doc.printParameter('VXLOW', p.VXLOW.Value)
                doc.printParameter('ROAD_INCREMENT', p.ROAD_INCREMENT.Value)
                doc.printParameter('ROAD_DIRECTION', p.ROAD_DIRECTION.Value)
                
                doc.printSection('DIMENSION')
                doc.printParameter('UNLOADED_RADIUS', p.UNLOADED_RADIUS.Value)
                doc.printParameter('WIDTH', p.WIDTH.Value)
                doc.printParameter('ASPECT_RATIO', p.ASPECT_RATIO.Value)
                doc.printParameter('RIM_RADIUS', p.RIM_RADIUS.Value)
                doc.printParameter('RIM_WIDTH', p.RIM_WIDTH.Value)
                
                doc.printSection('OPERATING_CONDITIONS')
                doc.printParameter('INFLPRES', p.INFLPRES.Value)
                doc.printParameter('NOMPRES', p.NOMPRES.Value)
                
                doc.printSection('INERTIA')
                doc.printParameter('MASS', p.MASS.Value)
                doc.printParameter('IXX', p.IXX.Value)
                doc.printParameter('IYY', p.IYY.Value)
                doc.printParameter('BELT_MASS', p.BELT_MASS.Value)
                doc.printParameter('BELT_IXX', p.BELT_IXX.Value)
                doc.printParameter('BELT_IYY', p.BELT_IYY.Value)
                doc.printParameter('GRAVITY', p.GRAVITY.Value)
                
                doc.printSection('VERTICAL')
                doc.printParameter('FNOMIN', p.FNOMIN.Value)
                doc.printParameter('VERTICAL_STIFFNESS', p.VERTICAL_STIFFNESS.Value)
                doc.printParameter('VERTICAL_DAMPING', p.VERTICAL_DAMPING.Value)
                doc.printParameter('MC_CONTOUR_A', p.MC_CONTOUR_A.Value)
                doc.printParameter('MC_CONTOUR_B', p.MC_CONTOUR_B.Value)
                doc.printParameter('BREFF', p.BREFF.Value)
                doc.printParameter('DREFF', p.DREFF.Value)
                doc.printParameter('FREFF', p.FREFF.Value)
                doc.printParameter('Q_RE0', p.Q_RE0.Value)
                doc.printParameter('Q_V1', p.Q_V1.Value)
                doc.printParameter('Q_V2', p.Q_V2.Value)
                doc.printParameter('Q_FZ2', p.Q_FZ2.Value)
                doc.printParameter('Q_FCX', p.Q_FCX.Value)
                doc.printParameter('Q_FCY', p.Q_FCY.Value)
                doc.printParameter('Q_CAM', p.Q_CAM.Value)
                doc.printParameter('PFZ1', p.PFZ1.Value)
                doc.printParameter('Q_FCY2', p.Q_FCY2.Value)
                doc.printParameter('Q_CAM1', p.Q_CAM1.Value)
                doc.printParameter('Q_CAM2', p.Q_CAM2.Value)
                doc.printParameter('Q_CAM3', p.Q_CAM3.Value)
                doc.printParameter('Q_FYS1', p.Q_FYS1.Value)
                doc.printParameter('Q_FYS2', p.Q_FYS2.Value)
                doc.printParameter('Q_FYS3', p.Q_FYS3.Value)
                doc.printParameter('BOTTOM_OFFST', p.BOTTOM_OFFST.Value)
                doc.printParameter('BOTTOM_STIFF', p.BOTTOM_STIFF.Value)
                
                doc.printSection('STRUCTURAL')
                doc.printParameter('LONGITUDINAL_STIFFNESS', p.LONGITUDINAL_STIFFNESS.Value)
                doc.printParameter('LATERAL_STIFFNESS', p.LATERAL_STIFFNESS.Value)
                doc.printParameter('YAW_STIFFNESS', p.YAW_STIFFNESS.Value)
                doc.printParameter('FREQ_LONG', p.FREQ_LONG.Value)
                doc.printParameter('FREQ_LAT', p.FREQ_LAT.Value)
                doc.printParameter('FREQ_YAW', p.FREQ_YAW.Value)
                doc.printParameter('FREQ_WINDUP', p.FREQ_WINDUP.Value)
                doc.printParameter('DAMP_LONG', p.DAMP_LONG.Value)
                doc.printParameter('DAMP_LAT', p.DAMP_LAT.Value)
                doc.printParameter('DAMP_YAW', p.DAMP_YAW.Value)
                doc.printParameter('DAMP_WINDUP', p.DAMP_WINDUP.Value)
                doc.printParameter('DAMP_RESIDUAL', p.DAMP_RESIDUAL.Value)
                doc.printParameter('DAMP_VLOW', p.DAMP_VLOW.Value)
                doc.printParameter('Q_BVX', p.Q_BVX.Value)
                doc.printParameter('Q_BVT', p.Q_BVT.Value)
                doc.printParameter('PCFX1', p.PCFX1.Value)
                doc.printParameter('PCFX2', p.PCFX2.Value)
                doc.printParameter('PCFX3', p.PCFX3.Value)
                doc.printParameter('PCFY1', p.PCFY1.Value)
                doc.printParameter('PCFY2', p.PCFY2.Value)
                doc.printParameter('PCFY3', p.PCFY3.Value)
                doc.printParameter('PCMZ1', p.PCMZ1.Value)
                
                doc.printSection('CONTACT_PATCH')
                doc.printParameter('Q_RA1', p.Q_RA1.Value)
                doc.printParameter('Q_RA2', p.Q_RA2.Value)
                doc.printParameter('Q_RB1', p.Q_RB1.Value)
                doc.printParameter('Q_RB2', p.Q_RB2.Value)
                doc.printParameter('ELLIPS_SHIFT', p.ELLIPS_SHIFT.Value)
                doc.printParameter('ELLIPS_LENGTH', p.ELLIPS_LENGTH.Value)
                doc.printParameter('ELLIPS_HEIGHT', p.ELLIPS_HEIGHT.Value)
                doc.printParameter('ELLIPS_ORDER', p.ELLIPS_ORDER.Value)
                doc.printParameter('ELLIPS_MAX_STEP', p.ELLIPS_MAX_STEP.Value)
                doc.printParameter('ELLIPS_NWIDTH', p.ELLIPS_NWIDTH.Value)
                doc.printParameter('ELLIPS_NLENGTH', p.ELLIPS_NLENGTH.Value)
                doc.printParameter('ENV_C1', p.ENV_C1.Value)
                doc.printParameter('ENV_C2', p.ENV_C2.Value)
                
                doc.printSection('INFLATION_PRESSURE_RANGE')
                doc.printParameter('PRESMIN', p.PRESMIN.Value)
                doc.printParameter('PRESMAX', p.PRESMAX.Value)
                
                doc.printSection('VERTICAL_FORCE_RANGE')
                doc.printParameter('FZMIN', p.FZMIN.Value)
                doc.printParameter('FZMAX', p.FZMAX.Value)
                
                doc.printSection('LONG_SLIP_RANGE')
                doc.printParameter('KPUMIN', p.KPUMIN.Value)
                doc.printParameter('KPUMAX', p.KPUMAX.Value)
                
                doc.printSection('SLIP_ANGLE_RANGE')
                doc.printParameter('ALPMIN', p.ALPMIN.Value)
                doc.printParameter('ALPMAX', p.ALPMAX.Value)
                
                doc.printSection('INCLINATION_ANGLE_RANGE')
                doc.printParameter('CAMMIN', p.CAMMIN.Value)
                doc.printParameter('CAMMAX', p.CAMMAX.Value)
                
                doc.printSection('SCALING_COEFFICIENTS')
                doc.printParameter('LFZO', p.LFZO.Value)
                doc.printParameter('LCX', p.LCX.Value)
                doc.printParameter('LMUX', p.LMUX.Value)
                doc.printParameter('LEX', p.LEX.Value)
                doc.printParameter('LKX', p.LKX.Value)
                doc.printParameter('LHX', p.LHX.Value)
                doc.printParameter('LVX', p.LVX.Value)
                doc.printParameter('LCY', p.LCY.Value)
                doc.printParameter('LMUY', p.LMUY.Value)
                doc.printParameter('LEY', p.LEY.Value)
                doc.printParameter('LKY', p.LKY.Value)
                doc.printParameter('LHY', p.LHY.Value)
                doc.printParameter('LVY', p.LVY.Value)
                doc.printParameter('LTR', p.LTR.Value)
                doc.printParameter('LRES', p.LRES.Value)
                doc.printParameter('LXAL', p.LXAL.Value)
                doc.printParameter('LYKA', p.LYKA.Value)
                doc.printParameter('LVYKA', p.LVYKA.Value)
                doc.printParameter('LS', p.LS.Value)
                doc.printParameter('LKYC', p.LKYC.Value)
                doc.printParameter('LKZC', p.LKZC.Value)
                doc.printParameter('LVMX', p.LVMX.Value)
                doc.printParameter('LMX', p.LMX.Value)
                doc.printParameter('LMY', p.LMY.Value)
                doc.printParameter('LMP', p.LMP.Value)
                
                doc.printSection('LONGITUDINAL_COEFFICIENTS')
                doc.printParameter('PCX1', p.PCX1.Value)
                doc.printParameter('PDX1', p.PDX1.Value)
                doc.printParameter('PDX2', p.PDX2.Value)
                doc.printParameter('PDX3', p.PDX3.Value)
                doc.printParameter('PEX1', p.PEX1.Value)
                doc.printParameter('PEX2', p.PEX2.Value)
                doc.printParameter('PEX3', p.PEX3.Value)
                doc.printParameter('PEX4', p.PEX4.Value)
                doc.printParameter('PKX1', p.PKX1.Value)
                doc.printParameter('PKX2', p.PKX2.Value)
                doc.printParameter('PKX3', p.PKX3.Value)
                doc.printParameter('PHX1', p.PHX1.Value)
                doc.printParameter('PHX2', p.PHX2.Value)
                doc.printParameter('PVX1', p.PVX1.Value)
                doc.printParameter('PVX2', p.PVX2.Value)
                doc.printParameter('PPX1', p.PPX1.Value)
                doc.printParameter('PPX2', p.PPX2.Value)
                doc.printParameter('PPX3', p.PPX3.Value)
                doc.printParameter('PPX4', p.PPX4.Value)
                doc.printParameter('RBX1', p.RBX1.Value)
                doc.printParameter('RBX2', p.RBX2.Value)
                doc.printParameter('RBX3', p.RBX3.Value)
                doc.printParameter('RCX1', p.RCX1.Value)
                doc.printParameter('REX1', p.REX1.Value)
                doc.printParameter('REX2', p.REX2.Value)
                doc.printParameter('RHX1', p.RHX1.Value)
                
                doc.printSection('OVERTURNING_COEFFICIENTS')
                doc.printParameter('QSX1', p.QSX1.Value)
                doc.printParameter('QSX2', p.QSX2.Value)
                doc.printParameter('QSX3', p.QSX3.Value)
                doc.printParameter('QSX4', p.QSX4.Value)
                doc.printParameter('QSX5', p.QSX5.Value)
                doc.printParameter('QSX6', p.QSX6.Value)
                doc.printParameter('QSX7', p.QSX7.Value)
                doc.printParameter('QSX8', p.QSX8.Value)
                doc.printParameter('QSX9', p.QSX9.Value)
                doc.printParameter('QSX10', p.QSX10.Value)
                doc.printParameter('QSX11', p.QSX11.Value)
                doc.printParameter('QSX12', p.QSX12.Value)
                doc.printParameter('QSX13', p.QSX13.Value)
                doc.printParameter('QSX14', p.QSX14.Value)
                doc.printParameter('PPMX1', p.PPMX1.Value)
                
                doc.printSection('LATERAL_COEFFICIENTS')
                doc.printParameter('PCY1', p.PCY1.Value)
                doc.printParameter('PDY1', p.PDY1.Value)
                doc.printParameter('PDY2', p.PDY2.Value)
                doc.printParameter('PDY3', p.PDY3.Value)
                doc.printParameter('PEY1', p.PEY1.Value)
                doc.printParameter('PEY2', p.PEY2.Value)
                doc.printParameter('PEY3', p.PEY3.Value)
                doc.printParameter('PEY4', p.PEY4.Value)
                doc.printParameter('PEY5', p.PEY5.Value)
                doc.printParameter('PKY1', p.PKY1.Value)
                doc.printParameter('PKY2', p.PKY2.Value)
                doc.printParameter('PKY3', p.PKY3.Value)
                doc.printParameter('PKY4', p.PKY4.Value)
                doc.printParameter('PKY5', p.PKY5.Value)
                doc.printParameter('PKY6', p.PKY6.Value)
                doc.printParameter('PKY7', p.PKY7.Value)
                doc.printParameter('PHY1', p.PHY1.Value)
                doc.printParameter('PHY2', p.PHY2.Value)
                doc.printParameter('PVY1', p.PVY1.Value)
                doc.printParameter('PVY2', p.PVY2.Value)
                doc.printParameter('PVY3', p.PVY3.Value)
                doc.printParameter('PVY4', p.PVY4.Value)
                doc.printParameter('PPY1', p.PPY1.Value)
                doc.printParameter('PPY2', p.PPY2.Value)
                doc.printParameter('PPY3', p.PPY3.Value)
                doc.printParameter('PPY4', p.PPY4.Value)
                doc.printParameter('PPY5', p.PPY5.Value)
                doc.printParameter('RBY1', p.RBY1.Value)
                doc.printParameter('RBY2', p.RBY2.Value)
                doc.printParameter('RBY3', p.RBY3.Value)
                doc.printParameter('RBY4', p.RBY4.Value)
                doc.printParameter('RCY1', p.RCY1.Value)
                doc.printParameter('REY1', p.REY1.Value)
                doc.printParameter('REY2', p.REY2.Value)
                doc.printParameter('RHY1', p.RHY1.Value)
                doc.printParameter('RHY2', p.RHY2.Value)
                doc.printParameter('RVY1', p.RVY1.Value)
                doc.printParameter('RVY2', p.RVY2.Value)
                doc.printParameter('RVY3', p.RVY3.Value)
                doc.printParameter('RVY4', p.RVY4.Value)
                doc.printParameter('RVY5', p.RVY5.Value)
                doc.printParameter('RVY6', p.RVY6.Value)
                
                doc.printSection('ROLLING_COEFFICIENTS')
                doc.printParameter('QSY1', p.QSY1.Value)
                doc.printParameter('QSY2', p.QSY2.Value)
                doc.printParameter('QSY3', p.QSY3.Value)
                doc.printParameter('QSY4', p.QSY4.Value)
                doc.printParameter('QSY5', p.QSY5.Value)
                doc.printParameter('QSY6', p.QSY6.Value)
                doc.printParameter('QSY7', p.QSY7.Value)
                doc.printParameter('QSY8', p.QSY8.Value)
                
                doc.printSection('ALIGNING_COEFFICIENTS')
                doc.printParameter('QBZ1', p.QBZ1.Value)
                doc.printParameter('QBZ2', p.QBZ2.Value)
                doc.printParameter('QBZ3', p.QBZ3.Value)
                doc.printParameter('QBZ4', p.QBZ4.Value)
                doc.printParameter('QBZ5', p.QBZ5.Value)
                doc.printParameter('QBZ9', p.QBZ9.Value)
                doc.printParameter('QBZ10', p.QBZ10.Value)
                doc.printParameter('QCZ1', p.QCZ1.Value)
                doc.printParameter('QDZ1', p.QDZ1.Value)
                doc.printParameter('QDZ2', p.QDZ2.Value)
                doc.printParameter('QDZ3', p.QDZ3.Value)
                doc.printParameter('QDZ4', p.QDZ4.Value)
                doc.printParameter('QDZ6', p.QDZ6.Value)
                doc.printParameter('QDZ7', p.QDZ7.Value)
                doc.printParameter('QDZ8', p.QDZ8.Value)
                doc.printParameter('QDZ9', p.QDZ9.Value)
                doc.printParameter('QDZ10', p.QDZ10.Value)
                doc.printParameter('QDZ11', p.QDZ11.Value)
                doc.printParameter('QEZ1', p.QEZ1.Value)
                doc.printParameter('QEZ2', p.QEZ2.Value)
                doc.printParameter('QEZ3', p.QEZ3.Value)
                doc.printParameter('QEZ4', p.QEZ4.Value)
                doc.printParameter('QEZ5', p.QEZ5.Value)
                doc.printParameter('QHZ1', p.QHZ1.Value)
                doc.printParameter('QHZ2', p.QHZ2.Value)
                doc.printParameter('QHZ3', p.QHZ3.Value)
                doc.printParameter('QHZ4', p.QHZ4.Value)
                doc.printParameter('PPZ1', p.PPZ1.Value)
                doc.printParameter('PPZ2', p.PPZ2.Value)
                doc.printParameter('SSZ1', p.SSZ1.Value)
                doc.printParameter('SSZ2', p.SSZ2.Value)
                doc.printParameter('SSZ3', p.SSZ3.Value)
                doc.printParameter('SSZ4', p.SSZ4.Value)
                
                doc.printSection('TURNSLIP_COEFFICIENTS')
                doc.printParameter('PDXP1', p.PDXP1.Value)
                doc.printParameter('PDXP2', p.PDXP2.Value)
                doc.printParameter('PDXP3', p.PDXP3.Value)
                doc.printParameter('PKYP1', p.PKYP1.Value)
                doc.printParameter('PDYP1', p.PDYP1.Value)
                doc.printParameter('PDYP2', p.PDYP2.Value)
                doc.printParameter('PDYP3', p.PDYP3.Value)
                doc.printParameter('PDYP4', p.PDYP4.Value)
                doc.printParameter('PHYP1', p.PHYP1.Value)
                doc.printParameter('PHYP2', p.PHYP2.Value)
                doc.printParameter('PHYP3', p.PHYP3.Value)
                doc.printParameter('PHYP4', p.PHYP4.Value)
                doc.printParameter('PECP1', p.PECP1.Value)
                doc.printParameter('PECP2', p.PECP2.Value)
                doc.printParameter('QDTP1', p.QDTP1.Value)
                doc.printParameter('QCRP1', p.QCRP1.Value)
                doc.printParameter('QCRP2', p.QCRP2.Value)
                doc.printParameter('QBRP1', p.QBRP1.Value)
                doc.printParameter('QDRP1', p.QDRP1.Value)
            catch ME
                rethrow(ME)
            end
            fclose(fileid);
            
            minSetOfParams = mdl.MinimalSetOfParameters;
            for i = 1:numel(minSetOfParams)
                paramName = minSetOfParams{i};
                param = p.(paramName);
                if isempty(param.Value)
                    msg = ['Parameter "%s" was not defined, although it ' ...
                        'is part of the minimum set of parameters of NX. ' ...
                        'Consider setting these parameters and exporting ' ...
                        'again.'];
                    warning(msg, paramName)
                end
            end
        end
    end
end