function [predicted, probabilities, confusionMatrix] = wekaClassify(data,model)
%WEKACLASSIFY Classifies the input data using the classifier supplied.
%   Y = WEKACLASSIFY(DATA, CLASSIFIER) returns the predicted labels of the
%   supplied DATA
%       
%       DATA        A weka.core.Instances object holding the data to be
%                   classified.
%
%       MODEL       A weka.classifiers.* object.
%
%   [PREDICTIONS,PROBABILIITES,CONFUSIONMATRIX] = WEKACLASSIFY(DATA, CLASSIFIER)
%   returns the predicted labels, probabilities and confusion matrix (if
%   applicable) of the supplied DATA.
%
%       PREDICTIONS     A d numeric array giving the maximum probability
%                       label predicted.
%       
%       PROBABILITIES   An n x d numeric array giving the probabilities of 
%                       each instance belonging to each class. 
%                       PROBABILITIES(i,j) is the probability that instance i is 
%                       in class j. Classes are indexed from 0 and if originally 
%                       nominal, the returned values represent the enumerated indices. 
%
%       CONFUSIONMATRIX 
%   Examples:
%           
%           D = wekaData loaded from somewhere .. 
%           myModel = weka model loaded from somewhere ..
%           testData = wekaData loaded from somewhere ..            
%
%           [predicted,probabilities,confusionmatrix] = wekaClassify(testData, myModel);
%
%   See also WEKATRAINMODEL, WEKALOADMODEL

%% Parse inputs 

if nargin < 2
    error('WEKALAB:wekaClassify:IncorrectArguments', 'Insufficient arguments supplied.');
elseif nargin > 2
    error('WEKALAB:wekaClassify:IncorrectArguments', 'Too many arguments supplied.');
end

% Check data
if ~isa(data, 'weka.core.Instances')
    error('WEKALAB:wekaClassify:WrongFormat',  'Data argument must be a weka.core.Instances Java object.');
end
    
% Check that model is a weka classifier object. Otherwise throw an error.
if isempty(regexp(class(model), 'weka.classifiers', 'once'))
    error('WEKALAB:wekaClassify:InvalidArgument', 'Model argument is ''%s'' instead of a weka.classifiers.* object', class(model));
end

%% Code

% Pre-allocate
probabilities = zeros(data.numInstances(), data.numClasses());

% Get 
for t = 0:data.numInstances()-1
   probabilities(t+1,:) = (model.distributionForInstance(data.instance(t)))';
end

[~,predicted] = max(probabilities,[],2);

% Subtract 1 for 0-based indexing of classes
predicted = predicted - 1;

confusionMatrix = confusionmat(predicted, (data.attributeToDoubleArray(data.classIndex)));  

end