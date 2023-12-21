# Magic Formula Tyre Library

[![View on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://de.mathworks.com/matlabcentral/fileexchange/110955)
[![GitHub release (latest by date)](https://img.shields.io/github/v/release/teasit/magic-formula-tyre-library)](https://github.com/teasit/magic-formula-tyre-library/releases/latest)
[![MATLAB Latest Tests Status](https://github.com/teasit/magic-formula-tyre-library/actions/workflows/test-matlab-r2023b.yml/badge.svg?branch=main)](https://github.com/teasit/magic-formula-tyre-library/actions/workflows/test-matlab-r2023b.yml)

![Fitting Example](doc/images/magic_formula_library_socialpreview.png)

```matlab
[FX,FY,MZ,MY,MX] = magicformula(params,__)
```

- Computationally efficient
- Code generation compatible
- Automated fitting to data
- TIR (*.tir) import/export
- TYDEX (*.tdx) import/export

## Requirements

- MATLAB Base
- (Optional) Optimization Toolbox (fitting)
- (Optional) Signal Processing Toolbox (measurement import)

### Release Compatibility

- [![R2022b](https://github.com/teasit/magic-formula-tyre-library/actions/workflows/test-matlab-r2022b.yml/badge.svg?branch=main)](https://github.com/teasit/magic-formula-tyre-library/actions/workflows/test-matlab-r2022b.yml)
- [![R2022a](https://github.com/teasit/magic-formula-tyre-library/actions/workflows/test-matlab-r2022a.yml/badge.svg?branch=main)](https://github.com/teasit/magic-formula-tyre-library/actions/workflows/test-matlab-r2022a.yml)
- [![R2021b](https://github.com/teasit/magic-formula-tyre-library/actions/workflows/test-matlab-r2021b.yml/badge.svg?branch=main)](https://github.com/teasit/magic-formula-tyre-library/actions/workflows/test-matlab-r2021b.yml)
- [![R2021a](https://github.com/teasit/magic-formula-tyre-library/actions/workflows/test-matlab-r2021a.yml/badge.svg?branch=main)](https://github.com/teasit/magic-formula-tyre-library/actions/workflows/test-matlab-r2021a.yml)
- [![R2020b](https://github.com/teasit/magic-formula-tyre-library/actions/workflows/test-matlab-r2020b.yml/badge.svg?branch=main)](https://github.com/teasit/magic-formula-tyre-library/actions/workflows/test-matlab-r2020b.yml)
- [![R2020a](https://github.com/teasit/magic-formula-tyre-library/actions/workflows/test-matlab-r2020a.yml/badge.svg?branch=main)](https://github.com/teasit/magic-formula-tyre-library/actions/workflows/test-matlab-r2020a.yml)

## Installation

- Download from [MATLAB File Exchange](https://de.mathworks.com/matlabcentral/fileexchange/110955)
- Download from [GitHub](https://github.com/teasit/magic-formula-tyre-library/releases)
- Clone and integrate into your MATLAB projects as a [Project Reference](https://de.mathworks.com/help/simulink/ug/add-or-remove-a-reference-to-another-project.html)

## Usage and Examples

See [`GettingStarted.mlx`](./doc/GettingStarted.mlx) to get started. If you install
the library as a toolbox, you will be prompted to open said Live Script. It contains
an overview of the library and is the recommended way to get started.

### Example: Model vs. Data

This code generates the title figure of this README. Either clone the library or install
it as a toolbox and try it yourself. You can download the example data
[here](https://github.com/teasit/magic-formula-tyre-library/tree/main/doc/examples/fsae-ttc-data).
The data has been de-identified to conform with the FSAE TTC's
[license agreement](https://www.millikenresearch.com/FSAE_TTC_agreement.pdf).

```matlab
folder = 'doc/examples/fsae-ttc-data';
file = fullfile(folder, 'fsaettc_obfuscated.tir');
tyre = MagicFormulaTyre(file);

file = fullfile(folder, 'fsaettc_obscured_testbench_drivebrake.mat');
parser = tydex.parsers.FSAETTC_SI_ISO_Mat();
measurements = parser.run(file);
measurements = measurements([30 40 55 60 70 75]);

figure(); grid on; hold on
c = colororder();
for i = 1:numel(measurements)
    [SX,SA,FZ,IP,IA,VX,FX] = unpack(measurements(i));
    FX_mdl = magicformula(tyre,SX,SA,FZ,IP,IA,VX);
    plot(SX, FX_mdl, 'Color', c(i,:), 'LineWidth', 2)
    plot(SX, FX, '.', 'Color', c(i,:), 'MarkerSize', 4)
end
xlabel('SX / 1'); ylabel('FX / N')
```

Further examples can be found in the  [`doc/examples`](./doc/examples) folder.

## Motivation

The project was motivated by my work in the Formula Student Team
[UPBracing](https://formulastudent.uni-paderborn.de/en/). My goal was to create an
easy-to-use MATLAB library for other students to use in their vehicle dynamics projects.

This project would not have been possible without the data provided by the
[Formula SAE Tire Test Consortium (FSAE TTC)](https://www.millikenresearch.com/fsaettc.html)
and the
[Calspan Tire Testing Research Facility (TIRF)](https://calspan.com/automotive/fsae-ttc).
De-identified and obscured test data has been used in examples and images or recordings
of the application, to conform to the
[license agreement](https://www.millikenresearch.com/FSAE_TTC_agreement.pdf).
Special thanks to Dr. Edward M. Kasprzak for granting me permission to provide the used,
de-identified and obscured data for demonstration purposes.

## Known Issues

- Currenlty only version 6.1.2 (61) is implemented
- Turnslip is ignored
