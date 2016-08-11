function success = wekaSaveModel(filename, model, overwrite)
%WEKASAVEMODEL Saves a Weka classifier to file. 
%   WEKASAVEMODEL(FILENAME, MODEL) saves the weka.classifier Model object
%   to the filename specified.
%
%   WEKASAVEMODEL(FILENAME, MODEL, OVERWRITE) saves the weka.classifier Model object
%   to the filename specified, overwriting if set to true.
%
%
%       FILENAME    The path to save the model to.
%
%       MODEL       A weka.classifiers Java object.
%
%       OVERWRITE   (Optional) boolean to overwrite existing model. Default is true.
%
%   Examples: 
%
%        saveWekaModel('/path/to/save/location', mymodel) 
%
%        saveWekaModel('/path/to/save/location', mymodel, false)
% 
%   See also WEKALOADMODEL, WEKATRAINMODEL

%% Parse inputs

if nargin < 2
    error('WEKALAB:wekaSaveModel:IncorrectArguments', 'Insufficient arguments supplied.');
elseif nargin > 3
    error('WEKALAB:wekaSaveModel:IncorrectArguments', 'Too many arguments supplied.');
end

% Set defaults
if nargin < 3
    overwrite = true;   % Default is to overwrite
end

% Check if file exists, overwrite or throw error
if exist(filename, 'file')
    if overwrite
        fprintf('Overwriting existing file at: %s\n', filename);
    else
        error('WEKALAB:wekaSaveModel:WriteError', 'Model file at %s already exists and overwrite is set to FALSE', filename);
    end
end

% Check that model is a weka classifier object. Otherwise throw an error.
if isempty(regexp(class(model), 'weka.classifiers', 'once'))
    error('WEKALAB:wekaSaveModel:InvalidArgument', 'Model argument is ''%s'' instead of a weka.classifiers.* object', class(model));
end

%% Try writing the object, or throw error. 

try 
    weka.core.SerializationHelper.write(filename, model);
catch err
    error('MATLAB:wekaSaveModel:WriteError', 'Error writing model file %s', filename);
end

success = true;
end

