function compareMzSA(tyre, measurements)
arguments
    tyre MagicFormulaTyre
    measurements tydex.Measurement
end
c = colororder();
r2d = @rad2deg;
for i = 1:numel(measurements)
    measurement = measurements(i);
    [SX,SA,FZ,IP,IA,VX,~,~,MZ] = unpack(measurement);
    [~,~,MZ_mdl] = magicformula(tyre,SX,SA,FZ,IP,IA,VX);
    plot(r2d(SA), MZ, '.', 'Color', c(i,:), 'MarkerSize', 3)
    plot(r2d(SA), MZ_mdl, '-', 'LineWidth', 2, 'Color', c(i,:))
end
ylabel('MZ / N*m')
xlabel('SA / deg')
end
