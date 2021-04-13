%% When on windows, escape the file path provided to File_Path. Checks if the path already exists if Check_Path_Already_Exists is true
function Escaped_File_Path = Escape_File_Path_String(File_Path, Check_Path_Already_Exists)
    %% By default output the input file path
    Escaped_File_Path = File_Path;
    %% String escape on windows only; linux paths are formed differently
    if(ispc)
        %% Input Handling
        if(nargin == 1)
        elseif(nargin == 2)
            %Accept numeric 1 or 0 as logical
            if(isnumeric(Check_Path_Already_Exists))
                if(Check_Path_Already_Exists == 1)
                    Check_Path_Already_Exists = true;
                elseif(Check_Path_Already_Exists == 0)
                    Check_Path_Already_Exists = false;
                else
                    warning("Escape_File_Path_String : Expected Check_Path_Already_Exists to be logical, defaulting to false.");
                end
            end
            if(~islogical(Check_Path_Already_Exists))
                Check_Path_Already_Exists = false;
                warning("Escape_File_Path_String : Expected Check_Path_Already_Exists to be logical, defaulting to false.");
            end
        else
            error("Escape_File_Path_String : Unexpected number of input arguments.");
        end
        %Only validate datatypes on windows; other operating systems use a passthrough value anyway
        if(isstring(File_Path))
            %Convert string to character
            File_Path = char(File_Path);
        end
        %Valid datatype
        if(ischar(File_Path))
            % Use regex to find a valid windows directory path, stripping any existing escaping quotations into Match{1}{1} and Match{1}{3}
            [~, Matches] = regexp(File_Path, '^("?)([a-zA-Z]:\\(?:(?:(?![<>:"\/\\|?*]).)+(?:(?<![ .])\\)?)*)("?)$', 'match', 'tokens');
            if(Check_Path_Already_Exists)
                if(isfile(Matches{1}{2}) || isfolder(Matches{1}{2}))
                    % Escape the file path
                    Escaped_File_Path = strcat('"', Matches{1}{2}, '"');
                else
                    warning(strcat("Escape_File_Path_String : Could not locate file or directory : ", Matches{1}{2}));
                end
            else
                Escaped_File_Path = strcat('"', Matches{1}{2}, '"');
            end
        else
            error("Escape_File_Path_String : Expected first input to be a character array or string.");
        end
    end
end