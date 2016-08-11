function [data,attributes,classIndex,stringVals,relationName] = weka2matlab(wekaData,mode)
%WEKA2MATLAB Converts Weka.core.instances object to matlab data structures. 
%   D = WEKA2MATLAB(WEKADATA, MODE) returns a matlab array of Weka
%   instance values.
%   
%       WEKADATA    A weka.core.Instances Java object.
%       
%       MODE        (Optional) [] , {} (default = []) If [], returned data is 
%                   a numeric array and any strings in wekaData are converted 
%                   to their enumerated indices. If {}, data is returned as 
%                   a cell array, preserving any present strings. 
% 
%   [DATA, ATTRIBUTES, CLASSINDEX, STRINGS, RELATION] = WEKA2MATLAB(WEKADATA)
%   returns a data matrix, vector of attribute names, class index
%
%       DATA        An n-by-d matlab numeric or cell array holding the
%                   data, depending on the mode parameter.
%                   
%       ATTRIBUTES  Cell array listing the names of each attribute as they
%                   appear column-wise in the data.
%                   
%       CLASSINDEX  The column index of the target/class. Matlab's 1-based 
%                   indexing is used. 
%
%       STRINGS     Some weka features may be non-numeric. These are
%                   automatically enumerated and the enumerated indices
%                   returned in DATA instead of the string versions, (unless
%                   in cell mode). The corresponding strings are returned in
%                   STRINGS, a cell array of cell arrays. Enumeration
%                   begins at 0. 
%
%       RELATION    String containing the relation name of the data.
%
% Examples:
%
%   % Load 'iris.arff' dataset
%   wekaData = wekaLoadArff('iris.arff');
%
%   % Convert data to matlab array
%   data = weka2matlab(wekaData)
%
%   % Convert data to matlab cell array with associated information
%   [data, attributes, classIndex, stringVals, relationName] = weka2matlab(wekaData, {})
%
% See also MATLAB2WEKA, WEKALOADDATA

%% Parse inputs

if nargin > 3 
    error('WEKALAB:weka2matlab:IncorrectArguments', 'Too many input arguments.');
end


if(nargin < 2)
    mode = [];
else
    if ~xor(iscell(mode), isnumeric(mode))
        error('WEKALAB:weka2matlab:IncorrectArguments', 'Incorrect mode specified');
    end
end

if ~isa(wekaData, 'weka.core.Instances')
    error('WEKALAB:weka2matlab:WrongFormat', 'Data argument must be a weka.core.Instances Java object.');
end


%% Code

% Pre-allocation
data = zeros(wekaData.numInstances, wekaData.numAttributes);
classIndex = wekaData.classIndex + 1;
relationName = char(wekaData.relationName);
attributes = cell(1,wekaData.numAttributes);
stringVals = cell(1,wekaData.numAttributes);

% Copy data 
for i = 0:wekaData.numInstances()-1
    data(i+1,:) = (wekaData.instance(i).toDoubleArray())';
end

% Take attribute names
for i = 0:wekaData.numAttributes()-1

    attributes{i+1} = char(wekaData.attribute(i).name());

    attribute = wekaData.attribute(i);
    
    vals = cell(attribute.numValues(),1);
    for j=0:attribute.numValues()-1
        vals{j+1,1} = char(attribute.value(j));
    end
    stringVals{1,i+1} = vals;    
end


if(iscell(mode))
   celldata = num2cell(data);
   for i=1:numel(stringVals)
      vals = stringVals{1,i};
      if(not(isempty(vals)))
        celldata(:,i) = vals(data(:,i)+1)';
      end
   end
   data = celldata;
end


end