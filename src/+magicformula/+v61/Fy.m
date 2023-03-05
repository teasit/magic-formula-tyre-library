function [Fy,muy,Gyk,Byk,Eyk,Fy0,gammaAst] = Fy(p,longslip,slipangl,Fz,pressure,inclangl,Vcx)
%MAGICFORMULA.V61.FY
% TODO: implement for turnslip (ZETAs):
ZETA2 = 1;

[Fy0,muy,dfz] = magicformula.v61.Fy0(p,slipangl,Fz,pressure,inclangl);

% (4.E4)
gammaAst = sin(inclangl);

% (4.E3)
sgnVcx = sign(Vcx);
alphaAst = tan(slipangl).*sgnVcx;

% (4.E62)
Byk = p.LYKA.*(p.RBY1+p.RBY4*gammaAst.^2).*cos(atan(p.RBY2.*(alphaAst-p.RBY3)));

% (4.E63)
Cyk = p.RCY1;

% (4.E67)
DVyk = ZETA2*muy.*Fz.*(p.RVY1+p.RVY2.*dfz+p.RVY3*gammaAst).*cos(atan(p.RVY4.*alphaAst));

% (4.E64)
Eyk = p.REY1+p.REY2.*dfz;

% (4.E65)
SHyk = p.RHY1+p.RHY2.*dfz;

% (4.E66)
SVyk = p.LVYKA.*DVyk.*sin(p.RVY5.*atan(p.RVY6.*longslip));

% (4.E61)
kappaS = longslip + SHyk;

% (4.E60)
Gyk0 = cos(Cyk.*atan(Byk.*SHyk-Eyk.*(Byk.*SHyk-atan(Byk.*SHyk))));

% (4.E59)
Gyk = cos(Cyk.*atan(Byk.*kappaS-Eyk.*(Byk.*kappaS-atan(Byk.*kappaS))))./Gyk0;

% (4.E58)
Fy = Gyk.*Fy0 + SVyk;