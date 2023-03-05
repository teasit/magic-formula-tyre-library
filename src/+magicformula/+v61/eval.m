function [FX,FY,MZ,MY,MX] = eval(p,SX,SA,FZ,IP,IA,VX,side)
%MAGICFORMULA.V61.EVAL
mirrorCurve = side ~= p.TYRESIDE;
SA = (-1).^mirrorCurve.*SA;
FX = magicformula.v61.Fx(p,SX,SA,FZ,IP,IA,VX);
FY = magicformula.v61.Fy(p,SX,SA,FZ,IP,IA,VX);
FY = (-1).^mirrorCurve.*FY;
if nargout() >= 3
    if all(SX == 0)
        MZ = magicformula.v61.Mz0(p,SA,FZ,IP,IA,VX);
    else
        MZ = magicformula.v61.Mz(p,SX,SA,FZ,IP,IA,VX,FX,FY);
    end
    MZ = (-1).^mirrorCurve.*MZ;
end
if nargout() >= 4
    MY = magicformula.v61.My(p,FZ,IP,IA,VX,FX);
    MY = (-1).^mirrorCurve.*MY;
end
if nargout() >= 5
    MX = magicformula.v61.Mx(p,FZ,IP,IA,FY);
end
end
