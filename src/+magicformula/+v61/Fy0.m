function [Fy0,muy,dfz,Fz0_,dpi,By,Cy,Ey,Dy,Kya_,SVy,SHy] = Fy0(p,slipangl,Fz,pressure,inclangl)
%MAGICFORMULA.V61.FY0
% TODO: implement for turnslip (ZETAs):
ZETA0 = 1;
ZETA2 = 1;
ZETA3 = 1;
ZETA4 = 1;

% (4.E4)
gammaAst = sin(inclangl);
gammaAst2 = gammaAst.^2;

% (4.E1)
Fz0_ = p.FNOMIN.*p.LFZO;

% (4.E2a) 
dfz = (Fz-Fz0_)./Fz0_;

% (4.E2b) 
pi0 = p.NOMPRES;
dpi = (pressure-pi0)./pi0;
dpi2 = dpi.^2;

% (4.E21) 
Cy = p.LCY.*p.PCY1;

% (4.E23)
% Note: Asterisk variant of LMUX is not used, because corresponding scaling
%       factor is not defined in 6.1.2 manual.
muy = (p.PDY1+p.PDY2.*dfz).*(1+p.PPY3.*dpi+p.PPY4.*dpi2)...
    .*(1-p.PDY3.*gammaAst2).*p.LMUY;

% (4.E22) 
Dy = muy.*Fz.*ZETA2;

% (4.E25)
Kya = p.PKY1.*Fz0_...
    .*(1+p.PPY1.*dpi)...
    .*(1-p.PKY3.*abs(gammaAst))...
    .*sin(p.PKY4.*atan(Fz./Fz0_./((p.PKY2+p.PKY5.*gammaAst2)...
    .*(1+p.PPY2.*dpi)))).*p.LKY.*ZETA3;

% (4.E39); see also p.177 for explanation on eps/sign
signKya = sign(Kya);
signKya(~signKya) = 1;
Kya_ = Kya + eps(Kya).*signKya;

% (4.E28)
% Note: Asterisk variant of LMUX is not used, because corresponding scaling
%       factor is not defined in 6.1.2 manual.
SVyg = ZETA2.*p.LKYC.*p.LMUY.*Fz.*(p.PVY3+p.PVY4.*dfz).*gammaAst;

% (4.E30)
Kyg0 = Fz.*(p.PKY6+p.PKY7.*dfz).*(1+p.PPY5.*dpi).*p.LKYC;

% (4.E29)
% Note: Asterisk variant of LMUX is not used, because corresponding scaling
%       factor is not defined in 6.1.2 manual.
SVy = ZETA2.*p.LMUY.*p.LVY.*Fz.*(p.PVY1+p.PVY2.*dfz)+SVyg;

% (4.E27)
SHy = p.LHY.*(p.PHY1+p.PHY2.*dfz)+(Kyg0.*gammaAst-SVyg)./Kya_*ZETA0+ZETA4-1;

% (4.E20) 
alphay = slipangl+SHy;
alphaySgn = sign(slipangl);

% (4.E24) 
Ey = (p.PEY1+p.PEY2.*dfz)...
    .*(1+p.PEY5.*gammaAst.^2-(p.PEY3+p.PEY4.*gammaAst).*alphaySgn).*p.LEY;

% (4.E26); see also p.177 for explanation on eps/sign
signCy = sign(Cy);
signCy(~signCy) = 1;
By = Kya./(Cy.*Dy + eps(Cy).*signCy);

% (4.E19)
Fy0 = Dy.*sin(Cy.*atan(By.*alphay-Ey.*(By.*alphay-atan(By.*alphay))))+SVy;