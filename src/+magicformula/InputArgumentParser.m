classdef (Hidden) InputArgumentParser < inputParser
    %MAGICFORMULA.INPUTARGUMENTPARSER Parses magic formula input arguments.
    
    methods
        function parser = InputArgumentParser()
            versions = enumeration('MagicFormulaVersion');
            isValidVersion = @(x) mustBeMember(x, versions);
            isValidNumericVector = @(x) isnumeric(x) && isvector(x);
            isValidTyreSide = @(x) mustBeMember(x, [0, 1]);
            isValidParameters = @(x) isstruct(x) ...
                || isa(x, 'MagicFormulaTyre') ...
                || isa(x, 'magicformula.Parameters') ...
                || isfile(x);
            
            addRequired(parser,'params',isValidParameters);
            addRequired(parser,'SX',isValidNumericVector);
            addRequired(parser,'SA',isValidNumericVector);
            addOptional(parser,'FZ',[],isValidNumericVector);
            addOptional(parser,'IP',[],isValidNumericVector);
            addOptional(parser,'IA',0,isValidNumericVector);
            addOptional(parser,'VX',[],isValidNumericVector);
            addOptional(parser,'side',[],isValidTyreSide);
            addOptional(parser,'version',[],isValidVersion);
        end
    end
end
