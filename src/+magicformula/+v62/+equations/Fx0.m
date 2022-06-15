function [Fx0,mux,Cx,Dx,Ex] = Fx0(p,longslip,inclangl,pressure,Fz)
% (4.E1)
FNOMIN = p.FNOMIN.*p.LFZO;

% (4.E2a) 
dfz = (Fz-FNOMIN)./FNOMIN;

% (4.E2b) 
dpi = (pressure-p.NOMPRES)./p.NOMPRES;

% (4.E11) 
Cx = p.PCX1.*p.LCX;

% (4.E13) 
mux = p.LMUX.*(p.PDX1+p.PDX2.*dfz).*(1+p.PPX3.*dpi+p.PPX4.*dpi.^2).*(1-p.PDX3.*inclangl.^2);

% (4.E12) 
Dx = mux.*Fz*p.ZETA1;

% (4.E17) 
SHx = p.LHX.*(p.PHX1+p.PHX2.*dfz);

% (4.E18) 
% TODO: add correct LAMBDA (scaling factor) using equations 4.E7 and 4.E8
SVx = p.ZETA1*p.LMUX.*p.LVX.*Fz.*(p.PVX1+p.PVX2.*dfz);

% (4.E10) 
longslip = longslip+SHx;

% (4.E14) 
Ex = p.LEX.*(p.PEX1+p.PEX2.*dfz+p.PEX3.*dfz.^2).*(1-p.PEX4.*sign(longslip));

% (4.E15)
% TODO: add correct LAMBDA (scaling factor)
Kxk = Fz.*(p.PKX1+p.PKX2.*dfz).*exp(p.PKX3.*dfz).*(1+p.PPX1.*dpi+p.PPX2.*dpi.^2);

% (4.E16) 
Bx = Kxk./(Cx.*Dx+eps);

% (4.E9)
Fx0 = Dx.*sin(Cx.*atan(Bx.*longslip-Ex.*(Bx.*longslip-atan(Bx.*longslip))))+SVx;