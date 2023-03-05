function [Fx0,mux,Cx,Dx,Ex,dfz,Kxk] = Fx0(p,longslip,Fz,pressure,inclangl)
%MAGICFORMULA.V61.FX0
% TODO: implement for turnslip (ZETAs):
ZETA1 = 1;

% (4.E1, 4.E2a)
Fz0_ = p.FNOMIN.*p.LFZO;
dfz = (Fz-Fz0_)./Fz0_;

% (4.E2b) 
pi0 = p.NOMPRES;
dpi = (pressure-pi0)./pi0;

% (4.E11) 
Cx = p.PCX1.*p.LCX;

% (4.E13) 
% Note: Asterisk variant of LMUX is not used, because corresponding scaling
%       factor is not defined in 6.1.2 manual.
mux = p.LMUX.*(p.PDX1+p.PDX2.*dfz).*(1+p.PPX3.*dpi+p.PPX4.*dpi.^2).*(1-p.PDX3.*inclangl.^2);

% (4.E12) 
Dx = mux.*Fz*ZETA1;

% (4.E17) 
SHx = p.LHX.*(p.PHX1+p.PHX2.*dfz);

% (4.E8)
% Note: Asterisk variant of LMUX is not used, because corresponding scaling
%       factor is not defined in 6.1.2 manual.
AMU = 10;
LMUX_ = AMU.*p.LMUX./(1+(AMU-1).*p.LMUX);

% (4.E18)
SVx = ZETA1*LMUX_.*p.LVX.*Fz.*(p.PVX1+p.PVX2.*dfz);

% (4.E10) 
kappax = longslip + SHx;
kappaxSgn = sign(kappax);

% (4.E14) 
Ex = p.LEX.*(p.PEX1+p.PEX2.*dfz+p.PEX3.*dfz.^2).*(1-p.PEX4.*kappaxSgn);

% (4.E15)
Kxk = p.LKX.*Fz.*(p.PKX1+p.PKX2.*dfz).*exp(p.PKX3.*dfz).*(1+p.PPX1.*dpi+p.PPX2.*dpi.^2);

% (4.E16) 
Bx = Kxk./(Cx.*Dx+eps(Kxk));

% (4.E9)
Fx0 = Dx.*sin(Cx.*atan(Bx.*kappax-Ex.*(Bx.*kappax-atan(Bx.*kappax))))+SVx;