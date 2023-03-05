function compareFySA(tyre, measurements)
arguments
    tyre MagicFormulaTyre
    measurements tydex.Measurement
end
c = colororder();
r2d = @rad2deg;
ctrColor = 1;
for i = 1:numel(measurements)
    if ctrColor > size(c,1)
        ctrColor = 1;
    end
    measurement = measurements(i);
    [SX,SA,FZ,IP,IA,VX,~,FY] = unpack(measurement);
    [~,FY_mdl] = magicformula(tyre,SX,SA,FZ,IP,IA,VX);
    plot(r2d(SA), FY, '.', 'Color', c(ctrColor,:), 'MarkerSize', 3)
    plot(r2d(SA), FY_mdl, '-', 'LineWidth', 2, 'Color', c(ctrColor,:))
    ctrColor = ctrColor + 1;
end
ylabel('FY / N')
xlabel('SA / deg')
end

