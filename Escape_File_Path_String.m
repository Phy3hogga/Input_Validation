%% When on windows, escape the file path
function Escaped_File_Path = Escape_File_Path_String(File_Path)
    %% By default output the input file path
    Escaped_File_Path = File_Path;
    %% String escape on windows only; linux paths are formed differently
    if(ispc)
        %% Input Handling
        if(nargin ~= 1)
            error("Escape_File_Path_String : Expected a single input of file path.");
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
            if(isfile(Matches{1}{2}) || isfolder(Matches{1}{2}))
                % Escape the file path
                Escaped_File_Path = strcat('"', Matches{1}{2}, '"');
            else
                warning(strcat("Escape_File_Path_String : Could not locate file or directory : ", Matches{1}{2}));
            end
        else
            error("Escape_File_Path_String : Expected input to be character array or string.");
        end
    end
end