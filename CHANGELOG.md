# Changelog

In this big update I tried to refactor the library in a way that eases the
use of the functions at the command-line. The most notatble change is the
`magicformula()` function that acts as a version-independent convenience
function to evaluate parameter sets. To make the function-call easier, a few
input arguments have been declared optional. For this change, the order of
arguments has been changed as noted below.

- FIX: Within calculation of Fy0, the pacejka equation (4.E30) used a wrong
        paramter (PKY5 instead of PPY5). This is now fixed!
- NEW: Convenience function `magicformula()`.
        Intended to replace calling `magicformula.v61.eval()` directly.
        In the future, this function is supposed to be able to evaluate
        different versions of parameter sets (e.g. both v52 and v61).
- NEW: Convenience class `MagicFormulaTyre`. See examples.
- NEW: Plot package. Use `magicformula.plots` to access them.
- NEW: Added calculation of MZ, MY, MX. Can also be fitted. See examples.
- BREAKING: Moved `+tir` package into `+magicformula`.
- BREAKING: order of arguments changed for evaluation functions:
        OLD `(params,SA,SX,IA,IP,FZ,side)` --> NEW `(params,SX,SA,FZ,IP,IA,side)`
        Rationale was to put arguments that can more easily be ommited last
        and make them optional. Slip ratio (SX) and slip angle (SA) are usually
        known or assumed zero, so they are the only mandatory arguments.
        All other inputs can be set to nominal values from parameter set or
        set to zero.
- BREAKING: position of multiple functions and classes within the package
        `+magicformula` has changed; subpackage `+v62` has been corrected to
        `+v61`. If you have been using some functions or classes within the
        `magicformula` package, make sure you update their path.
        (e.g. `magicformula.v62.equations.Fx0` --> `magicformula.v61.Fx0`)
- BREAKING: order of outputs of `magicformula()` function changed:
        [FX,FY,mux,muy] --> [FX,FY,MZ,MY,MX] (mue have been removed)
