function Mz = Mz(p,longslip,slipangl,Fz,pressure,inclangl,Vcx,Fx,Fy)
%MAGICFORMULA.V61.MZ
[~,Bt,Ct,Dt,Et,Br,Cr,Dr,alphaCos,R0,alphar,alphat] = magicformula.v61.Mz0(p,slipangl,Fz,pressure,inclangl,Vcx);
[~,~,~,~,~,~,Kxk] = magicformula.v61.Fx0(p,longslip,Fz,pressure,inclangl);
[~,~,dfz,Fz0_,~,~,~,~,~,Kya_] = magicformula.v61.Fy0(p,slipangl,Fz,pressure,inclangl);
[~, ~,Gyk,~,~,Fy0,gammaAst] = magicformula.v61.Fy(p,longslip,slipangl,Fz,pressure,0,Vcx);

kappa2 = longslip.^2;
KxkKya2 = (Kxk./Kya_).^2;

% (4.E78)
alphar2 = alphar.^2;
alpharSgn = sign(alphar);
alpharEq = sqrt(alphar2 + kappa2.*KxkKya2).*alpharSgn;
% alpharEq = atan(sqrt(tan(alphar).^2+(Kxk./Kya_).^2.*kappa.^2)).*alpharSgn; % (A54)

% (4.E77)
alphat2 = alphat.^2;
alphatSgn = sign(alphat);
alphatEq = sqrt(alphat2 + kappa2.*KxkKya2).*alphatSgn;
% alphatEq = atan(sqrt(tan(alphat).^2+(Kxk./Kya_prime).^2.*kappa.^2)).*sign(alphat); % (A55)

% (4.E76)
s = R0.*(p.SSZ1+p.SSZ2.*(Fy/Fz0_)+(p.SSZ3+p.SSZ4.*dfz).*gammaAst).*p.LS;

% (4.E75)
Mzr = Dr.*cos(Cr.*atan(Br.*alpharEq)).*alphaCos;

% (4.E74)
Fy_ = Gyk.*Fy0;

% (4.E73) Pneumatic trail
t = Dt.*cos(Ct.*atan(Bt.*alphatEq-Et.*(Bt.*alphatEq-atan(Bt.*alphatEq)))).*alphaCos;

% (4.E72)
Mz_ = -t.*Fy_;

% (4.E71)
Mz = Mz_ + Mzr + s.*Fx;
end

