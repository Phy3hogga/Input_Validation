%% Converts a string to a numeric datatype while verifying that the string matches the required syntax for a numeric input. Returns [NaN, false] if the string is not a valid numeric value.
%:Inputs:
% - String (Char array / Cell array)
%:Outputs:
% - Numeric_Value of String (Double)
% - Numeric_Valid (boolean)
function [Numeric_Value, Numeric_Valid] = Verify_Numeric(String)
    %% Input handling
    Valid_Input = false;
    if(ischar(String) || isstring(String) || iscell(String))
        Valid_Input = true;
    end
    %% Assume string supplied is indeed numeric
    Numeric_Valid = true;
    if(Valid_Input)
        %if required string variable exists
        if(exist('String','var'))
            %get numeric component using regex
            try
                Numeric_Value = strtrim(regexp(String,'[+-]?(?:[0-9]*\.?[0-9]+|[0-9]+\.?[0-9]*)(?:[eE][+-]?(?:[0-9]*\.?[0-9]+|[0-9]+\.?[0-9]*))?','match'));
            catch
                disp("Verify_Numeric : Warning : Failed to get numeric component from input string, defaulting NaN");
                Numeric_Value = NaN;
            end
            %% handle regex output based on datatype and whether a valid numeric value was found
            if(iscell(Numeric_Value))
                %if at least one numeric value found
                if(length(Numeric_Value) == 1)
                    Numeric_Value = str2num(char(Numeric_Value));
                elseif(length(Numeric_Value) > 1)
                    Numeric_Value = cell2mat(cellfun(@str2num, cellfun(@char, Numeric_Value,'un', 0),'un', 0));
                    %disp("More than one numeric component found, defaulting to first value.");
                    %Numeric_Value = str2num(char(Numeric_Value(1)));
                else
                    disp("No numeric value found in string.");
                    Numeric_Valid = false;
                end
            elseif(ischar(Numeric_Value))
                %if at least one numeric value found for char
                if(length(Numeric_Value) == 1)
                    Numeric_Value = str2num(char(Numeric_Value));
                elseif(length(Numeric_Value) > 1)
                    disp("More than one numeric component found, defaulting to first value.");
                    Numeric_Value = str2num(char(Numeric_Value(1,:)));
                else
                    disp("No numeric value found in string.");
                    Numeric_Valid = false;
                end
            elseif(isstring(Numeric_Value))
                %if at least one numeric value found for string
                if(length(Numeric_Value) == 1)
                    Numeric_Value = str2num(char(Numeric_Value));
                elseif(length(Numeric_Value) > 1)
                    disp("More than one numeric component found, defaulting to first value.");
                    Numeric_Value = str2num(char(Numeric_Value(1,1)));
                else
                    disp("No numeric value found in string.");
                    Numeric_Valid = false;
                end
            else
                %Unknown datatype
                disp("Unable to determine match datatype");
                Numeric_Valid = false;
            end
        else
            %No input supplied
            disp("Invalid Input; expected string as first input.");
            Numeric_Valid = false;
        end
    end
    %% Ensure a numeric value exists for output (NaN if invalid)
    if(~exist('Numeric_Value','var'))
        Numeric_Value = NaN;
    end
end