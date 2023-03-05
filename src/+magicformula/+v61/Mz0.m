function [Mz0,Bt,Ct,Dt,Et,Br,Cr,Dr,alphaCos,R0,alphar,alphat] = Mz0(p,slipangl,Fz,pressure,inclangl,Vcx)
%MAGICFORMULA.V61.MZ0
% TODO: implement for turnslip (ZETAs):
ZETA0 = 1;
ZETA2 = 1;
ZETA5 = 1;
ZETA6 = 1;
ZETA7 = 1;
ZETA8 = 1;

% (4.E3)
Vcy = -Vcx.*tan(slipangl);
sgnVcx = sign(Vcx);
alphaAst = tan(slipangl).*sgnVcx;

% (4.E6a)
Vc = sqrt(Vcx.^2 + Vcy.^2);
Vc = Vc + eps(Vc);

% (4.E6)
alphaCos = Vcx./Vc;

% (4.E4)
gammaAst = sin(inclangl);
gammaAst2 = gammaAst.^2;
gammaAstAbs = abs(gammaAst);

[Fy0,~,dfz,Fz0_,dpi,By,Cy,~,~,Kya_,SVy,SHy] = ...
    magicformula.v61.Fy0(p,slipangl,Fz,pressure,0);
dfz2 = dfz.^2;
R0 = p.UNLOADED_RADIUS;

% (4.E38), (4.E39)
SHf = SHy + SVy./Kya_;

% (4.E35)
SHt = p.QHZ1 + p.QHZ2.*dfz + (p.QHZ3 + p.QHZ4.*dfz).*gammaAst;

% (4.E34)
alphat = alphaAst + SHt;

% (4.E37)
alphar = alphaAst + SHf;

% (4.E42)
Dt0 = Fz.*(R0./Fz0_).*(p.QDZ1+p.QDZ2.*dfz).*(1-p.PPZ1.*dpi).*p.LTR.*sgnVcx;

% (4.E40)
% Note: QBZ4 added although not included in Pacejka's 2012 book.
% Note: QBZ6 eliminated because not included in 6.1.2 manual.
% Note: Asterisk variant of LMUY is not used, because corresponding scaling
%       factor is not defined in 6.1.2 manual.
Bt = (p.QBZ1+p.QBZ2.*dfz+p.QBZ3.*dfz2)...
    .*(1+p.QBZ4.*gammaAst+p.QBZ5.*gammaAstAbs)...
    .*p.LKY./p.LMUY;

% (4.E41)
Ct = p.QCZ1;

% (4.E43)
Dt = Dt0.*(1+p.QDZ3.*gammaAstAbs+p.QDZ4.*gammaAst2).*ZETA5;

% (4.E44)
Et = (p.QEZ1+p.QEZ2.*dfz+p.QEZ3.*dfz2)...
    .*(1+(p.QEZ4+p.QEZ5.*gammaAst).*(2/pi).*atan(Bt.*Ct.*alphat));

% (4.E45)
% Note: Asterisk variant of LMUY is not used, because corresponding scaling
%       factor is not defined in 6.1.2 manual.
Br = (p.QBZ9.*p.LKY./p.LMUY+p.QBZ10.*By.*Cy).*ZETA6;

% (4.E46)
Cr = ZETA7;

% (4.E47)
% Note: Asterisk variant of LMUY is not used, because corresponding scaling
%       factor is not defined in 6.1.2 manual.
Dr = Fz.*R0.*((p.QDZ6+p.QDZ7.*dfz).*p.LRES.*ZETA2...
    +((p.QDZ8+p.QDZ9.*dfz).*(1+p.PPZ2.*dpi)...
    +(p.QDZ10+p.QDZ11.*dfz).*gammaAstAbs).*gammaAst.*p.LKZC.*ZETA0)...
    .*p.LMUY.*sgnVcx.*alphaCos + ZETA8 - 1;

% (4.E33)
t0 = Dt.*cos(Ct.*atan(Bt.*alphat-Et.*(Bt.*alphat-atan(Bt.*alphat)))).*alphaCos;

% (4.E32)
Mz0_ = -t0.*Fy0;

% (4.E36)
Mzr0 = Dr.*cos(Cr.*atan(Br.*alphar)).*alphaCos;

% (4.E31)
Mz0 = Mz0_ + Mzr0;
end

