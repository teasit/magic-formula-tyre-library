function compareMzFy(tyre, measurements)
arguments
    tyre MagicFormulaTyre
    measurements tydex.Measurement
end
c = colororder();
for i = 1:numel(measurements)
    measurement = measurements(i);
    [SX,SA,FZ,IP,IA,VX,~,FY,MZ] = unpack(measurement);
    [~,~,MZ_mdl] = magicformula(tyre,SX,SA,FZ,IP,IA,VX);
    plot(FY, MZ, '.', 'Color', c(i,:), 'MarkerSize', 3)
    plot(FY, MZ_mdl, '-', 'LineWidth', 2, 'Color', c(i,:))
end
ylabel('MZ / N*m')
xlabel('FY / N')
end
