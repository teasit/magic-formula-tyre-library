# Changelog

- CHANGED: input handling of "VX" was not ideal; now has more fallback levels
- CHANGED: Fitter settings are not stored as `optim.options.SolverOptions` but as struct.
  This is easier to handle when storing settings in the global MATLAB `settings()`.
- FIX: parser handling of FSAE TTC MAT files
- improved error handling
