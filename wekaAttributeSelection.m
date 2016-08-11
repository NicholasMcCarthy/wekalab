function attSel = wekaAttributeSelection( data, evaluator, evaluator_options, search, search_options )
%WEKAATTRIBUTESELECTION Performs attribute selection on Weka data.
%   A = wekaAttributeSelection(DATA, EVALUATOR, EVALUATOR_OPTIONS, SEARCH,
%   SEARCH_OPTIONS) returns a weka.attributeSelection.AttributeSelection
%   Java object with attribute selection performed on DATA.
%   
%       DATA                A weka.core.Instances object holding the data to
%                           perform attribute selection on.
%
%       EVALUATOR           Name or classpath for a valid Weka attribute
%                           selection evaluator, e.g. 'CfsSubsetEval' or
%                           'weka.attributeSelection.CfsSubsetEval'.
%
%       EVALUATOR_OPTIONS   String or cellstr of valid options for the
%                           evaluator. See Weka documentation for further
%                           detail. 
%
%       SEARCH              Name or classpath for a valid Weka search
%                           strategy, e.g. 'Ranker' or
%                           'weka.attributeSelection.Ranker'.
%
%       SEARCH_OPTIONS      String or cellstr of valid options for the
%                           searcher. See Weka documentation for further
%                           detail. 
%
%   Examples:
% 
%           % Correlation-based Feature Subset Selection
%           A = wekaAttributeSelection(D, 'CfsSubsetEval', [], 'GreedyStepwise', []);
%
%           % InfoGain attribute evaluation
%           A = wekaAttributeSelection(D, 'InfoGainAttributeEval', [],  'Ranker', []);
% 
%           
%           % ClassifierSubsetEval (specifying bayes.NaiveBayes -Requires a hold out/test set to
%           % estimate accuracy on) and GreedyStepwise (backward search instead of
%           % forward)
%           s = wekaAttributeSelection(D, 'ClassifierSubsetEval', ...
%                                         '-B weka.classifiers.bayes.NaiveBayes -H samples/iris.arff', ...
%                                         'GreedyStepwise', '-B');          
%
%   See also MATLAB2WEKA

%% Parse inputs

if nargin < 4
    error('WEKALAB:wekaAttributeSelection:IncorrectArguments', 'Insufficient arguments supplied.');
elseif nargin > 5
    error('WEKALAB:wekaAttributeSelection:IncorrectArguments', 'Too many arguments supplied.');
end

% Set defaults

if ~exist('evaluator_options', 'var')
    evaluator_options = [];
end

if ~exist('search_options', 'var')
    search_options = [];
end


% Check that data is correct object
if ~isa(data, 'weka.core.Instances')
    error('WEKALAB:wekaAttributeSelection:WrongFormat', 'Data argument must be a weka.core.Instances Java object.');
end

% Check evaluator string
if ischar(evaluator)
    if isempty(strfind(evaluator, 'weka.attributeSelection'))
        evaluator = ['weka.attributeSelection.', evaluator];
    end
else
    error('WEKALAB:wekaAttributeSelection:InvalidArgument', 'Evaluator argument must be a string');
end
    
% Check search string
if ischar(search)
    if isempty(strfind(search, 'weka.attributeSelection'))
        search = ['weka.attributeSelection.', search];
    end
else
    error('WEKALAB:wekaAttributeSelection:InvalidArgument', 'Search argument must be a string');
end

% Check evaluator options and convert to cellstr
if ~isempty(evaluator_options)
    if ischar(evaluator_options) 
        evaluator_options = stringsplit(evaluator_options, ' ');
    elseif ~iscellstr(evaluator_options)
        error('WEKALAB:wekaFilter:InvalidArgument', 'Evaluator options argument must be a string or cellstr');
    end
end

% Check search options and convert to cellstr
if ~isempty(search_options)
    if ischar(search_options) 
        search_options = stringsplit(search_options, ' ');
    elseif ~iscellstr(search_options)
        error('WEKALAB:wekaFilter:InvalidArgument', 'Search options argument must be a string or cellstr');
    end
end

%% Code


evalObj = javaObject(evaluator);
if ~isempty(evaluator_options)
    evalObj.setOptions(evaluator_options);
end

searchObj = javaObject(search);
if ~isempty(search_options)
    searchObj.setOptions(search_options);
end

attSel = weka.attributeSelection.AttributeSelection(); 
attSel.setEvaluator(evalObj);
attSel.setSearch(searchObj);

attSel.SelectAttributes(data);

end