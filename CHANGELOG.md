# Changelog

- Added example measurement data (de-identified and obscured TTC data)
- Updated FSAE TTC interactive example to use new data
- Updated unit tests
- Convenience changes:
  - New: Wrapper for `mftyre.v62.eval()` function. Can now call method `eval()` on `mftyre.v62.Model` objects. Example:

        ```matlab
        model = mftyre.v62.Model();
        model.importTyrePropertiesFile(file)
        [FX, FY] = model.eval(SA, SX, IA, IP, FZ, 0);
        ```

  - New: Can now instantiate `mftyre.v62.Model` directly with TIR file, without having to call `importTyrePropertiesFile()` method. Example:

        ```matlab
        model = mftyre.v62.Model(file);
        [FX, FY] = model.eval(SA, SX, IA, IP, FZ, 0);
        ```
