function data = wekaLoadData( filename, type, options )
%WEKALOADDATA Load data from an input source into a weka.core.Instances object.
%   D = WEKALOADDATA(FILENAME) loads the data from the filename into a
%   weka.core.Instances object. 
%
%   D = WEKALOADDATA(FILENAME, TYPE) loads the data from the filename using
%   the specified type.
%
%   D = WEKALOADDATA(FILENAME, TYPE, OPTIONS) loads the data from the filename using
%   the specified type with loader options.
%
%       TYPE        A string indicating the format of the data being loaded. 
%                   Valid types: ARFF, C45, CSV, Database, LibSVM, 
%                   SVMLight, TextDirectory, XRFF
%
%                   If no type is provided, attempts to determine structure of data 
%                   from filename postfix. '.dat' and '.scale' are presumed to be LibSVM
%                   formats.
%
%       OPTIONS     (Optional) string passing instructions to the loader.
%                   See Weka documentation for further detail.
%   Examples:
%
%       % Will detect loader to use from filename
%       D = wekaLoadData('samples/iris.csv');
% 
%       D = wekaLoadData('samples/iris.csv', 'CSV');
% 
%       D = wekaLoadData('samples/iris.arff', 'ARFF');        
%
%   See also MATLAB2WEKA, WEKASAVEDATA

%% Parse inputs

if nargin < 1
    error('WEKALAB:wekaLoadData:IncorrectArguments', 'Insufficient arguments supplied.');
elseif nargin > 3
    error('WEKALAB:wekaLoadData:IncorrectArguments', 'Too many arguments supplied.');
end

% Check file exists
if ~exist(filename, 'file')
     error('WEKALAB:wekaLoadData:FileNotFound', 'File ''%s'' not found.', filename);
end

% Check type is valid 
if exist('type', 'var')
    if ~any(strcmpi(type, {'ARFF', 'CSV', 'C45', 'DATABASE', 'LibSVM', 'SVMLight', 'SERIALIZED', 'TextDirectory', 'XRFF'}))
          error('WEKALAB:wekaLoadData:InvalidArgument', 'Invalid type ''%s'' supplied.', type);
    end
end

% Check options string is string
if exist('options', 'var')
    if ~ischar(options)
         error('WEKALAB:wekaLoadData:InvalidArgument', 'Options argument must be a string.');
    end
end

%% Code

import java.io.File;

% Attempt to detect type from filename
if ~exist('type', 'var')
    if ~isempty(strfind(filename, 'csv'))
       type = 'CSV'; 
       disp('Detected CSV file from filename.');
    elseif ~isempty(strfind(filename, 'arff'))
       type = 'ARFF'; 
       disp('Detected ARFF file from filename.');
    elseif ~isempty(strfind(filename, 'c45'))
       type = 'C45'; 
       disp('Detected C45 file from filename.');
    elseif ~isempty(strfind(filename, 'scale'))
       type = 'LIBSVM';
       disp('Detected LIBSVM file from filename.');
    elseif ~isempty(strfind(filename, 'dat'))
       type = 'LIBSVM';
       disp('Detected LIBSVM file from filename.');
    elseif ~isempty(strfind(filename, 'xrff'))
       type = 'XRFF'; 
       disp('Detected XRFF file from filename.');
    else
        % Should never reach here .. 
        error('WEKALAB:wekaLoadData:InvalidType', 'Invalid type ''%s'' supplied.', type);
    end    
end

% Set Loader from type
if strcmpi(type, 'CSV')
    loader = weka.core.converters.CSVLoader();
elseif strcmpi(type, 'ARFF')
    loader = weka.core.converters.ArffLoader();
elseif strcmpi(type, 'C45')
    loader = weka.core.converters.C45Loader();
elseif strcmpi(type, 'LIBSVM')
    loader = weka.core.converters.LibSVMLoader();
elseif strcmpi(type, 'XRFF')
    loader = weka.core.converters.XRFFLoader();
elseif strcmpi(type, 'SVMLIGHT')
    loader = weka.core.converters.SVMLightLoader();
elseif strcmpi(type, 'DATABASE') 
    error('WEKALAB:wekaLoadData:TypeUnimplemented', 'DATABASE type not implemented.');
elseif strcmpi(type, 'TEXTDIRECTORY')
    error('WEKALAB:wekaLoadData:TypeUnimplemented', 'TEXTDIRECTORY type not implemented.');
elseif strcmpi(type, 'SERIALIZED')
    error('WEKALAB:wekaLoadData:TypeUnimplemented', 'SERIALIZED type not implemented.');
else
    % shouldn't reach here either 
    error('WEKALAB:wekaLoadData:InvalidType', 'Invalid type ''%s'' supplied.', type);
end

% Test type of loader
loader.setFile(File(filename));
data = loader.getDataSet();
data.setClassIndex(data.numAttributes -1);

end

