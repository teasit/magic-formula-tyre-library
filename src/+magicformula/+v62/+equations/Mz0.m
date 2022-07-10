function [Mz0,Bt,Ct,Et] = Mz0(p,slipangl,inclangl,pressure,Fz)
% Todo: implement this:
sgnVcx = 1;

% (4.E4)
inclangl = sin(inclangl);
inclangl2 = inclangl.^2;
inclanglAbs = abs(inclangl);

[Fy0,~,Fz0,dfz,dpi,By,Cy,~,~,Kya,SVy,SHy] = ...
    magicformula.v62.equations.Fy0(p,slipangl,0,pressure,Fz);
dfz2 = dfz.^2;
R0 = p.UNLOADED_RADIUS;

% (4.E6)
% todo: implement correctly
cosalpha = cos(slipangl);

% (4.E38), (4.E39)
SHf = SHy + SVy./(Kya+eps);

% (4.E35)
SHt = p.QHZ1 + p.QHZ2.*dfz + (p.QHZ3 + p.QHZ4.*dfz).*inclangl;

% (4.E34)
% Todo: add a_asterisk
alphat = slipangl + SHt;

% (4.E37)
% Todo add a_asterisk
alphar = slipangl + SHf;

% (4.E42)
Dt0 = Fz.*(R0./Fz0).*(p.QDZ1+p.QDZ2.*dfz).*(1-p.PPZ1.*dpi).*p.LTR*sgnVcx;

% (4.E40)
% Todo: add asterisk version of LMUY
% Note: QBZ4 added although not included in Pacejka's 2012 book.
% Note: QBZ6 eliminated because not included in 6.1.2 manual.
Bt = (p.QBZ1+p.QBZ2.*dfz+p.QBZ3.*dfz2)...
    .*(1+p.QBZ4.*inclangl+p.QBZ5.*inclanglAbs)...
    .*p.LKY./p.LMUY;

% (4.E41)
Ct = p.QCZ1;

% (4.E43)
Dt = Dt0.*(1+p.QDZ3.*inclanglAbs+p.QDZ4.*inclangl2).*p.ZETA5;

% (4.E44)
Et = (p.QEZ1+p.QEZ2.*dfz+p.QEZ3.*dfz2)...
    .*(1+(p.QEZ4+p.QEZ5.*inclangl).*(2/pi).*atan(Bt.*Ct.*alphat));

% (4.E45)
% todo: add (4.E7) for LMUY
Br = (p.QBZ9.*p.LKY./p.LMUY+p.QBZ10.*By.*Cy).*p.ZETA6;

% (4.E46)
Cr = p.ZETA7;

% (4.E47)
% Todo: add asterisk version of LMUY
Dr = Fz.*R0.*((p.QDZ6+p.QDZ7.*dfz).*p.LRES.*p.ZETA2...
    +((p.QDZ8+p.QDZ9.*dfz).*(1+p.PPZ2.*dpi)...
    +(p.QDZ10+p.QDZ11.*dfz).*inclanglAbs).*inclangl.*p.LKZC.*p.ZETA0)...
    .*p.LMUY.*sgnVcx.*cosalpha + p.ZETA8 - 1;

% (4.E33)
t0 = Dt.*cos(Ct.*atan(Bt.*alphat-Et.*(Bt.*alphat-atan(Bt.*alphat)))).*cosalpha;

% (4.E32)
Mz0_ = -t0.*Fy0;

% (4.E36)
Mzr0 = Dr.*cos(Cr.*atan(Br.*alphar)).*cosalpha;

% (4.E31)
Mz0 = Mz0_ + Mzr0;
end

