function compareFxFy(tyre, measurements)
arguments
    tyre MagicFormulaTyre
    measurements tydex.Measurement
end
c = colororder();
ctrColor = 1;
for i = 1:numel(measurements)
    if ctrColor > size(c,1)
        ctrColor = 1;
    end
    measurement = measurements(i);
    [SX,SA,FZ,IP,IA,VX,FX,FY] = unpack(measurement);
    [FX_mdl, FY_mdl] = magicformula(tyre,SX,SA,FZ,IP,IA,VX);
    plot(FX, FY, '.', 'Color', c(ctrColor,:), 'MarkerSize', 3)
    plot(FX_mdl, FY_mdl, '-', 'LineWidth', 2, 'Color', c(ctrColor,:))
    ctrColor = ctrColor + 1;
end
ylabel('FY / N')
xlabel('FX / N')
end
