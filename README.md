# MF-Tyre MATLAB Library

This repository contains easy-to-use functions and classes to:

- Represent MFTyre models in a OOP-way
  (helpful in developing GUI-applications).
- Evaluate MFTyre parameter sets
  (useful for any use-case where tyre forces need to be calculated).
- Import tyre data and represent and export it in TYDEX format
  (useful to export tyre data in Siemens MF-Tool readable format).
- Fit MFTyre models to tyre data (curve-fitting).

## Installation

You can use the features of this library in two ways:

- As a local ToolBox
- As a [Project Reference](https://de.mathworks.com/help/simulink/ug/add-or-remove-a-reference-to-another-project.html)

To use as a toolbox, simply download the file `MFTyreLibrary.mltbx` and
follow the instructions. This is the quickest and most user-friendly way to get started.

To use as a project reference, follow the instructions [here](https://de.mathworks.com/help/simulink/ug/add-or-remove-a-reference-to-another-project.html).
This is better if this project ought to be part of a larger Git-based project.
You could then add it as a Git Submodule.

## Known Issues, Notes and Bugs

- Currently only MFTyre version 6.1.2 (62) is implemented
- Of v6.1.2 the turn slip parameters have been reduced to constant parameters
  (noted by greek letter zeta in Pacejka's book). To remove the influence of
  these parameters, simply set them to unity (=1). The default parameter
  set automatically applies unity. This effectively ignores turn slip.
- Equations (4.E7) and (4.E8) are ignored (velocity-dependent scaling of
  friction coefficient) to remove dependency on speed as input. Might be
  added as an alternative implementation in the future.
- In some sub-equations a few scaling factors were not implemented
  (as they could not be attributed to a parameter in the MFTyre/MFSwift manual).
- Self-aligning torque is not calculated/implemented (MZW).
