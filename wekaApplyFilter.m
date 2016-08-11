function [filteredData,filter] = wekaApplyFilter( data, filter, options )
%WEKAAPPLYFILTER Apply a Weka filter to an Instances object.
%   E = WEKAAPPLYFILTER(DATA, FILTER) Applies the named filter to the data D.
%
%   E = WEKAAPPLYFILTER(DATA, FILTER, OPTIONS) Applies the named filter or weka.filters.*
%   object FILTER to DATA with the supplied OPTIONS. 
%  
%   [E, FILTER] = WEKAAPPLYFILTER(DATA, FILTER, OPTIONS) Applies the named filter or weka.filters.*
%   object FILTER to DATA with the supplied OPTIONS, returning the filter
%   used. Useful if only a named filter is supplied.
%
%       DATA        A weka.core.Instances object holding the data to be filtered. 
%
%       FILTER      A weka.filters.* object OR a classpath to valid Weka filter. 
%                   e.g. 'weka.filters.supervised.instance.Resample'
%                   NOTE: The 'weka.filters.' is optional.
%
%       OPTIONS     (Optional) string containing the options for FILTER. See Weka
%                   documentation for further detail. 
% 
%   Examples:
%
%       % Apply resample filter with options -S <randomseed> and -Z <resample percentage>
%       filteredData = wekaApplyFilter(wekaData, 'supervised.instance.Resample', '-S 1014 -Z 200')
%   
%       % Apply resample filter using predefined filter object
%       myFilter = wekaFilter('supervised.instance.Resample', '-Z 200');
%       filteredData = wekaApplyFilter(wekaData, myFilter);
%
%       % Standardize data to zero mean and unit variance
%       filteredData = wekaApplyFilter(wekaData, 'unsupervised.attribute.Standardize');
% 
% See also WEKAFILTER

%% Parse and sanitize input arguments

if nargin < 2
    error('WEKALAB:wekaApplyFilter:IncorrectArguments', 'Insufficient arguments supplied.');
elseif nargin > 3
    error('WEKALAB:wekaApplyFilter:IncorrectArguments', 'Too many arguments supplied.');
end

if nargin == 2
    options = [];
end

% Check that data is correct object
if ~isa(data, 'weka.core.Instances')
    error('WEKALAB:wekaApplyFilter:WrongFormat', 'Data argument must be a weka.core.Instances Java object.');
end

% Check type string
if ischar(filter)
    if isempty(strfind(filter, 'weka.filters'))
        filter = ['weka.filters.', filter];
    end
elseif isempty(regexp(class(filter), 'weka.filters', 'once'))
    error('WEKALAB:wekaApplyFilter:InvalidArgument', 'Filter argument is ''%s'' instead of a string or weka.filters.* object', class(model));
end
    
%% Code

if ischar(filter)
    filterObj = wekaFilter(filter, options);
else
    filterObj = filter;
end

filterObj.setInputFormat(data);

filteredData = filterObj.useFilter(data, filterObj);

end
