function success = wekaSaveData( filename, data, type, overwrite )
%WEKASAVEDATA Saves a weka.core.Instances Java object to the specified file.
%   WEKASAVEDATA(FILENAME, DATA) saves the weka.core.Instances DATA to
%   FILENAME as a CSV file, overwriting existing files. 
%
%   WEKASAVEDATA(FILENAME, DATA, TYPE) saves the weka.core.Instances DATA
%   to FILENAME as the specified TYPE, overwriting existing files. 
%   
%   WEKASAVEDATA(FILENAME, DATA, TYPE, OVERWRITE) saves the weka.core.Instances DATA
%   to FILENAME as the specified TYPE file, overwriting if OVERWRITE is true.
%   
%       FILENAME    Filename to save the data to, e.g. 'c:\data\mydata.arff'
%
%       DATA        A weka.core.Instances Java object containing the data
%                   to be written.
%
%       TYPE        Specifies the format of the data structure to write.
%                   Valid types: ARFF, C45, CSV, Database, LibSVM, 
%                   SVMLight, XRFF
%                   NOTE: Some are unimplemented.
%                    
%       OVERWRITE   (Optional) boolean to overwrite existing dataset. Default is true.
%
%
%   Examples:
%       
%       % Saves as CSV file by default.
%       wekaSaveData('mydata.csv', wekaData);
%
%       % Saves data in CSV format.
%       wekaSaveData('mydata.dat', wekaData, 'CSV');
%
%       % Save data in ARFF format, but don't overwrite existing file. 
%       wekaSaveData('mydata.arff', wekaData, 'ARFF', false);
% 
%   See also WEKALOADDATA, MATLAB2WEKA

%% Parse inputs

if nargin < 2
    error('WEKALAB:wekaSaveData:IncorrectArguments', 'Insufficient arguments supplied.');
elseif nargin > 4
    error('WEKALAB:wekaSaveData:IncorrectArguments', 'Too many arguments supplied.');
end

% Set defaults
switch nargin
    case 2
        type = 'CSV';
        overwrite = true;
    case 3
        overwrite = true;
end

 % Check if file exists, overwrite or throw error
if exist(filename, 'file')
    if overwrite
        fprintf('Overwriting existing file at: %s\n', filename);
    else
        error('WEKALAB:wekaSaveData:WriteError', 'Data file at %s already exists, and overwrite is set to FALSE', filename);
    end
end

% Check that data is correct object
if ~isa(data, 'weka.core.Instances')
    error('WEKALAB:wekaSaveData:WrongFormat', 'Data argument must be a weka.core.Instances Java object.');
end

% Check type is valid 
if exist('type', 'var')
    if ~any(strcmpi(type, {'ARFF', 'CSV', 'C45', 'DATABASE', 'LibSVM', 'SVMLight', 'SERIALIZED', 'XRFF'}))
          error('WEKALAB:wekaSaveData:InvalidArgument', 'Invalid type ''%s'' supplied.', type);
    end
end

%% Code

% Set Loader from type
if strcmpi(type, 'CSV')
    saver = weka.core.converters.CSVSaver();
elseif strcmpi(type, 'ARFF')
    saver = weka.core.converters.ArffSaver();
elseif strcmpi(type, 'C45')
    saver = weka.core.converters.C45Saver();
elseif strcmpi(type, 'LIBSVM')
    saver = weka.core.converters.LibSVMSaver();
elseif strcmpi(type, 'XRFF')
    saver = weka.core.converters.XRFFSaver();
elseif strcmpi(type, 'SVMLIGHT')
    saver = weka.core.converters.SVMLightSaver();
elseif strcmpi(type, 'DATABASE') 
    error('WEKALAB:wekaSaveData:TypeUnimplemented', 'DATABASE type not implemented.');
elseif strcmpi(type, 'SERIALIZED')
    error('WEKALAB:wekaSaveData:TypeUnimplemented', 'SERIALIZED type not implemented.');
else
    % shouldn't reach here either 
    error('WEKALAB:wekaSaveData:InvalidType', 'Invalid type ''%s'' supplied.', type);
end

saver.setInstances(data);
   
try
    saver.setFile(java.io.File(filename));
    saver.writeBatch();
catch err
    error('WEKALAB:wekaSaveData:WriteError', 'Error writing data file %s.' , filename);
end

success = true;
end

