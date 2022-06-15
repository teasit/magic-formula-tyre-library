function [Fx,mux,Gxa,Bxa,Exa] = Fx(p,slipangl,longslip,inclangl,pressure,Fz)
[Fx0,mux] = magicformula.v62.equations.Fx0(p,longslip,inclangl,pressure,Fz);

% (4.E1)
FNOMIN = p.FNOMIN.*p.LFZO;

% (4.E2a) 
dfz = (Fz-FNOMIN)./FNOMIN;

% (4.E4)
inclangl = sin(inclangl);

% (4.E55)
Cxa = p.RCX1;

% (4.E56)
Exa = p.REX1 + p.REX2.*dfz;

% (4.E57)
SHxa = p.RHX1;

% (4.E53)
slipangl = slipangl+SHxa;

% (4.E54)
Bxa = p.LXAL*(p.RBX1+p.RBX3*inclangl.^2).*cos(atan(p.RBX2.*longslip));

% (4.E52)
Gxa0 = cos(Cxa.*atan(Bxa.*SHxa-Exa.*(Bxa.*SHxa-atan(Bxa.*SHxa))));

% (4.E51)
Gxa = cos(Cxa.*atan(Bxa.*slipangl-Exa.*(Bxa.*slipangl-atan(Bxa.*slipangl))))./Gxa0;

% (4.E50)
Fx = Gxa.*Fx0;
