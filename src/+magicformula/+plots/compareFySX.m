function compareFySX(tyre, measurements)
arguments
    tyre MagicFormulaTyre
    measurements tydex.Measurement
end
c = colororder();
for i = 1:numel(measurements)
    measurement = measurements(i);
    [SX,SA,FZ,IP,IA,VX,~,FY] = unpack(measurement);
    [~,FY_mdl] = magicformula(tyre,SX,SA,FZ,IP,IA,VX);
    plot(SX, FY, '.', 'Color', c(i,:), 'MarkerSize', 3)
    plot(SX, FY_mdl, '-', 'LineWidth', 2, 'Color', c(i,:))
end
ylabel('FY / N')
xlabel('SX / 1')
end
