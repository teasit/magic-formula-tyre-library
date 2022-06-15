# Changelog

- Renaming of library and functions due to trademark issues
- Added example measurement data (de-identified and obscured TTC data)
- Updated FSAE TTC interactive example to use new data
- Updated unit tests
- Convenience changes:
  - New: Wrapper for `magicformula.v62.eval()` function. Can now call method `eval()` on `magicformula.v62.Model` objects. Example:

        ```matlab
        model = magicformula.v62.Model();
        model.importTyrePropertiesFile(file)
        [FX, FY] = model.eval(SA, SX, IA, IP, FZ, 0);
        ```

  - New: Can now instantiate `magicformula.v62.Model` directly with TIR file, without having to call `importTyrePropertiesFile()` method. Example:

        ```matlab
        model = magicformula.v62.Model(file);
        [FX, FY] = model.eval(SA, SX, IA, IP, FZ, 0);
        ```
