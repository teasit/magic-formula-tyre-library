function [Fy0,muy,dfz,Cy,Ey,Dy] = Fy0(p,slipangl,inclangl,pressure,Fz)
% (4.E4)
inclangl = sin(inclangl);

% (4.E1)
FNOMIN = p.FNOMIN.*p.LFZO;

% (4.E2a) 
dfz = (Fz-FNOMIN)./FNOMIN;

% (4.E2b) 
dpi = (pressure-p.NOMPRES)./p.NOMPRES;

% (4.E21) 
Cy = p.LCY.*p.PCY1;

% (4.E23) 
muy = p.LMUY.*(p.PDY1+p.PDY2.*dfz).*(1+p.PPY3.*dpi+p.PPY4.*dpi.^2).*(1-p.PDY3.*inclangl.^2);

% (4.E22) 
Dy = muy.*Fz*p.ZETA2;

% (4.E25)
% TODO: add correct LAMBDA (scaling factor)
Kya = p.ZETA3*p.PKY1.*FNOMIN.*(1+p.PPY1.*dpi).*(1-p.PKY3.*abs(inclangl)).*sin(p.PKY4.*atan(Fz./FNOMIN./((p.PKY2+p.PKY5.*inclangl.^2).*(1+p.PPY2.*dpi))));

% (4.E28)
% TODO: add correct LAMBDA (scaling factor)
SVyg = p.ZETA2*p.LMUY.*Fz.*(p.PVY3+p.PVY4.*dfz).*inclangl;

% (4.E30)
% TODO: add missing LAMBDA (scaling factor)
Kyg0 = Fz.*(p.PKY6+p.PKY7.*dfz).*(1+p.PKY5.*dpi);

% (4.E29) 
SVy = p.ZETA2*p.LMUY.*p.LVY.*Fz.*(p.PVY1+p.PVY2.*dfz)+SVyg;

% (4.E27)
SHy = p.LHY.*(p.PHY1+p.PHY2.*dfz)+(Kyg0.*inclangl-SVyg)./(Kya+eps)*p.ZETA0+p.ZETA4-1;

% (4.E20) 
slipangl = slipangl+SHy;

% (4.E24) 
Ey = p.LEY.*(p.PEY1+p.PEY2.*dfz).*(1+p.PEY5.*inclangl.^2-(p.PEY3+p.PEY4.*inclangl).*sign(slipangl));

% (4.E26) 
By = Kya./(Cy.*Dy+eps);

% (4.E19)
Fy0 = Dy.*sin(Cy.*atan(By.*slipangl-Ey.*(By.*slipangl-atan(By.*slipangl))))+SVy;