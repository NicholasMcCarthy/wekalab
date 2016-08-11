function filterObj = wekaFilter( filter, options )
%WEKAFILTER Creates a named Weka filter. 
%   F = wekaFilter(FILTER, OPTIONS) returns a weka.filters.* object.
%
%       FILTER      Classpath string for a valid Weka filter.
%                   E.g. 'weka.filters.supervised.instance.Resample'
%                   Note: The 'weka.filters' is optional.
%
%       OPTIONS     (Optional) string for the filter. See Weka
%                   documentation for further detail.
%         
%   Examples:
%
%       myFilter = wekaFilter('supervised.instance.Resample');
%   
%       myFilter = wekaFilter('supervised.instance.Resample', '-Z 0.5');
%
%   See also WEKAAPPLYFILTER

%% Parse inputs

if nargin < 1
    error('WEKALAB:wekaFilter:IncorrectArguments', 'Insufficient arguments supplied.');
elseif nargin > 2
    error('WEKALAB:wekaFilter:IncorrectArguments', 'Too many arguments supplied.');
end

% Set defaults
if nargin == 1
    options = [];
end

% Check filter string
if ischar(filter)
    if isempty(strfind(filter, 'weka.filters'))
        filter = ['weka.filters.', filter];
    end
else
    error('WEKALAB:wekaFilter:InvalidArgument', 'Filter argument must be a string');
end

% Check options and convert to cellstr
if ~isempty(options)
    if ischar(options) 
        options = stringsplit(options, ' ');
    elseif ~iscellstr(options)
        error('WEKALAB:wekaFilter:InvalidArgument', 'Options argument must be a string or cellstr');
    end
end

if isempty(strfind(filter, 'weka.filters'))
    filter = ['weka.filters.' filter];
end
    
%% Code

% Create filter object
filterObj = javaObject(filter);

if ~isempty(options)
    filterObj.setOptions(options);
end

end

