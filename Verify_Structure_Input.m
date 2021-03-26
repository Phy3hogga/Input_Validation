%% Verify data type of a structure field when passing between functions, will revert to a default value if not supplied with a valid structure fieldname
%:Inputs:
% - Structure (structure) structure to search
% - Fieldname (char)
%:Outputs:
% - Value (dependent on field and default value datatypes)
% - Valid (boolean)
% - Default Value Used (boolean)
function [Value, Valid, Default_Used] = Verify_Structure_Input(Structure, Fieldname, Default_Value, Allowed_Values)
    %% :Example Uses:
    
    %% USE 1: List of allowed values
    %CHECK STRUCTURE NAMED 'Parameters' FOR FIELD 'Colour_Map_Name' WITH A DEFAULT VALUE OF 'parula' WITH A LIST OF ALLOWED VALUES
        %[Struct_Var_Value, Struct_Var_Valid] = Verify_Structure_Input(Parameters, 'Colour_Map_Name', 'parula', {'parula','jet','hsv','hot','cool','spring','summer','autumn','winter','gray','bone','copper','pink','lines','colourcube','prism','flag','white'});
    %IF THE STRUCTURE FIELD EXISTS AND IS VALID (DEFAULT OR NOT)
        %if(Struct_Var_Valid)
    %ASSIGN VALUE TO VARIABLE
        %    Colour_Map_Name = Struct_Var_Value;
        %end
    %CLEAR TEMPORARY VARIABLES
        %clear Struct_Var_Value Struct_Var_Valid;
        
    %% USE 2
    %CHECK STRUCTURE NAMED 'Structure' FOR FIELD 'Field' WITH A DEFAULT VALUE OF '0'
        %[Struct_Var_Value, Valid, Default] = Verify_Structure_Input(Structure, Field, 0);
    %IF THE VALUE ISN'T THE DEFAULT SET AND IS VALID
        %if(Valid && ~Default)
    %ASSIGN VALUE TO VARIABLE
            %Field_Value = Struct_Var_Value;
        %end
    %CLEAR TEMPORARY VARIABLES
        %clear Struct_Var_Value Struct_Var_Valid;
        
    %% Initialisation of parameters
    %Assume invalid parameters passed
    Valid = false;
    %Assume default value is not being used as the function output
    Default_Used = false;
    
    %% If a default value has been set, check what the datatype is
    %check if a default value has been set
    if(exist('Default_Value','var'))
        %Flag default value set
        Default_Value_Set = true;
        %check datatype for default value
        Default_Value_Check_Char = ischar(Default_Value);
        Default_Value_Check_Numeric = isnumeric(Default_Value);
        Default_Value_Check_Logical = islogical(Default_Value);
        Default_Value_Check_Cell = iscell(Default_Value);
    else
        %Flag default value not set
        Default_Value_Set = false;
        %Default all default value datatypes as true
        Default_Value_Check_Char = true;
        Default_Value_Check_Numeric = true;
        Default_Value_Check_Logical = true;
        Default_Value_Check_Cell = true;
    end
    
    %% If the structure provided is indeed a structure
    %check the provided structure is indeed a structure    
    if(isstruct(Structure))
        %check field exists in the structure
        if(isfield(Structure, Fieldname))
            %% Check allowed values match the supplied input (if provided)
            %if a list of allowed values exist
            if(exist('Allowed_Values','var'))
                %check if allowed values list isn't empty
                if(isempty(Allowed_Values))
                    Allowed_Default_Value = true;
                    Allowed_Structure_Value = true;
                else
                    %if list isn't empty, check value is found in list
                    Allowed_Default_Value = ismember(Default_Value, Allowed_Values);
                    Allowed_Structure_Value = ismember(Structure.(Fieldname), Allowed_Values);
                end
            else
                %default to allow the value
                Allowed_Default_Value = true;
                Allowed_Structure_Value = true;
            end
            %% Check between default datatypes and the supplied input to handle the extraction of the variable from the structure
            %if data type is supposed to be a character or character array
            if(ischar(Structure.(Fieldname)) || Default_Value_Check_Char)
                %check if the data in the fieldname matches the data type
                if(ischar(Structure.(Fieldname)) && Default_Value_Check_Char && Allowed_Structure_Value)
                    Value = Structure.(Fieldname);
                    Valid = true;
                else
                    %attempt to use default value if set
                    if(Default_Value_Set && Default_Value_Check_Char && Allowed_Default_Value)
                        Value = Default_Value;
                        Valid = true;
                        Default_Used = true;
                    else
                        disp(strcat("No default value set for ", Fieldname ,"."));
                        Value = '';
                        Valid = false;
                    end
                end
            %if data type is supposed to be a cell
            elseif(iscell(Structure.(Fieldname)) || Default_Value_Check_Cell)
                %check if the data in the fieldname matches the data type
                if(iscell(Structure.(Fieldname)) && Default_Value_Check_Cell && Allowed_Structure_Value)
                    Value = Structure.(Fieldname);
                    Valid = true;
                else
                    %attempt to use default value if set
                    if(Default_Value_Set && Default_Value_Check_Cell && Allowed_Default_Value)
                        Value = Default_Value;
                        Valid = true;
                        Default_Used = true;
                    else
                        disp(strcat("No default value set for ", Fieldname ,"."));
                        Value = {};
                        Valid = false;
                    end
                end
            %if data type is supposed to be numeric
            elseif(isnumeric(Structure.(Fieldname)) || Default_Value_Check_Numeric)
                %check if the data in the fieldname matches the data type
                if(isnumeric(Structure.(Fieldname)) && Default_Value_Check_Numeric && Allowed_Structure_Value)
                    Value = Structure.(Fieldname);
                    Valid = true;
                else
                    %attempt to use default value if set
                    if(Default_Value_Set && Default_Value_Check_Numeric && Allowed_Default_Value)
                        Value = Default_Value;
                        Valid = true;
                        Default_Used = true;
                    else
                        disp(strcat("No default value set for ", Fieldname ,"."));
                        Value = 0;
                        Valid = false;
                    end
                end
            %if datatype is logical (boolean)
            elseif(islogical(Default_Value) || Default_Value_Check_Logical)
                %check if the data in the fieldname matches the data type
                if(islogical(Structure.(Fieldname)) && Default_Value_Check_Logical && Allowed_Structure_Value)
                    Value = Structure.(Fieldname);
                    Valid = true;
                else
                    %attempt to use default value if set
                    if(Default_Value_Set && Default_Value_Check_Logical && Allowed_Default_Value)
                        Value = Default_Value;
                        Valid = true;
                        Default_Used = true;
                    else
                        disp(strcat("No default value set for ", Fieldname ,"."));
                        Value = false;
                        Valid = false;
                    end
                end
            else
                disp(strcat("Unable to determine datatype for ", Fieldname ,"."));
            end
        else
            %% Field doesn't exist in the structure
            %attempt to use default value
            if(Default_Value_Set)
                Value = Default_Value;
                Valid = false;
                Default_Used = true;
            else
                disp(strcat("No default value set for ", Fieldname ,"."));
                Value = '';
                Valid = false;
            end
        end
    else
        %No structure supplied
        disp("Expected structure input as first variable");
    end
    %% Check valid and value both exist before exiting the function
    if(~exist('Valid','var'))
        Valid = false;
    end
    if(~exist('Value','var'))
        Valid = '';
    end
end