%% Compares nested structures
function Structure_Match = Compare_Structure(Structure, First_Run)
    %Ensure the variable First_Run exists if required
    if(~exist('First_Run','var'))
        First_Run = true;
    end
    %Only run the function if the input is a structure
    if(isstruct(Structure))
        if(isequal(Structure,struct()))
            %Empty Structure; do nothing
        else
            %Get the size of the structure
            Structure_Length = length(Structure);
            %Get the number of fields in the structure
            Structure_Fieldnames = fieldnames(Structure);
            %For each element within the structure
            for Structure_Row = 1:Structure_Length
                if(~isempty(Structure_Fieldnames))
                    Field_Entry = 1;
                    for Current_Field = 1:length(Structure_Fieldnames)
                        Current_Field_Value = Structure.(Structure_Fieldnames{Current_Field});
                        Structure_Match(Structure_Row, Field_Entry).Field = {Structure_Fieldnames{Current_Field}};
                        Structure_Match(Structure_Row, Field_Entry).Class = {class(Current_Field_Value)};
                        Current_Field_Size = size(Current_Field_Value);
                        for Current_Size = 1:length(Current_Field_Size)
                            Structure_Match(Structure_Row, Field_Entry).(strcat("Dimension_",num2str(Current_Size))) = Current_Field_Size(Current_Size);
                        end
                        Field_Entry = Field_Entry + 1;
                        %If the current field value is a structure, add this to the array
                        if(isstruct(Current_Field_Value))
                            Inner_Structure = Compare_Structure(Current_Field_Value, false);
                            %Get the size of the structure
                            Inner_Structure_Length = length(Inner_Structure);
                            %Get the number of fields in the structure
                            Inner_Structure_Fieldnames = fieldnames(Inner_Structure);
                            if(isstruct(Inner_Structure))
                                if(isequal(Inner_Structure, struct()))
                                    %Empty Structure
                                else
                                    for Inner_Structure_Row = 1:Inner_Structure_Length
                                        for Inner_Current_Field = 1:length(Inner_Structure_Fieldnames)
                                            if(strcmp(Inner_Structure_Fieldnames{Inner_Current_Field}, 'Field'))
                                                Structure_Match(Structure_Row, Field_Entry).Field = strcat(Structure_Fieldnames{Current_Field}, "-", Inner_Structure(Inner_Structure_Row).Field);
                                            else
                                                Structure_Match(Structure_Row, Field_Entry).(Inner_Structure_Fieldnames{Inner_Current_Field}) = Inner_Structure.(Inner_Structure_Fieldnames{Inner_Current_Field});
                                            end
                                        end
                                        Field_Entry = Field_Entry + 1;
                                    end
                                end
                            end
                        end
                    end
                end
            end
            %If finalising the parent call of this function; cleanup
            if(First_Run)
                %If this execution of the function is the parent; reformat the structure
                %Get fieldnames of the containing structure
                Structure_Fieldnames = fieldnames(Structure_Match);
                %Remove static fields of Field and Class as these don't require dynamic use
                Structure_Fieldnames(strcmp(Structure_Fieldnames,'Field')) = [];
                Structure_Fieldnames(strcmp(Structure_Fieldnames,'Class')) = [];
                %Get fieldnames of the first entry
                Initial_Fieldnames = [Structure_Match(1, :).Field];
                Initial_Classes = [Structure_Match(1, :).Class];
                Field_Index = false(Structure_Row - 1, length(Initial_Fieldnames));
                Row_Match_Index =  zeros(Structure_Row - 1, length(Initial_Fieldnames));
                %for each row; check all fields exist with identical parameters to the initial row
                for Structure_Row = 2:size(Structure_Match,1)
                    Row_Fieldnames = [Structure_Match(Structure_Row, :).Field];
                    Row_Classes = [Structure_Match(1, :).Class];
                    for Initial_Field = 1:length(Initial_Fieldnames)
                        %Find matching field and class data
                        Field_and_Class_Match = and(strcmp(Initial_Fieldnames(Initial_Field), Row_Fieldnames), strcmp(Initial_Classes(Initial_Field), Row_Classes));
                        Field_and_Class_Match_Index = find(Field_and_Class_Match == 1);
                        %Check each match for dimensions
                        %Field_and_Class_Match_Index = find(Field_and_Class_Match == 1,1,'first');
                        if(length(Field_and_Class_Match_Index) == 1)
                            Size_Match = true;
                            for Dynamic_Structure = 1:length(Structure_Fieldnames)
                                if(~isequal(Structure_Match(Structure_Row, Initial_Field).(Structure_Fieldnames{Dynamic_Structure}), Structure_Match(Structure_Row, Field_and_Class_Match_Index).(Structure_Fieldnames{Dynamic_Structure})))
                                    Size_Match = false;
                                end
                            end
                            %If a match has been found
                            if(Size_Match)
                                Field_Index(Structure_Row - 1, Initial_Field) = Size_Match;
                                Row_Match_Index(Structure_Row - 1, Initial_Field) = Field_and_Class_Match_Index;
                            end
                        elseif(isempty(Field_and_Class_Match_Index))
                            %Empty; no match in current row
                        else
                            %More than one result
                            %Check matching index first
                            Corresponding_Index_Match = find(Field_and_Class_Match_Index == Initial_Field);
                            if(length(Corresponding_Index_Match) == 1)
                                Size_Match = true;
                                for Dynamic_Structure = 1:length(Structure_Fieldnames)
                                    if(~isequal(Structure_Match(Structure_Row, Initial_Field).(Structure_Fieldnames{Dynamic_Structure}), Structure_Match(Structure_Row, Field_and_Class_Match_Index(Corresponding_Index_Match)).(Structure_Fieldnames{Dynamic_Structure})))
                                        Size_Match = false;
                                    end
                                end
                                %If a match has been found or not; check for first match
                                if(Size_Match)
                                    Field_Index(Structure_Row - 1, Initial_Field) = Size_Match;
                                    Row_Match_Index(Structure_Row - 1, Initial_Field) = Field_and_Class_Match_Index(Corresponding_Index_Match);
                                else
                                    
                                end
                            end
                        end
                    end
                end
                clear Structure_Match;
                Structure_Match.Field_Index = Field_Index;
                Structure_Match.Row_Match_Index = Row_Match_Index;
            end
        end
    end
end