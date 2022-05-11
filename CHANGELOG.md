# Changelog

- Fixed Fitter not using already fitted parameters from previous fitting modes.
    This resulted in bad fitting results for Fx, Fy, because Fx0 and Fy0 results
    were not used, so fitter tried to use combined slip parameters to fit
    pure slip conditions.
