function kamm(tyre, options)
arguments
    tyre MagicFormulaTyre
    options.LimitsSX (1,2) = [-0.1 0.1]
    options.LimitsSA (1,2) = [-pi/8 pi/8]
    options.SweepLength {mustBeInteger} = 100
    options.NumConstant {mustBeInteger} = 25
end

limits = options.LimitsSX;
stepsz = diff(limits)/options.NumConstant;
SX_sweep = linspace(limits(1), limits(2));
SX_const = limits(1):stepsz:limits(2);

limits = options.LimitsSA;
stepsz = diff(limits)/options.NumConstant;
SA_sweep = linspace(limits(1), limits(2));
SA_const = limits(1):stepsz:limits(2);

for i = 1:numel(SA_const)
    [FX,FY] = magicformula(tyre,SX_sweep,SA_const(i));
    plot(FY, FX, 'k-')
end
for i = 1:numel(SX_const)
    [FX,FY] = magicformula(tyre,SX_const(i),SA_sweep);
    plot(FY, FX, 'k-')
end
axis equal
xlabel('FY / N'); ylabel('FX / N')
end
