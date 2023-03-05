function compareFxSX(tyre, measurements)
arguments
    tyre MagicFormulaTyre
    measurements tydex.Measurement
end
c = colororder();
for i = 1:numel(measurements)
    measurement = measurements(i);
    [SX,SA,FZ,IP,IA,VX,FX] = unpack(measurement);
    FX_mdl = magicformula(tyre,SX,SA,FZ,IP,IA,VX);
    plot(SX, FX, '.', 'Color', c(i,:), 'MarkerSize', 3)
    plot(SX, FX_mdl, '-', 'LineWidth', 2, 'Color', c(i,:))
end
ylabel('FX / N')
xlabel('SX / 1')
end
