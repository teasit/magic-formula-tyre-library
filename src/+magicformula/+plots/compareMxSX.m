function compareMxSX(tyre, measurements)
arguments
    tyre MagicFormulaTyre
    measurements tydex.Measurement
end
c = colororder();
for i = 1:numel(measurements)
    measurement = measurements(i);
    [SX,SA,FZ,IP,IA,VX,~,~,~,~,MX] = unpack(measurement);
    [~,~,~,~,MX_mdl] = magicformula(tyre,SX,SA,FZ,IP,IA,VX);
    plot(SX, MX, '.', 'Color', c(i,:), 'MarkerSize', 3)
    plot(SX, MX_mdl, '-', 'LineWidth', 2, 'Color', c(i,:))
end
ylabel('MX / N*m')
xlabel('SX / 1')
end
