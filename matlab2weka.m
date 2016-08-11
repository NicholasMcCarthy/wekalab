function instances = matlab2weka(name, attributes, data, labels)
%MATLAB2WEKA Converts Matlab data to weka.core.Instances object.
%   D = MATLAB2WEKA(NAME, ATTRIBUTES, DATA, LABELS) converts an n-by-d cell or numeric matrix 
%   into a weka.core.Instances java object for use by Weka functions. 
% 
%       NAME        A string naming the data/relation 
%       ATTRIBUTES  A cellstr array of d strings, naming each feature/attribute
%       DATA        An n-by-d matrix with n, d-featured examples or a cell
%                   array of the same dimensions if string values are
%                   present. You cannot mix numeric and string values within
%                   the same column. 
%       LABELS      An (OPTIONAL) array of size n indicating the label of each observation. 
%       /CLASSINDEX Can be numeric, character or cell array of values. 
%                   ALTERNATIVELY, sets the column index in the supplied data matrix 
%                   of the target labels. If no option is specified, the last column
%                   will be used by default. Use the matlab convention of indexing from 1.
%
%   Notes:
%       Class attribute will be nominal if LABELS vector is supplied, even
%       if values are numeric. 
%       Labels supplied as part of the data matrix and specified using the
%       CLASSINDEX alternate argument will be numeric,
%
%   Examples:
%
%       % Random data with labels {1,2}
%       data = [rand(10,4) repmat(1:2,1,5)'];
%       wekaData = matlab2weka('random data', {'attr1', 'attr2', 'attr3', 'attr4', 'label'}, data, 5); 
%       
%   See also WEKA2MATLAB, WEKALOADDATA
    
%% Parse and sanitize input arguments

% Check weka path
% if ~wekaPathCheck,instances = []; return,end

% Check nargin
if (nargin < 3)
    error('WEKALAB:matlab2weka:MissingArguments', 'Missing input arguments.');
end 

% Check feature labels
if (size(data, 2) ~= numel(attributes))
    error('WEKALAB:matlab2weka:InconsistentDimensions', 'Inconsistent data and attribute dimensions.');
end

% If labels/classIndex is not supplied
if (nargin == 3)
    classIndex = numel(attributes); % compensate for 0-based indexing later
end

% labels/classIndex is supplied
if (nargin == 4)
    if numel(labels) == 1
        classIndex = labels; % i.e. a classIndex was supplied 
    else
        classIndex = [];
        
        if size(data, 1) ~= numel(labels) 
            error('WEKALAB:matlab2weka:InconsistentDimensions', 'Inconsistent data and label dimension.');
        end
        
        % Convert labels to cellstr 
        if ~iscellstr(labels)
            if ~isnumeric(labels)
                labels = cellstr(labels);
            else
                labels = cellstr(num2str(labels));
            end
        end
        
    end
end
    
%% Code

fastVector = weka.core.FastVector();
instances = weka.core.Instances(name,fastVector,size(data,1));

% CELL MATRIX
if iscell(data)         
    
    % ADDING ATTRIBUTES
    for i = 1:numel(attributes)
        
        % if first data point is char
        if ischar(data{1,i})
            
            % Collect unique strings and add to values vector
            attvals = unique(data(:,i)); 
            values = weka.core.FastVector();
            
            for j = 1:numel(attvals)
               values.addElement(java.lang.String(attvals{j}));
            end
            
            % Add new attribute with nominal values
            fastVector.addElement(weka.core.Attribute(attributes{i},values));
        else
            % Otherwise add attribute 
            fastVector.addElement(weka.core.Attribute(attributes{i})); 
        end
    end 
    
    % ADDING OBSERVATIONS
    for i = 1:size(data,1)
         
        % Create new instance with d attributes
        inst = weka.core.Instance(numel(attributes));
        
        % Set values of instance for each attribute
        for j = 0:numel(attributes)-1
           inst.setDataset(instances);
           inst.setValue(j,data{i,j+1});
        end
        
        % Add created instance to instances
        instances.add(inst);
    end
    
% NUMERIC MATRIX
else 
    
    % ADDING ATTRIBUTES
    for i = 1:numel(attributes)
        fastVector.addElement(weka.core.Attribute(attributes{i})); 
    end
    
    % ADDING OBSERVATIONS
    for i = 1:size(data,1)
        instances.add(weka.core.Instance(1,data(i,:))); % instance weight is 1
    end
    
end

% ADDING LABELS VECTOR 
if isempty(classIndex)    % i.e. if labels vector was supplied
    
    % Create class attribute
    attvals = unique(labels); 
    values = weka.core.FastVector();
    
    for j = 1:numel(attvals)
       values.addElement(java.lang.String(attvals{j}));
    end
    
    classAttribute = weka.core.Attribute('class', values);
    
    % Insert attribute at end of instances and set as class index
    instances.insertAttributeAt(classAttribute, instances.numAttributes());
    idx = instances.numAttributes() - 1;
    instances.setClassIndex(idx);
    
    % Set target values from supplied labels vector
    for i = 1:numel(labels)
        instances.instance(i-1).setValue(idx, labels{i});
    end
    
else 
    % Otherwise set the last column to be class index
    instances.setClassIndex(classIndex-1);
end


end