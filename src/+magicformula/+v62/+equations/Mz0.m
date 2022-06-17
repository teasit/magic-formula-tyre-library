function [Mz0,Bt,Ct,Et] = Mz0(p,slipangl,inclangl,pressure,Fz)
% todo: extend output arguments of Fy0

% todo: implement this:
sgnVcx = 1;

% (4.E4)
inclangl = sin(inclangl);
inclangl2 = inclangl.^2;

[Fy0,~,Fz0,dfz,dpi,By,Cy,~,~,Kya,SVy,SHy] = ...
    magicformula.v62.equations.Fy0(p,slipangl,0,pressure,Fz);
dfz2 = dfz.^2;

% (4.E6)
% todo: implement correctly
cosa = cos(slipangl);

% (4.E38), (4.E39)
SHf = SHy + SVy./(Kya+eps);

% (4.E35)
SHt = p.QHZ1 + p.QHZ2.*dfz + (p.QHZ3 + p.QHZ4.*dfz).*inclangl;

% (4.E34)
% todo: add a_asterisk
at = slipangl + SHt;

% (4.E37)
% todo add a_asterisk
ar = slipangl + SHf;

% (4.E42)
% todo check if LTR is correct scaling factor here
Dt0 = Fz.*(p.UNLOADED_RADIUS./Fz0).*(p.QDZ1+p.QDZ2.*dfz).*(1-p.PPZ1.*dpi).*p.LTR*sgnVcx;

% (4.E40)
% todo: check if correct scaling factor LKYC
% todo: add asterisk version of LMUY
% todo: QBZ6 not in TIR?
% Bt = (p.QBZ1 + p.QBZ2.*dfz + p.QBZ3.*dfz2).*(1+p.QBZ5.*abs(inclangl)+p.QBZ6.*inclangl2).*p.LKYC./p.LMUY;
Bt = (p.QBZ1 + p.QBZ2.*dfz + p.QBZ3.*dfz2).*(1+p.QBZ5.*abs(inclangl)).*p.LKYC./p.LMUY;

% (4.E41)
Ct = p.QCZ1;

% (4.E43)
Dt = Dt0.*(1+p.QDZ3.*abs(inclangl)+p.QDZ4.*inclangl2).*p.ZETA5;

% (4.E44)
Et = (p.QEZ1+p.QEZ2.*dfz+p.QEZ3.*dfz2)...
    .*(1+(p.QEZ4+p.QEZ5.*inclangl).*(2/pi).*atan(Bt.*Ct.*at));

% (4.E45)
% todo: check if LKY is correct lambda scaling factor
% todo: add (4.E7) for LMUY
Br = (p.QBZ9.*p.LKY./p.LMUY+p.QBZ10.*By.*Cy).*p.ZETA6;

% (4.E46)
Cr = p.ZETA7;

% (4.E46)
% todo: check if is correct scaling factors LKZC LMP
% todo: add asterisk version of LMUY
Dr = Fz.*p.UNLOADED_RADIUS.*((p.QDZ6+p.QDZ7.*dfz).*p.LMP.*p.ZETA2...
    +((p.QDZ8+p.QDZ9.*dfz).*(1+p.PPZ2.*dpi)...
    +(p.QDZ10+p.QDZ11.*dfz).*abs(inclangl)).*inclangl.*p.LKZC.*p.ZETA0)...
    .*p.LMUY.*sgnVcx.*cosa + p.ZETA8 - 1;

% (4.E33)
t0 = Dt.*cos(Ct.*atan(Bt.*at-Et.*(Bt.*at-atan(Bt.*at)))).*cosa;

% (4.E32)
Mz0_ = -t0.*Fy0;

% (4.E36)
Mzr0 = Dr.*cos(Cr.*atan(Br.*ar)).*cosa;

% (4.E31)
Mz0 = Mz0_ + Mzr0;
end

