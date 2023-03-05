function [Fx,mux,Gxa,Bxa,Exa] = Fx(p,longslip,slipangl,Fz,pressure,inclangl,Vcx)
%MAGICFORMULA.V61.FX
[Fx0,mux,~,~,~,dfz] = magicformula.v61.Fx0(p,longslip,Fz,pressure,inclangl);

% (4.E3)
sgnVcx = sign(Vcx);
sgnVcx(sgnVcx == 0) = 1;
alphaAst = tan(slipangl).*sgnVcx;

% (4.E4)
gammaAst = sin(inclangl);

% (4.E55)
Cxa = p.RCX1;

% (4.E56)
Exa = p.REX1 + p.REX2.*dfz;

% (4.E57)
SHxa = p.RHX1;

% (4.E53)
alphaS = alphaAst + SHxa;

% (4.E54)
Bxa = p.LXAL*(p.RBX1+p.RBX3*gammaAst.^2).*cos(atan(p.RBX2.*longslip));

% (4.E52)
Gxa0 = cos(Cxa.*atan(Bxa.*SHxa-Exa.*(Bxa.*SHxa-atan(Bxa.*SHxa))));

% (4.E51)
Gxa = cos(Cxa.*atan(Bxa.*alphaS-Exa.*(Bxa.*alphaS-atan(Bxa.*alphaS))))./Gxa0;

% (4.E50)
Fx = Gxa.*Fx0;
