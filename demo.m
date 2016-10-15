% This file demonstrates the functions in the WekaLAB package by way of
% example. 
% 
% Last updated: 11 Aug 2016
% Author: Nicholas McCarthy <nicholas.mccarthy@gmail.com>

%% Check weka.jar is in Matlab classpath

if wekaPathCheck()
    disp('Weka.jar is loaded!');
end

%% Open Weka javadocs in system browser

if wekaOpenJavadocs()
    disp('Opened Weka javadocs in system browser.');
end

%% Open class page in system browser

wekaOpenJavadocs('weka.classifiers.bayes.NaiveBayes');

%% WEKALOADDATA

% Read a CSV dataset
D = wekaLoadData('samples/SupremeCourt.csv');

% Read an ARFF dataset
D = wekaLoadData('samples/iris.arff');


%% MATLAB2WEKA : Generate random data
%            
%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   % NOTE: Variables generated here are used in the next few examples! %
%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Generate random data
numData = 100;
numAttributes = 10;
numClasses = 3;

relation    = 'random data';
attributes  = arrayfun(@(x) {['attribute_' num2str(x)]}, 1:numAttributes);
labels      = repmat(1:numClasses, 1, ceil(numData/numClasses))'; 
data        = rand(numData,numAttributes);

labels = labels(1:size(data,1)); % ensure labels correct length .. 

%% MATLAB2WEKA : Convert numeric data using labels vector

D = matlab2weka(relation, attributes, data, labels);

%% MATLAB2WEKA : Convert numeric data specifying class index (labels must be numeric)

% Append 'class' to attributes vector, and append labels vector column-wise
attributes2 = [attributes 'class'];
data2 = [data labels];

D = matlab2weka(relation, attributes2, data2, numel(attributes2));

%% MATLAB2WEKA : Convert cell data using labels vector

data2 = num2cell(data);

D = matlab2weka(relation, attributes, data2, labels);

%% MATLAB2WEKA : Convert cell data specifying class index 

% Convert random data to cell matrix and append labels
data2 = horzcat(num2cell(data), num2cell(labels));
attributes2 = [attributes 'class'];

% NOTE: Class attribute will be numeric
D = matlab2weka(relation, attributes2, data2);

%% MATLAB2WEKA : Convert cell data using class index with alpha labels

% Convert labels from numeric to letters.
alphabet = 'abcdefghijklmnopqrstuvwxyz';
alpha_labels = arrayfun(@(x) alphabet(x), labels);

% Convert random data to cell matrix and append labels

data2 = horzcat(num2cell(data), num2cell(alpha_labels));
attributes2 = [attributes 'class'];

% NOTE Class attribute will be nominal
D = matlab2weka(relation, attributes2, data2);

%% MATLAB2WEKA : Convert Matlab's builtin fisheriris dataset to weka data format

load fisheriris; 

D = matlab2weka('fisheriris', {'sepallength','sepalwidth','petallength','petalwidth'}, meas, species);

%% WEKA2MATLAB : Convert weka.core.Instances object instances object to Matlab cell array

D = wekaLoadData('samples/iris.arff');

[data,attributes,targetIndex,stringVals,relationName] = weka2matlab(D,{});


%% WEKA2MATLAB : Convert weka.core.Instances object instances object to Matlab numeric array
% NOTE: The class values in Numeric values in returned 'data' refer

D = wekaLoadData('samples/iris.arff');

[data,attributes,targetIndex,stringVals,relationName] = weka2matlab(D,[]);

%% WEKASAVEDATA : Save data to csv file

D = wekaLoadData('samples/iris.arff');

wekaSaveData('samples/test.csv', D);
wekaSaveData('samples/test.csv', D, 'CSV');
wekaSaveData('samples/test.arff', D, 'ARFF');
wekaSaveData('samples/test.xrff', D, 'XRFF');

%% Train a Naive Bayes classifier and save it to disk

% Load dataset
D = wekaLoadData('samples/iris.arff');

% Training Naive Bayes model on Iris dataset
naiveBayes = wekaTrainModel(D,'bayes.NaiveBayes');

% Save model
wekaSaveModel('samples/iris_naivebayes.model', naiveBayes);

% Load model 
loadedModel = wekaLoadModel('samples/iris_naivebayes.model');

%% Train a J48 Decision Tree and save it to disk

% Load dataset
D = wekaLoadData('samples/iris.arff');

% Training J48 Decision Tree on Iris dataset
j48tree = wekaTrainModel(D,'trees.J48');

% Save model
wekaSaveModel('samples/iris_j48.model', j48tree);

%% Train a Random Forest with specific options

% Load dataset
D = wekaLoadData('samples/iris.arff');

% Training a Random Forest using two different methods of passing option strings
randomForest1 = wekaTrainModel(D,'trees.RandomForest', '-D -I 20');
randomForest2 = wekaTrainModel(D,'trees.RandomForest', {'-D' '-I' '20'});

%% Train a Support Vector Machine with specific options
% NOTE: libsvm.jar must be added to classpath!
% javaaddpath('path/to/libsvm.jar');

% Load dataset
D = wekaLoadData('samples/iris.arff');

% Train SVM with specified options ..
svmModel = wekaTrainModel(D,'functions.LibSVM',{'-B' '1' '-C' '10' '-G' '1'});

%% Train GaussianProcesses model 

D = wekaLoadData('samples/SupremeCourt.csv');

% Split to test and train ..
myFilter = wekaFilter('supervised.instance.StratifiedRemoveFolds', '-N 5 -F 1');

myFilter.setInputFormat(D);
test = myFilter.useFilter(D, myFilter);

myFilter.setInvertSelection(true);
train = myFilter.useFilter(D, myFilter);

% Train Gaussian Processes model
gmModel = wekaTrainModel(train,'functions.GaussianProcesses');

[~,Y] = wekaClassify(test, gmModel);


%% Regression with SMOreg

D = wekaLoadData('samples/iris.arff', 'ARFF');

% Remove nominal class value and set a class attribute (toy example anyway .. )
D = wekaApplyFilter(D, 'unsupervised.attribute.Remove', {'-R', num2str(D.classIndex+1)});
D.setClassIndex(3); % The petalwidth attribute

% Train SMO regressor
smoModel = wekaTrainModel(D,'functions.SMOreg');

% Regression using petalwidth as the target 
[~,Y] = wekaClassify(D,smoModel);

%% WEKAAPPLYFILTER : Methods for applying a filter to data

D = wekaLoadData('samples/iris.arff');

% -----------  Method 1 : Supplying filter object to wekaApplyFilter()

% Create reusable filter object
myFilter = wekaFilter('supervised.instance.Resample', '-Z 200');

% Apply it to data 
[E, filt] = wekaApplyFilter(D, myFilter);

% ----------- Method 2 : Supplying filter classpath to wekaApplyFilter()

% Returned 'filt' object is same as myFilter from Method 1 as
% wekaApplyFilter makes use of wekaFilter
[E, filt] = wekaApplyFilter(D, 'supervised.instance.Resample', '-Z 200');

% -----------  Method 3 : Using filter object directly (if you really must)

myFilter = wekaFilter('supervised.instance.Resample', '-Z 200');
myFilter.setInputFormat(D);
E = myFilter.useFilter(D, myFilter);

%% Generate an 80:20 train:test split (Method 1)

D = wekaLoadData('samples/iris.arff');

myFilter = wekaFilter('supervised.instance.StratifiedRemoveFolds', '-N 5 -F 1');

myFilter.setInputFormat(D);
test = myFilter.useFilter(D, myFilter);

myFilter.setInvertSelection(true);
train = myFilter.useFilter(D, myFilter);

% Train model
model = wekaTrainModel(train, 'bayes.NaiveBayes');

% Test model
[predicted, classProbs, confusionMatrix] = wekaClassify(test,model);

%% Generate an 80:20 train:test split (Method 2)
% Simpler and more readable, but must ensure that the same random seed is used to
% split the data.

D = wekaLoadData('samples/iris.arff');

train  = wekaApplyFilter(D, 'supervised.instance.StratifiedRemoveFolds', '-N 5 -F 1 -S 1998 -V');
test = wekaApplyFilter(D, 'supervised.instance.StratifiedRemoveFolds', '-N 5 -F 1 -S 1998');

% Train model
model = wekaTrainModel(train, 'bayes.NaiveBayes');

% Test model
[predicted, classProbs, confusionMatrix] = wekaClassify(test,model);

%% N-fold cross-validation

D = wekaLoadData('samples/iris.arff');

% Number of folds
N = 5;

% Pre-allocate error array
errors = zeros(1,N); 

% Stratifies a set of instances according to its class values if the class 
% attribute is nominal (so that afterwards a stratified cross-validation can be performed).
D.stratify(N);

% Alternatively, randomize the data
% D.randomize(java.util.Random(1998));

for i = 1:N
   
    test = D.testCV(N, i-1);
    train = D.trainCV(N, i-1);
    
    % Train model 
    model = wekaTrainModel(train, 'bayes.NaiveBayes');

    % Classify test data 
    [predicted, classProbs, confusionMatrix] = wekaClassify(test,model);
    
    % The actual class labels
    actual = test.attributeToDoubleArray(test.classIndex);
    
    % Calculate error rate
    errors(i) = sum(actual ~= predicted)/length(actual);
    
end

fprintf('Average error rate of %d folds: %0.4f\n', N, mean(errors));

%% Copying datasets

D = wekaLoadData('samples/iris.arff', 'ARFF');

% Matlab assignment is shallow
E = D;

% Use the constructor copying all instances and references to the header 
% information from the given set of instances.
F = weka.core.Instances(D);

fprintf('D has %d attributes, E has %d attributes, F has %d attributes \n', D.numAttributes(), E.numAttributes(),F.numAttributes());
D.deleteAttributeAt(0);
fprintf('D has %d attributes, E has %d attributes, F has %d attributes  \n', D.numAttributes(), E.numAttributes(),F.numAttributes());

%% Merging datasets (horizontally)

D = wekaLoadData('samples/iris.arff', 'ARFF');

% Resample so both datasets have an equal number of instances
E = wekaApplyFilter(wekaLoadData('samples/SupremeCourt.csv', 'csv'), 'unsupervised.instance.Resample', '-Z 350');

F = D.mergeInstances(E, D);
F.setClassIndex(F.numAttributes()-1);

disp(F.toSummaryString());

%% Appending to datasets (vertical)

D = wekaLoadData('samples/iris.arff', 'ARFF');
E = wekaApplyFilter(D, 'supervised.instance.Resample', '-Z 200');

for i = 0:E.numInstances()-1
   D.add(E.instance(i)); 
end

%% WEKAATTRIBUTESELECTION : Attribute selection examples

D = wekaLoadData('samples/iris.arff', 'ARFF');

% Correlation-based Feature Subset Selection
z = wekaAttributeSelection(D, 'CfsSubsetEval', [], 'GreedyStepwise', []);

% InfoGain attribute evaluation
y = wekaAttributeSelection(D, 'InfoGainAttributeEval', [],  'Ranker', []);

% Symmetrical uncertainty attribute evaluation
x = wekaAttributeSelection(D, 'SymmetricalUncertAttributeEval', [], 'Ranker', []);

% SVM Attribute evaluation
w = wekaAttributeSelection(D, 'SVMAttributeEval', [], 'Ranker', []);

% Principal components
v = wekaAttributeSelection(D, 'PrincipalComponents', [], 'Ranker', []);

% ClassifierSubsetEval (Defaults to weka.classifiers.rules.ZeroR) and
% GreedyStepwise search
u = wekaAttributeSelection(D, 'ClassifierSubsetEval', [], 'GreedyStepwise', []);

% ClassifierSubsetEval (specifying bayes.NaiveBayes -Requires a hold out/test set to
% estimate accuracy on) and GreedyStepwise 
t = wekaAttributeSelection(D, 'ClassifierSubsetEval', '-B weka.classifiers.bayes.NaiveBayes -H samples/iris.arff', ...
                              'GreedyStepwise', []);
 
% ClassifierSubsetEval (specifying bayes.NaiveBayes -Requires a hold out/test set to
% estimate accuracy on) and GreedyStepwise (backward search instead of
% forward)
s = wekaAttributeSelection(D, 'ClassifierSubsetEval', '-B weka.classifiers.bayes.NaiveBayes -H samples/iris.arff', ...
                              'GreedyStepwise', '-B');

% ClassifierSubsetEval (using defaults) and GreedyStepwise (backward search instead of
% forward)
r = wekaAttributeSelection(D, 'ClassifierSubsetEval', [], 'GreedyStepwise', '-B');


%% WEKAATTRIBUTESELECTION : Reduce dataset to features selected by CfsSubsetEval

D = wekaLoadData('samples/iris.arff', 'ARFF');

% Correlation-based Feature Subset Selection
z = wekaAttributeSelection(D, 'CfsSubsetEval', [], 'GreedyStepwise', []);

% Converting attributes to acceptable CLI string ..
% +1 because the Remove filter indexes attributes from 1 but the
% attributeSelection indexes from 0
keep_str = num2str(z.selectedAttributes()' +1); 
keep_str = regexprep(keep_str, '  ', ',');
keep_str = ['-R ' keep_str];

% Invert selection so only selected attributes are kept
options = ['-V ' keep_str];

E = wekaApplyFilter(D, 'unsupervised.attribute.Remove', options);

%% WEKALOADDATA : Lots of different ways to load data files.

% Automatically detects file format from filename
D = wekaLoadData('samples/iris.csv');

% Specifying the file format
D = wekaLoadData('samples/iris.csv', 'CSV');

% Automatic detection from filename only works for a few loaders, or if the
% filename is obvious.
D = wekaLoadData('samples/iris.xrff');
D = wekaLoadData('samples/iris.dat');
D = wekaLoadData('samples/SupremeCourt_svmlight.dat', 'SVMLight');
  
% An error will be thrown if the wrong format is specified, though. 
try
    D = wekaLoadData('samples/iris.xrff', 'CSV');
catch err
    disp('Threw error: attempted to load XRFF file with CSV type.');
end

%% Converting CSV to ARFF

% Load the CSV file
D = wekaLoadData('samples/iris.csv');

% Save it, specifying new filename and ARFF type
if wekaSaveData('samples/iris_test.arff', D, 'ARFF')
    disp('Successfully converted ARFF to CSV.');
end

%% WEKACLUSTER : K-means clustering and notes

D = wekaLoadData('samples/iris.arff', 'ARFF');

% Weka clusterers will throw an error if the class attribute is still
% present in the input data.
try 
    C = wekaCluster(D, 'SimpleKMeans');
catch err
    disp('Error thrown because class attribute still present!');
end


% Remove the class attribute 
D = wekaApplyFilter (D, 'unsupervised.attribute.Remove', {'-R', num2str(D.classIndex+1)});
% this line throw an error if the class attribute is already removed
% because the Remove filter indexes attributes from 1, and if no class
% is set then classIndex() returns -1.

% K Means clustering
KM = wekaCluster(D, 'SimpleKMeans', '-N 3');

% DBSCAN clustering
DB = wekaCluster(D, 'DBSCAN', '-E 0.4');

% Expectation Maximization
EM = wekaCluster(D, 'EM', '-V');

%% Weka classifier with UpdateClassifier

D = wekaLoadData('samples/iris.arff', 'ARFF');

% Use a 80:20 split of initial training and updating samples

train  = wekaApplyFilter(D, 'supervised.instance.StratifiedRemoveFolds', '-N 5 -F 1 -S 1998 -V');
update = wekaApplyFilter(D, 'supervised.instance.StratifiedRemoveFolds', '-N 5 -F 1 -S 1998');

% Train Updateable Naive Bayes model
model = wekaTrainModel(train,'bayes.NaiveBayesUpdateable');

% Display initial model
disp(model)

% Update model 
for i = 0:update.numInstances-1
   model.updateClassifier(update.instance(i))
end

% Display updated model 
disp(model)

