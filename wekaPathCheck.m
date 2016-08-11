function bool = wekaPathCheck()
%WEKAPATHCHECK Checks the weka.jar file has been added to Matlab classpath,
% throws an error if not found. 
% 
% Add this line to to the classpath.txt file and restart matlab:
%
%   'C:\path\to\Weka-X-Y\weka.jar' (Windows)
%   '/path/to/Weka-X-Y/weka.jar'   (Linux)
%    
% Replace 'X-Y' as necessary depending on the version. (To edit type 'edit classpath.txt').
% 
% Alternatively, weka can be added to the classpath in matlab scripts using:
%       
%   javaaddpath('/path/to/Weka-X-Y/weka.jar')

w = strfind(javaclasspath('-all'),'weka.jar');

if ~any(cellfun(@(x) ~isempty(x), w))
    error('WEKALAB:wekaPathCheck:PathNotFound', 'Weka.jar not found in Matlab class path. See ''help wekaPathCheck''');
end

bool = 1;

end