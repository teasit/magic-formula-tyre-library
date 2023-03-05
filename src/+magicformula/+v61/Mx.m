function Mx = Mx(p,Fz,pressure,inclangl,Fy)
%MAGICFORMULA.V61.MX
R0 = p.UNLOADED_RADIUS;
F0 = p.FNOMIN;
P0 = p.NOMPRES;

% (4.E2b)
dP = (pressure-P0)./P0;
ratioFy = Fy/F0;
ratioFz = Fz/F0;


% (4.E69)
Mx = R0.*Fz.*(...
    p.QSX1*p.LVMX - p.QSX2*inclangl.*(1+p.PPMX1*dP) + p.QSX3*ratioFy ...
    + p.QSX4*cos(p.QSX5*atan(p.QSX6*ratioFz).^2).*sin(p.QSX7*inclangl + p.QSX8*atan(...
    p.QSX9*ratioFy)) + p.QSX10*atan(p.QSX11*ratioFz).*inclangl)*p.LMX;
end
