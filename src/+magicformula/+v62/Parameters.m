classdef Parameters
    %PARAMETERS Magic Formula 6.1.2 parameter set.
    % Parameter names implemented according to:
    %   https://functionbay.com/documentation/onlinehelp/Documents/Tire/MFTyre-MFSwift_Help.pdf
    %
    % To evaluate parameter set with magicformula.v62.eval(..) function, use the
    % "struct()" method first to convert the object to a parameter struct.
    %
    
    properties
        %% [MODEL]
        FITTYP                  = magicformula.v62.Parameter(62,'Magic Formula version number')
        TYRESIDE                = magicformula.v62.Parameter('LEFT','Position of tyre during measurements')
        LONGVL                  = magicformula.v62.Parameter([], 'Reference speed')
        VXLOW                   = magicformula.v62.Parameter([], 'Lower bourndary velocity in slip calculation')
        ROAD_INCREMENT          = magicformula.v62.Parameter([], 'Increment in road sampling')
        ROAD_DIRECTION          = magicformula.v62.Parameter([], 'Direction of travelled distance')
        %% [DIMENSION]
        UNLOADED_RADIUS         = magicformula.v62.Parameter([], 'Free tyre radius')
        WIDTH                   = magicformula.v62.Parameter([], 'Nominal section width of the tyre')
        RIM_RADIUS              = magicformula.v62.Parameter([], 'Nominal rim radius')
        RIM_WIDTH               = magicformula.v62.Parameter([], 'Rim width')
        ASPECT_RATIO            = magicformula.v62.Parameter([], 'Nominal aspect ratio')
        %% [OPERATING_CONDITIONS]
        INFLPRES                = magicformula.v62.Parameter([], 'Tyre inflation pressure')
        NOMPRES                 = magicformula.v62.Parameter(1E5, 'Nominal pressure used in (MF) equations')
        %% [INERTIA]
        MASS                    = magicformula.v62.Parameter([], 'Tyre mass')
        IXX                     = magicformula.v62.Parameter([], 'Tyre diametral moment of inertia')
        IYY                     = magicformula.v62.Parameter([], 'Tyre polar moment of inertia')
        BELT_IXX                = magicformula.v62.Parameter([], 'Belt diametral moment of inertia')
        BELT_IYY                = magicformula.v62.Parameter([], 'Belt polar moment of inertia')
        BELT_MASS               = magicformula.v62.Parameter([], 'Belt mass')
        GRAVITY                 = magicformula.v62.Parameter([], 'Gravity acting on belt in Z direction')
        %% [VERTICAL]
        FNOMIN                  = magicformula.v62.Parameter(1500, 'Nominal wheel load')
        VERTICAL_DAMPING        = magicformula.v62.Parameter([], 'Tyre vertical damping')
        VERTICAL_STIFFNESS      = magicformula.v62.Parameter([], 'Tyre vertical stiffness')
        MC_CONTOUR_A            = magicformula.v62.Parameter([], 'Motorcycle contour ellipse A')
        MC_CONTOUR_B            = magicformula.v62.Parameter([], 'Motorcycle contour ellipse B')
        BREFF                   = magicformula.v62.Parameter([], 'Low load stiffness of effective rolling radius')
        DREFF                   = magicformula.v62.Parameter([], 'Peak value of effective rolling radius')
        FREFF                   = magicformula.v62.Parameter([], 'High load stiffness of effective rolling radius')
        Q_RE0                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Ratio of free tyre radius with nominal tyre radius')
        Q_V1                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Tyre radius increase with speed')
        Q_V2                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Vertical stiffness increase with speed')
        Q_FZ2                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Quadratic term in load vs. deflection')
        Q_FCX                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Longitudinal force influence on vertical stiffness')
        Q_FCY                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Lateral force influence on vertical stiffness')
        Q_FCY2                  = magicformula.v62.ParameterFittable(0, -inf, inf, 'Explicit load dependency for including the lateral force influence on vertical stiffness')
        Q_CAM                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Stiffness reduction due to camber')
        Q_CAM1                  = magicformula.v62.ParameterFittable(0, -inf, inf, 'Linear load dependent camber angle influence on vertical stiffness')
        Q_CAM2                  = magicformula.v62.ParameterFittable(0, -inf, inf, 'Quadratic load dependent camber angle influence on vertical stiffness')
        Q_CAM3                  = magicformula.v62.ParameterFittable(0, -inf, inf, 'Linear load and camber angle dependent reduction on vertical stiffness')
        Q_FYS1                  = magicformula.v62.ParameterFittable(0, -inf, inf, 'Combined camber angle and side slip angle effect on vertical stiffness (constant)')
        Q_FYS2                  = magicformula.v62.ParameterFittable(0, -inf, inf, 'Combined camber angle and side slip angle linear effect on vertical stiffness')
        Q_FYS3                  = magicformula.v62.ParameterFittable(0, -inf, inf, 'Combined camber angle and side slip angle quadratic effect on vertical stiffness')
        PFZ1                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Pressure effect on vertical stiffness')
        BOTTOM_OFFST            = magicformula.v62.Parameter([], 'Distance to rim when bottoming starts to occur')
        BOTTOM_STIFF            = magicformula.v62.Parameter([], 'Vertical stiffness of bottomed tyre')
        %% [STRUCTURAL]
        LONGITUDINAL_STIFFNESS  = magicformula.v62.Parameter([], 'Tyre overall longitudinal stiffness')
        LATERAL_STIFFNESS       = magicformula.v62.Parameter([], 'Tyre overall lateral stiffness')
        YAW_STIFFNESS           = magicformula.v62.Parameter([], 'Tyre overall yaw stiffness')
        FREQ_LAT                = magicformula.v62.Parameter([], 'Undamped frequency longitudinal and vertical mode')
        FREQ_LONG               = magicformula.v62.Parameter([], 'Undamped frequency lateral mode')
        FREQ_WINDUP             = magicformula.v62.Parameter([], 'Undamped frequency yaw and camber mode')
        FREQ_YAW                = magicformula.v62.Parameter([], 'Undamped frequency wind-up mode')
        DAMP_LAT                = magicformula.v62.Parameter([], 'Dimensionless damping lateral mode')
        DAMP_LONG               = magicformula.v62.Parameter([], 'Undamped frequency longitudinal and vertical mode')
        DAMP_RESIDUAL           = magicformula.v62.Parameter([], 'Residual damping (proportional to stiffness')
        DAMP_VLOW               = magicformula.v62.Parameter([], 'Additional low speed damping (proportional to stiffness')
        DAMP_WINDUP             = magicformula.v62.Parameter([], 'Dimensionless damping wind-up mode')
        DAMP_YAW                = magicformula.v62.Parameter([], 'Dimensionless damping yaw and camber mode')
        Q_BVX                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Load and speed influence on in-plane translation stiffness')
        Q_BVT                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Load and speed influence on in-plane rotation stiffness ')
        PCFX1                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Tyre overall longitudinal stiffness vertical deflection dependency linear term')
        PCFX2                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Tyre overall longitudinal stiffness vertical deflection dependency quadratic term')
        PCFX3                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Tyre overall longitudinal stiffness pressure dependency')
        PCFY1                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Tyre overall lateral stiffness vertical deflection dependency linear term')
        PCFY2                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Tyre overall lateral stiffness vertical deflection dependency quadratic term')
        PCFY3                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Tyre overall lateral stiffness pressure dependency')
        PCMZ1                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Tyre overall yaw stiffness pressure dependency')
        %% [CONTACT_PATCH]
        Q_RA1                   = magicformula.v62.ParameterFittable([], -inf, inf, 'Square root term in contact length equation')
        Q_RA2                   = magicformula.v62.ParameterFittable([], -inf, inf, 'Linear term in contact length equation')
        Q_RB1                   = magicformula.v62.ParameterFittable([], -inf, inf, 'Root term in contact width equation')
        Q_RB2                   = magicformula.v62.ParameterFittable([], -inf, inf, 'Linear term in contact width equation')
        ELLIPS_SHIFT            = magicformula.v62.Parameter([], 'Scaling of distance between front and rear ellipsoid')
        ELLIPS_LENGTH           = magicformula.v62.Parameter([], 'Semimajor axis of ellipsoid')
        ELLIPS_HEIGHT           = magicformula.v62.Parameter([], 'Semiminor axis of ellipsoid')
        ELLIPS_ORDER            = magicformula.v62.Parameter([], 'Order of ellipsoid')
        ELLIPS_MAX_STEP         = magicformula.v62.Parameter([], 'Maximum height of road step')
        ELLIPS_NWIDTH           = magicformula.v62.Parameter([], 'Number of parallel ellipsoid')
        ELLIPS_NLENGTH          = magicformula.v62.Parameter([], 'Number of ellipsoids at sides of contact patch')
        ENV_C1                  = magicformula.v62.ParameterFittable([], -inf,  inf, 'Effective height attenuation')
        ENV_C2                  = magicformula.v62.ParameterFittable([], -inf,  inf, 'Effective plane angle attenuation')
        Q_A1                    = magicformula.v62.ParameterFittable([], -inf,  inf, 'Square root load term in contact length')
        Q_A2                    = magicformula.v62.ParameterFittable([], -inf,  inf, 'Linear load term in contact length')
        %% [INFLATION_PRESSURE_RANGE]
        PRESMIN                 = magicformula.v62.Parameter([], 'Minimum allowed inflation pressure')
        PRESMAX                 = magicformula.v62.Parameter([], 'Maximum allowed inflation pressure')
        %% [VERTICAL_FORCE_RANGE]
        FZMAX                   = magicformula.v62.Parameter([], 'Maximum allowed wheel load')
        FZMIN                   = magicformula.v62.Parameter([], 'Minimum allowed wheel load')
        %% [LONG_SLIP_RANGE]
        KPUMIN                  = magicformula.v62.Parameter([], 'Minimum valid wheel slip')
        KPUMAX                  = magicformula.v62.Parameter([], 'Maximum valid wheel slip')
        %% [SLIP_ANGLE_RANGE]
        ALPMIN                  = magicformula.v62.Parameter([], 'Minimum valid slip angle')
        ALPMAX                  = magicformula.v62.Parameter([], 'Maximum valid slip angle')
        %% [INCLINATION_ANGLE_RANGE]
        CAMMIN                  = magicformula.v62.Parameter([], 'Minimum valid camber angle')
        CAMMAX                  = magicformula.v62.Parameter([], 'Maximum valid camber angle')
        %% [SCALING_COEFFICIENTS]
        LFZO                    = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor of nominal (rated) load')
        LCX                     = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor of Fx shape factor')
        LMUX                    = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor of Fx peak friction coefficient')
        LEX                     = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor of Fx curvature factor')
        LKX                     = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor of slip stiffness')
        LHX                     = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor of Fx horizontal shift')
        LVX                     = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor of Fx vertical shift')
        LCY                     = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor of Fy shape factor')
        LMUY                    = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor of Fy peak friction coefficient')
        LEY                     = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor of Fy curvature factor ')
        LKY                     = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor of cornering stiffness')
        LKYC                    = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor of camber stiffness')
        LKZC                    = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor of camber moment stiffness')
        LHY                     = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor of Fy horizontal shift')
        LVY                     = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor of Fy vertical shift')
        LTR                     = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor of Peak of pneumatic trail')
        LRES                    = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor for offset of residual torque')
        LXAL                    = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor of alpha influence on Fx')
        LYKA                    = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor of alpha influence on Fy')
        LVYKA                   = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor of kappa induced Fy')
        LS                      = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor of overturning moment')
        LMX                     = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor of Mx vertical shift')
        LVMX                    = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor of overturning moment')
        LMY                     = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor of rolling resistance torque')
        LMP                     = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor of parking moment')
        LSGKP   	            = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor of Relaxation length of Fx')
        LSGAL   	            = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor of Relaxation length of Fy')
        LGYR                    = magicformula.v62.ParameterFittable(1, -inf, inf, 'Scale factor gyroscopic moment')
        %% [LONGITUDINAL_COEFFICIENTS]
        PCX1                    = magicformula.v62.ParameterFittable(1.9, 1.5, 2, 'Shape factor Cfx for longitudinal force')
        PDX1                    = magicformula.v62.ParameterFittable(2, 1, 5, 'Longitudinal friction Mux at Fznom')
        PDX2                    = magicformula.v62.ParameterFittable(-0.01, -1, 0, 'Variation of friction Mux with load')
        PDX3                    = magicformula.v62.ParameterFittable(10, 0, 15, 'Variation of friction Mux with camber')
        PEX1                    = magicformula.v62.ParameterFittable(-1, -100, 0, 'Longitudinal curvature Efx at Fznom')
        PEX2                    = magicformula.v62.ParameterFittable(0.3, -3, 3, 'Variation of curvature Efx with load')
        PEX3                    = magicformula.v62.ParameterFittable(0, -0.6, 0.6, 'Variation of curvature Efx with load squared', true)
        PEX4                    = magicformula.v62.ParameterFittable(0, -0.9, 0.9, 'Factor in curvature Efx while driving', true)
        PKX1                    = magicformula.v62.ParameterFittable(20, 5, 100, 'Longitudinal slip stiffness Kfx/Fz at Fznom')
        PKX2                    = magicformula.v62.ParameterFittable(10, -30, 30, 'Variation of slip stiffness Kfx/Fz with load')
        PKX3                    = magicformula.v62.ParameterFittable(0, -10, 10, 'Exponent in slip stiffness Kfx/Fz with load')
        PHX1                    = magicformula.v62.ParameterFittable(0, -0.1, 0.1, 'Horizontal shift Shx at Fznom')
        PHX2                    = magicformula.v62.ParameterFittable(0, -0.1, 0.1, 'Variation of shift Shx with load')
        PVX1                    = magicformula.v62.ParameterFittable(0, -0.1, 0.1, 'Vertical shift Svx/Fz at Fznom')
        PVX2                    = magicformula.v62.ParameterFittable(0, -0.1, 0.1, 'Variation of shift Svx/Fz with load')
        RBX1                    = magicformula.v62.ParameterFittable(5, 5, 50, 'Slope factor f or combined slip Fx reduction')
        RBX2                    = magicformula.v62.ParameterFittable(5, 5, 50, 'Variation of slope Fx reduction with kappa')
        RBX3                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Influence of camber on stiffness for Fx combined')
        RCX1                    = magicformula.v62.ParameterFittable(1, -1, 1.2, 'Shape factor for combined slip Fx reduction')
        REX1                    = magicformula.v62.ParameterFittable(-1, -10, 1, 'Curvature factor of combined Fx')
        REX2                    = magicformula.v62.ParameterFittable(-0.1, -5, 1, 'Curvature factor of combined Fx with load')
        RHX1                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Shift factor for combined slip Fx reduction')
        PPX1                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Linear pressure effect on slip stiffness')
        PPX2                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Quadratic pressure effect on slip stiffness')
        PPX3                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Linear pressure effect on longitudinal friction')
        PPX4                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Quadratic pressure effect on longitudinal friction')
        PTX1                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Relaxation length SigKap0/Fz at Fznom')
        PTX2                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of SigKap0/Fz with load')
        PTX3                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of SigKap0/Fz with exponent of load')
        %% [OVERTURNING_COEFFICIENTS]
        QSX1                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Overturning moment offset')
        QSX2                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Camber induced overturning couple')
        QSX3                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Fy induced overturning couple')
        QSX4                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Mixed load, lateral force and camber on Mx')
        QSX5                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Load effect on Mx with lateral force and camber')
        QSX6                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'B-factor of load with Mx')
        QSX7                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Camber with load on Mx')
        QSX8                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Lateral f orce with load on Mx')
        QSX9                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'B-factor of lateral f orce with load on Mx')
        QSX10                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Vertical force with camber on Mx')
        QSX11                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'B-factor of vertical force with camber on Mx')
        QSX12                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Camber squared induced overturning moment')
        QSX13                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Lateral force induced overturning moment')
        QSX14                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Lateral force induced overturning moment with camber')
        PPMX1                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Influence of inflation pressure on overturning moment')
        %% [LATERAL_COEFFICIENTS]
        PCY1                    = magicformula.v62.ParameterFittable(1.9, 1.5, 2, 'Shape factor Cfy for lateral forces')
        PDY1                    = magicformula.v62.ParameterFittable(0.8, 0.1, 5, 'Lateral friction Muy')
        PDY2                    = magicformula.v62.ParameterFittable(-0.05, -0.5, 0, 'Variation of friction Muy with load')
        PDY3                    = magicformula.v62.ParameterFittable(0, -10, 10, 'Variation of friction Muy with squared camber')
        PEY1                    = magicformula.v62.ParameterFittable(-0.8, -100, 100, 'Lateral curvature Efy at Fznom ')
        PEY2                    = magicformula.v62.ParameterFittable(-0.6, -100, 100, 'Variation of curvature Efy with load')
        PEY3                    = magicformula.v62.ParameterFittable(0.1, -inf, inf, 'Zero order camber dependency of curvature Efy')
        PEY4                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of curvature Efy with camber')
        PEY5                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Camber curvature Efc')
        PKY1                    = magicformula.v62.ParameterFittable(-20, -100, -5, 'Maximum value of stiffness Kfy/Fznom')
        PKY2                    = magicformula.v62.ParameterFittable(2, -5, 5, 'Load at which Kfy reaches maximum value')
        PKY3                    = magicformula.v62.ParameterFittable(0, -1, 1, 'Variation of Kfy/Fznom with camber')
        PKY4                    = magicformula.v62.ParameterFittable(2, 1.05, 2, 'Curvature of stiffness Kfy', true)
        PKY5                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Peak stiffness variation with camber squared')
        PKY6                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Camber stiffness factor')
        PKY7                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Load dependency of camber stiffness factor')
        PHY1                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Horizontal shift Shy at Fznom')
        PHY2                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of shift Shy with load')
        PVY1                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Vertical shift in Svy/Fz at Fznom')
        PVY2                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of shift Svy/Fz with load')
        PVY3                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of shift Svy/Fz with camber')
        PVY4                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of shift Svy/Fz with camber and load')
        RBY1                    = magicformula.v62.ParameterFittable(5, 2, 40, 'Slope factor for combined Fy reduction')
        RBY2                    = magicformula.v62.ParameterFittable(2, 2, 40, 'Variation of slope Fy reduction with alpha')
        RBY3                    = magicformula.v62.ParameterFittable(0.02, -0.15, 0.15, 'Shift term for alpha in slope Fy reduction')
        RBY4                    = magicformula.v62.ParameterFittable(0, -90, 90, 'Influence of camber on stiffness of Fy combined')
        RCY1                    = magicformula.v62.ParameterFittable(1, 0.8, 2, 'Shape factor for combined Fy reduction')
        REY1                    = magicformula.v62.ParameterFittable(-0.1, -6, 1, 'Curvature factor of combined Fy')
        REY2                    = magicformula.v62.ParameterFittable(0.1, -1, 5, 'Curvature factor of combined Fy with load')
        RHY1                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Shift factor for combined Fy reduction')
        RHY2                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Shift factor for combined Fy reduction with load')
        RVY1                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Kappa induced side force Svyk/Muy*Fz at Fznom')
        RVY2                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of Svyk/Muy*Fz with load')
        RVY3                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of Svyk/Muy*Fz with camber')
        RVY4                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of Svyk/Muy*Fz with alpha')
        RVY5                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of Svyk/Muy*Fz with kappa')
        RVY6                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of Svyk/Muy*Fz with atan(kappa)')
        PPY1                    = magicformula.v62.ParameterFittable(0.1, -2, 2, 'Pressure effect on cornering stiffness magnitude')
        PPY2                    = magicformula.v62.ParameterFittable(0.1, -2, 2, 'Pressure effect on location cornering stiffness peak')
        PPY3                    = magicformula.v62.ParameterFittable(0, -2, 1, 'Linear pressure effect on lateral friction')
        PPY4                    = magicformula.v62.ParameterFittable(0, -2, 1, 'Linear pressure effect on lateral friction')
        PPY5                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Quadratic pressure effect on lateral friction')
        PHY3                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Influence of inflation pressure on camber stiffness')
        PTY1                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Peak value of relaxation length SigAlp0/R0')
        PTY2                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Value of Fz/Fznom where SigAlp0 is extreme')
        %% [ROLLING_COEFFICIENTS]
        QSY1                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Rolling resistance torque coefficient')
        QSY2                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Rolling resistance torque depending on Fx')
        QSY3                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Rolling resistance torque depending on speed')
        QSY4                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Rolling resistance torque depending on speed ^4')
        QSY5                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Rolling resistance torque depending on camber squared')
        QSY6                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Rolling resistance torque depending on load and camber squared')
        QSY7                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Rolling resistance torque coefficient load dependency')
        QSY8                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Rolling resistance torque coefficient pressure dependency')
        %% [ALIGNING_COEFFICIENTS]
        QBZ1                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Trail slope factor for trail Bpt at Fznom')
        QBZ2                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of slope Bpt with load')
        QBZ3                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of slope Bpt with load squared')
        QBZ4                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of slope Bpt with camber')
        QBZ5                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of slope Bpt with absolute camber')
        QBZ9                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Slope factor Br of residual torque Mzr')
        QBZ10                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Slope factor Br of residual torque Mzr')
        QCZ1                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Shape factor Cpt for pneumatic trail')
        QDZ1                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Peak trail Dpt"=Dpt*(Fz/Fznom*R0)')
        QDZ2                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of peak Dpt with load')
        QDZ3                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of peak Dpt with camber')
        QDZ4                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of peak Dpt with camber squared')
        QDZ6                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Peak residual torque Dmr=Dmr/(Fz*R0)')
        QDZ7                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of peak factor Dmr with load')
        QDZ8                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of peak factor Dmr with camber')
        QDZ9                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of peak factor Dmr with camber and load')
        QDZ10                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of peak factor Dmr with camber squared ')
        QDZ11                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of Dmr with camber squared and load')
        QEZ1                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Trail curvature Ept at Fznom')
        QEZ2                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of curvature Ept with load ')
        QEZ3                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of curvature Ept with load squared')
        QEZ4                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of curvature Ept with sign of Alpha-t')
        QEZ5                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of Ept with camber and sign Alpha-t')
        QHZ1                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Trail horizontal shift Sht at Fznom')
        QHZ2                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of shift Sht with load')
        QHZ3                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of shift Sht with camber')
        QHZ4                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of shift Sht with camber and load')
        SSZ1                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Nominal value of s/R0: effect of Fx on Mz')
        SSZ2                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of distance s/R0 with Fy/Fznom')
        SSZ3                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of distance s/R0 with camber')
        SSZ4                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Variation of distance s/R0 with load and camber')
        PPZ1                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Linear pressure effect on pneumatic trail')
        PPZ2                    = magicformula.v62.ParameterFittable(0, -inf, inf, 'Influence of inflation pressure on residual aligning torque')
        %% [TURNSLIP_COEFFICIENTS]
        PDXP1                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Peak Fx reduction due to spin parameter')
        PDXP2                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Peak Fx reduction due to spin with varying load parameter')
        PDXP3                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Peak Fx reduction due to spin with kappa parameter')
        PKYP1                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Cornering stiffness reduction due to spin')
        PDYP1                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Peak Fy reduction due to spin parameter')
        PDYP2                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Peak Fy reduction due to spin with varying load parameter')
        PDYP3                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Peak Fy reduction due to spin with alpha parameter')
        PDYP4                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Peak Fy reduction due to square root of spin parameter')
        PHYP1                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Fy-alpha curve lateral shift limitation')
        PHYP2                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Fy-alpha curve maximum lateral shift parameter')
        PHYP3                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Fy-alpha curve maximum lateral shift varying with load parameter')
        PHYP4                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Fy-alpha curve maximum lateral shift parameter')
        PECP1                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Camber w.r.t. spin reduction factor parameter in camber stiffness')
        PECP2                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Camber w.r.t. spin reduction factor varying with load parameter in camber stiffness')
        QDTP1                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Pneumatic trail reduction factor due to turn slip parameter')
        QCRP1                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Turning moment at constant turning and zero forward speed parameter')
        QCRP2                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Turn slip moment (at alpha=90deg) parameter f or increase with spin')
        QBRP1                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Residual (spin) torque reduction factor parameter due to side slip')
        QDRP1                   = magicformula.v62.ParameterFittable(0, -inf, inf, 'Turn slip moment peak magnitude parameter')
        %% [ZETA_FACTORS] (temporarily set to unity to ignore Turn Slip); see Pacejka book page 178 for more information)
        ZETA0                   = magicformula.v62.ParameterFittable(1, -inf, inf, "Factor for the extension of the model for turn slip. See Pacejka's book chapter 4.3.3")
        ZETA1                   = magicformula.v62.ParameterFittable(1, -inf, inf, "Factor for the extension of the model for turn slip. See Pacejka's book chapter 4.3.3")
        ZETA2                   = magicformula.v62.ParameterFittable(1, -inf, inf, "Factor for the extension of the model for turn slip. See Pacejka's book chapter 4.3.3")
        ZETA3                   = magicformula.v62.ParameterFittable(1, -inf, inf, "Factor for the extension of the model for turn slip. See Pacejka's book chapter 4.3.3")
        ZETA4                   = magicformula.v62.ParameterFittable(1, -inf, inf, "Factor for the extension of the model for turn slip. See Pacejka's book chapter 4.3.3")
        ZETA5                   = magicformula.v62.ParameterFittable(1, -inf, inf, "Factor for the extension of the model for turn slip. See Pacejka's book chapter 4.3.3")
        ZETA6                   = magicformula.v62.ParameterFittable(1, -inf, inf, "Factor for the extension of the model for turn slip. See Pacejka's book chapter 4.3.3")
        ZETA7                   = magicformula.v62.ParameterFittable(1, -inf, inf, "Factor for the extension of the model for turn slip. See Pacejka's book chapter 4.3.3")
        ZETA8                   = magicformula.v62.ParameterFittable(1, -inf, inf, "Factor for the extension of the model for turn slip. See Pacejka's book chapter 4.3.3")
    end
    % properties % TNO Road Definition
    %     %% [UNITS]
    %     % LENGTH                  = magicformula.v62.Parameter()
    %     % FORCE                   = magicformula.v62.Parameter()
    %     % ANGLE                   = magicformula.v62.Parameter()
    %     % MASS1                   = magicformula.v62.Parameter()
    %     % TIME                    = magicformula.v62.Parameter()
    %     %% [MODEL]
    %     % ...
    % end
    % properties % ADAMS
    %     FUNCTION_NAME           = magicformula.v62.Parameter('TNO_DelftTyre_Adams_interface::TYR815')
    %     % USER_SUB_ID             = magicformula.v62.Parameter(815) % obsolete
    %     N_TIRE_STATES           = magicformula.v62.Parameter(5)
    %     FILE_FORMAT             = magicformula.v62.Parameter()
    %     FILE_TYPE               = magicformula.v62.Parameter()
    %     FILE_VERSION            = magicformula.v62.Parameter()
    %     SWITCH_INTEG            = magicformula.v62.Parameter('default')
    %     TIME_SWITCH_INTEG       = magicformula.v62.Parameter()
    %     PROPERTY_FILE_FORMAT    = magicformula.v62.Parameter()
    %     USE_MODE                = magicformula.v62.Parameter()
    %     HMAX_LOCAL              = magicformula.v62.Parameter()
    % end
    methods
        function tf = eq(params1, params2)
            tf = true;
            
            n1 = numel(params1);
            n2 = numel(params2);
            
            if n1 ~= n2
                tf = false;
                return
            end
            
            mc = ?magicformula.v62.Parameters;
            names = {mc.PropertyList.Name};
            for i = 1:n1
                name = names{i};
                try
                    param1 = params1.(name);
                    param2 = params2.(name);
                    value1 = param1.Value;
                    value2 = param2.Value;
                    if value1 ~= value2
                        tf = false;
                        return
                    end
                catch
                    tf = false;
                    return
                end
            end
        end
        function tf = ne(params1, params2)
            tf = eq(params1, params2);
            tf = ~tf;
        end
        function p = struct(params)
            paramNames = fieldnames(params);
            p = struct;
            for i = 1:length(paramNames)
                name = paramNames{i};
                value = params.(name).Value;
                if strcmp(name, 'TYRESIDE') && ischar(value)
                    value = strcmpi(value, 'RIGHT');
                end
                p.(name) = value;
            end
        end
        function [x,lb,ub] = convert2fittable(params,fitmode)
            arguments
                params magicformula.v62.Parameters
                fitmode magicformula.v62.FitMode
            end
            import('magicformula.v62.FitMode')
            import('magicformula.v62.getFitParamNames')
            fn = fieldnames(params);
            fitparams = getFitParamNames(fitmode);
            allParamsExist = numel(intersect(fn,fitparams)) == numel(fitparams);
            assert(allParamsExist)
            x  = zeros(length(fitparams),1);
            lb = zeros(length(fitparams),1);
            ub = zeros(length(fitparams),1);
            for i=1:numel(fitparams)
                x(i)  = params.(fitparams{i}).Value;
                if params.(fitparams{i}).Fixed
                    lb(i) = params.(fitparams{i}).Value;
                    ub(i) = params.(fitparams{i}).Value;
                else
                    lb(i) = params.(fitparams{i}).Min;
                    ub(i) = params.(fitparams{i}).Max;
                end
            end
        end
        function params = appendFitted(params,x,fitmode)
            arguments
                params magicformula.v62.Parameters
                x double
                fitmode magicformula.v62.FitMode
            end
            import('magicformula.v62.FitMode')
            import('magicformula.v62.getFitParamNames')
            fitparams = getFitParamNames(fitmode);
            for i=1:numel(fitparams)
                params.(fitparams{i}).Value = x(i);
            end
        end
    end
end

