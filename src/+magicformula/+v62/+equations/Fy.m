function [Fy,muy,Gyk,Byk,Eyk] = Fy(p,slipangl,longslip,inclangl,pressure,Fz)
[Fy0,muy,dfz] = magicformula.v62.equations.Fy0(p,slipangl,inclangl,pressure,Fz);

% (4.E4)
camberspin = sin(inclangl);

% (4.E3) % TODO: FIX
latslip = slipangl;

% (4.E62)
Byk = p.LYKA.*(p.RBY1+p.RBY4*camberspin.^2).*cos(atan(p.RBY2.*(latslip-p.RBY3)));

% (4.E63)
Cyk = p.RCY1;

% (4.E67)
DVyk = p.ZETA2*muy.*Fz.*(p.RVY1+p.RVY2.*dfz+p.RVY3*camberspin).*cos(atan(p.RVY4.*latslip));

% (4.E64)
Eyk = p.REY1+p.REY2.*dfz;

% (4.E65)
SHyk = p.RHY1+p.RHY2.*dfz;

% (4.E66)
SVyk = p.LVYKA.*DVyk.*sin(p.RVY5.*atan(p.RVY6.*longslip));

% (4.E61)
longslip_shift = longslip+SHyk;

% (4.E60)
Gyk0 = cos(Cyk.*atan(Byk.*SHyk-Eyk.*(Byk.*SHyk-atan(Byk.*SHyk))));

% (4.E59)
Gyk = cos(Cyk.*atan(Byk.*longslip_shift-Eyk.*(Byk.*longslip_shift-atan(Byk.*longslip_shift))))./Gyk0;

% (4.E58)
Fy = Gyk.*Fy0+SVyk;