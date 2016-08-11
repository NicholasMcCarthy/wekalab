function modelObj = wekaLoadModel( filename )
%LOADWEKAMODEL Loads a Weka classifier from a file. 
%   MODEL = WEKALOADMODEL(FILENAME)
%
%       FILENAME    The path to the weka.classifiers.* Java object.    
% 
%   NOTE: It is possible to use models created using Weka explorer provided the 
%       models have been saved using weka.core.SerializationHelper (or 
%       equivalent outputstream).
%
%   Examples:
%
%       myModel = wekaLoadModel('/path/to/mymodel.mdl');
%
%   See also WEKASAVEMODEL, WEKATRAINMODEL

%% Parse inputs

if ~exist(filename, 'file')
    error('WEKALAB:wekaLoadModel:FileNotFound', 'No file found at %s', filename);
end

%% Code

try
    modelObj = weka.core.SerializationHelper.read(filename);
catch err
    error('WEKALAB:wekaLoadModel:ReadError', 'Error reading model file at %s', filename);
end
    
end
