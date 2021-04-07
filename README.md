# Input Validation

Matlab scripts that provide some simple quality of life functions while providing error correction and custom input handling for structures and conversion of string to numeric values. This is a supporting submodule for other repositories.

### Functions
#### Verify_Numeric.m
Converts a string representing a numeric datatype (floating point and integer) into the relevant datatype and checks whether it is a valid number. If Numeric_Valid is false, Numeric_Value should return NaN.
```matlab
%Convert an integer
String = "13";
[Numeric_Value, Numeric_Valid] = Verify_Numeric(String);
%Convert a float
String = '16.3';
[Numeric_Value, Numeric_Valid] = Verify_Numeric(String);
```
#### Verify_Structure_Input.m
Performs input validation for matlab functions, where a structure is used as a configuration input to change the function behaviour. This function serves to validate all datatypes against a reference default value.
```matlab
%% Parent function
Directory_Path_To_RAR = 'C:\Test';
Output_Rar_File = 'Test.rar';
RAR_Parameters.WinRAR_Path = 'C:\Program Files\WinRAR\WinRAR.exe';
Success = RAR(Directory_Path_To_RAR, Output_RAR_File, RAR_Parameters);

%% Validate path to WinRAR executable within the RAR function 
function Success = RAR(Directory_Path_To_RAR, Output_RAR_File, RAR_Parameters);
	% Validate WinRAR Path input
	Default_Value = 'WinRAR.exe';
	[Input_Value, Input_Valid, Default_Used] = Verify_Structure_Input(RAR_Parameters, 'WinRAR_Path', Default_Value);
	if(Input_Valid)
		% returns true if either the input or the default are valid datatypes
		if(Default_Used)
			%Default is used over input if the input didn't match the default datatype
			WinRAR_Path = Default_Value;
		else
			%Input matches datatype and is valid 
			WinRAR_Path = Input_Value;
		end
	else
		%Fallback to ensure the variable has a value set
		WinRAR_Path = Default_Value;
	end
end
```

#### Compare_Structure.m
Compares nested structures for duplication, depreciated.
```matlab
%Random data
Monitor = struct();
Monitor.Monitor = struct();
Compare = Compare_Structure(Monitor, true);
```

## Built With

* [Matlab R2018A](https://www.mathworks.com/products/matlab.html)
* [Windows 10](https://www.microsoft.com/en-gb/software-download/windows10)

## References
* **Alex Hogg** - *Initial work* - [Phy3hogga](https://github.com/Phy3hogga)