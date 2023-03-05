function My = My(p,Fz,pressure,inclangl,Vcx,Fx)
%MAGICFORMULA.V61.MY
R0 = p.UNLOADED_RADIUS;
F0 = p.FNOMIN;
V0 = p.LONGVL;
P0 = p.NOMPRES;

ratioP = pressure/P0;
ratioFz = Fz/F0;
ratioV = Vcx/V0;
ratioVAbs = abs(ratioV);
ratioV4 = ratioV.^4;

% (4.E70)
% NOTE: Sign was altered to output negative My when rolling forward.
My = Fz.*R0.*(...
    p.QSY1 + p.QSY2*Fx./F0 + p.QSY3*ratioVAbs + p.QSY4*ratioV4 + ...
    (p.QSY5 + p.QSY6*ratioFz).*inclangl.^2) ...
    .*(ratioFz^p.QSY7 .* ratioP^p.QSY8)*p.LMY;
My = -My;
end

