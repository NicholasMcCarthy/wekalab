function cellArray = stringsplit( string, delimiter)
%STRINGSPLIT Splits a char array into a cell array by delimiter.
%   C = stringsplit(STRING, DELIMITER) returns a cell array of the values
%   in STRING divided by DELIMITER. 
%       
% If there is no delimiter found, returns the entire input string in a cell.
%
% NOTE: This file is included because older versions of Matlab do not have
% the 'strsplit' command. Newer versions will default to this new function.

%% Parse inputs

if nargin < 2
    error('WEKALAB:stringsplit:IncorrectArguments', 'Insufficient arguments supplied.');
elseif nargin > 3
    error('WEKALAB:stringsplit:IncorrectArguments', 'Too many arguments supplied.');
end

% 
if ~ischar(string)
    disp(string)
    error('WEKALAB:stringsplit:InvalidArgument', 'String must be a string!');
    
end

%
if ~ischar(delimiter)
    error('WEKALAB:stringsplit:InvalidArgument', 'Delimiter must be a char/string!.');  
end


%% Code

% For older versions of string
if exist('strsplit', 'builtin')
   cellArray = strsplit(string, delimiter);
   return;
end


idx = regexp(string, delimiter);

% Create cell array for split values
cellArray = cell(1, length(idx));

% If idx has values 
if not(isempty(idx))
    
    % Add start and end indices 
    idx = [0 idx length(string)+1];

    % For each interval, put it in the cell array
    for i = 1:length(idx)-1;
        cellArray{i} = string(idx(i)+1:idx(i+1)-1);
    end
    
% If no delimiters found, then return the entire string in a cell    
elseif not(isempty(string))    % Presuming it's not empty .. 
    
    cellArray = {string};
    
end
