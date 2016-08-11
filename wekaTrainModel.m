function [wekaClassifier] = wekaTrainModel(data,type,options)
%WEKATRAINMODEL Trains a weka classifier on input data. from supplied data
%   M = WEKATRAINMODEL(DATA, TYPE) trains a weka classifier of specified
%   TYPE on the input DATA.
%
%   M = WEKATRAINMODEL(DATA, TYPE, OPPTIONS) trains a weka classifier of specified
%   TYPE with OPTIONS on the input DATA.
%
%       DATA    A weka.core.Instances object holding the training data.
%
%       TYPE    A string naming the type of classifier to train. Full
%               string is not required, e.g.
%               'weka.classifiers.bayes.NaiveBayes' and 'bayes.NaiveBayes'
%               are both valid options.
%
%       OPTIONS (Optional) string or cell array of strings with options specific
%               to the classifier. See the Weka documentation for further
%               detail.
%
% Examples: 
% 
%       wekaClassifier = wekaTrainModel(data,'bayes.NaiveBayes','-D');
% 
%       wekaClassifier = wekaTrainModel(data,'functions.LibSVM',{'-B' '1' '-C' '10' '-G' '1'});
%
% See also MATLAB2WEKA, WEKALOADMODEL

%% Parse Inputs

if nargin < 2
    error('WEKALAB:wekaTrainModel:IncorrectArguments', 'Insufficient arguments supplied.');
elseif nargin > 3
    error('WEKALAB:wekaTrainModel:IncorrectArguments', 'Too many arguments supplied.');
end

% Check wekadata 
if ~isa(data, 'weka.core.Instances')
    error('WEKALAB:wekaTrainModel:WrongFormat',  'Data argument must be a weka.core.Instances Java object.');
end

% Check type string
if ischar(type)
    if isempty(strfind(type, 'weka.classifiers'))
        type = ['weka.classifiers.', type];
    end
else
    error('WEKALAB:wekaTrainModel:WrongFormat',  'Options argument must be a string.');
end


% Check option string
if exist('options', 'var')
    if ischar(options)
        options = stringsplit(options, ' ');
    else
        if ~iscellstr(options)
            error('WEKALAB:wekaTrainModel:InvalidArgument',  'Options argument must be char or cellstr.');
        end
    end
else
    options = [];
end

%% Code

wekaClassifier = javaObject(type);

if ~isempty(options)
    wekaClassifier.setOptions(options);
end

wekaClassifier.buildClassifier(data);
    
end