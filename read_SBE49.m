function SCAT_data = read_SBE49(filename, dataLines)
%IMPORTFILE1 Import data from a text file
%  SBEFASTCATCTD49012021073008 = IMPORTFILE1(FILENAME) reads data from
%  text file FILENAME for the default selection.  Returns the data as a
%  table.
%
%  SBEFASTCATCTD49012021073008 = IMPORTFILE1(FILE, DATALINES) reads data
%  for the specified row interval(s) of text file FILENAME. Specify
%  DATALINES as a positive scalar integer or a N-by-2 array of positive
%  scalar integers for dis-contiguous row intervals.
%
%  Example:
%  SBEFastCatCTD49012021073008 = importfile1("C:\Users\sa01ld\OneDrive - SAMS\Projects\Autonaut-EE\Non-Acoustic data\SBE_FastCat_CTD_49_01\2021\07\SBE_FastCat_CTD_49_01_2021_07_30_08.dat", [1, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 14-Feb-2022 15:50:43

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [1, Inf];
end

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 7);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["DateString", "Time2", "Temperature", "Conductivity", "Pressure", "Salinity", "SoundVelocity"];
opts.VariableTypes = ["string", "datetime", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "DateString", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "DateString", "EmptyFieldRule", "auto");
opts = setvaropts(opts, "Time2", "InputFormat", "HH:mm:ss");

% Import the data
SCAT_data = readtable(filename, opts);

end