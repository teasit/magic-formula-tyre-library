function [x,lb,ub] = convert2fittable(params,fitmode)
arguments
    params mftyre.v62.Parameters
    fitmode mftyre.v62.FitMode
end
import('mftyre.v62.FitMode')
import('mftyre.v62.getFitParamNames')
fn = fieldnames(params);
fitparams = getFitParamNames(fitmode);
allParamsExist = numel(intersect(fn,fitparams)) == numel(fitparams);
assert(allParamsExist)
x  = zeros(length(fitparams),1);
lb = zeros(length(fitparams),1);
ub = zeros(length(fitparams),1);
for i=1:numel(fitparams)
    x(i)  = params.(fitparams{i}).Value;
    if params.(fitparams{i}).Fixed
        lb(i) = params.(fitparams{i}).Value;
        ub(i) = params.(fitparams{i}).Value;
    else
        lb(i) = params.(fitparams{i}).Min;
        ub(i) = params.(fitparams{i}).Max;
    end
end
end

