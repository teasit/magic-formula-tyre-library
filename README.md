# MF-Tyre MATLAB Library

![Social Preview Image](./doc/images/tyre_icon_socialpreview.png)

```matlab
[Fx,Fy] = mftyre.v62.eval(p,slipangl,longslip,inclangl,inflpres,FZW,tyreSide)
```

- Computationally efficient MF-Tyre functions
- Code generation compatible
- Automatically fit MF-Tyre models to data
- TIR import/export (Tyre Property File format)
- TYDEX import (Tyre Data Exchange format)

![MF-Tyre Fitting Example](doc/images/mftyrelib_fit_example.svg)

## Installation

You can use the features of this library in two ways:

- As a local ToolBox (simply download and install [`MFTyreLibrary.mltbx`](./MFTyreLibrary.mltbx))
- As a [Project Reference](https://de.mathworks.com/help/simulink/ug/add-or-remove-a-reference-to-another-project.html)

To use as a project reference, follow the instructions [here](https://de.mathworks.com/help/simulink/ug/add-or-remove-a-reference-to-another-project.html).
This is better if this project ought to be part of a larger Git-based project.
You could then add it as a Git Submodule.

## Usage and Examples

For interactive examples and usage instructions, open the MATLAB live script
[`doc/GettingStarted.mlx`](./doc/GettingStarted.mlx) in your editor.

## Motivation

The project was motivated by my work in the Formula Student Team
[UPBracing](https://formulastudent.uni-paderborn.de/en/). As I required
a performant, easy-to-use and precise implementation of the Magic Formula,
and existing implementations were not satisfactory (either being commercialized
and therefore without source or [very slow](https://de.mathworks.com/matlabcentral/fileexchange/63618-mfeval)),
it made sense to make my own version.

This library is currently used in the team's Torque-Vectoring
algorithms and all vehicle-modeling applications. Therefore the model
evaluation functions are suitable for code-generation and have actually
proven to be only moderately slower than linear tire models.

I hope this project benefits some students passionate about Vehicle Dynamics.
If you have any questions, don't hesitate to contact me! I will try and keep this
project updated in the future. If you want to contribute, please do. But I
must warn you, I am still new to publishing code as open-source and do not yet
know the ins and outs of working collaboratively on GitHub.

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
