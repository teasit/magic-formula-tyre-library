function compareMxSA(tyre, measurements)
arguments
    tyre MagicFormulaTyre
    measurements tydex.Measurement
end
c = colororder();
r2d = @rad2deg;
for i = 1:numel(measurements)
    measurement = measurements(i);
    [SX,SA,FZ,IP,IA,VX,~,~,~,~,MX] = unpack(measurement);
    [~,~,~,~,MX_mdl] = magicformula(tyre,SX,SA,FZ,IP,IA,VX);
    plot(r2d(SA), MX, '.', 'Color', c(i,:), 'MarkerSize', 3)
    plot(r2d(SA), MX_mdl, '-', 'LineWidth', 2, 'Color', c(i,:))
end
ylabel('MX / N*m')
xlabel('SA / deg')
end
