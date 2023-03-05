function compareMxFy(tyre, measurements)
arguments
    tyre MagicFormulaTyre
    measurements tydex.Measurement
end
c = colororder();
for i = 1:numel(measurements)
    measurement = measurements(i);
    [SX,SA,FZ,IP,IA,VX,~,FY,~,~,MX] = unpack(measurement);
    [~,~,~,~,MX_mdl] = magicformula(tyre,SX,SA,FZ,IP,IA,VX);
    plot(FY, MX, '.', 'Color', c(i,:), 'MarkerSize', 3)
    plot(FY, MX_mdl, '-', 'LineWidth', 2, 'Color', c(i,:))
end
ylabel('MX / N*m')
xlabel('FY / N')
end
