function C = wekaCluster( data, clusterer, options )
%WEKACLUSTER Performs clustering on Weka data
%   C = WEKACLUSTER(DATA, CLUSTERER, OPTIONS) returns a weka.clusterers.*
%       Java object that has been built on DATA using the supplied
%       CLUSTERER.
%
%       DATA        A weka.core.Instances object holding the data to be
%                   clustered.
%
%       CLUSTERER   Name or classpath to a valid Weka clusterer, e.g.
%                   'SimpleKMeans' or 'weka.clusterers.SimpleKMeans'.
%
%       OPTIONS     (Optional) string or cell array of strings with options specific
%                   to the clusterer. See the Weka documentation for further
%                   detail.
%
%   Notes: 
%       Weka clusterers will throw an error if class attribute is present,
%       the following code will remove any class attribute:
%       D = wekaApplyFilter(D, 'unsupervised.attribute.Remove', {'-R', num2str(D.classIndex+1)});
%   
%   Examples:
%
%           % K-means clustering with K=3
%           KM = wekaCluster(D, 'SimpleKMeans', '-N 3');
%
%           % Expectation Maximization with verbose output
%           EM = wekaCluster(D, 'EM', '-V');
%
%   See also WEKACLASSIFY

%% Parse inputs

if nargin < 2
    error('WEKALAB:wekaCluster:IncorrectArguments', 'Insufficient arguments supplied.');
elseif nargin > 3
    error('WEKALAB:wekaCluster:IncorrectArguments', 'Too many arguments supplied.');
end

% Set defaults
if ~exist('options', 'var')
    options = [];
end

% Check that data is correct object
if ~isa(data, 'weka.core.Instances')
    error('WEKALAB:wekaCluster:WrongFormat', 'Data argument must be a weka.core.Instances Java object.');
end

% Check that data has no class attribute (otherwise clusterer will throw
% error anyway)

if data.classIndex ~= -1
    error('WEKALAB:wekaCluster:DataHasClassAttribute', 'Data argument has class attribute which must be removed prior to clustering. (See help ''wekaCluster'' notes)');
end

% Check clusterer string
if ischar(clusterer)
    if isempty(strfind(clusterer, 'weka.clusterers'))
        clusterer = ['weka.clusterers.', clusterer];
    end
else
    error('WEKALAB:wekaCluster:InvalidArgument', 'Clusterer argument must be a string.');
end


% Check clusterer options and convert to cellstr
if ~isempty(options)
    if ischar(options) 
        options = stringsplit(options, ' ');
    elseif ~iscellstr(options)
        error('WEKALAB:wekaFilter:InvalidArgument', 'Clusterer options argument must be a string or cellstr.');
    end
end


%% Code

C = javaObject(clusterer);

if ~isempty(options)
    C.setOptions(options);
end

C.buildClusterer(data);



end

