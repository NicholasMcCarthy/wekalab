function success = wekaOpenJavadocs( classpath )
%WEKAOPENJAVADOCS Opens the Weka javadocs page in the system browser.
%   WEKAOPENJAVADOCS() opens the Weka package javadocs overview in the system
%   browser.
%
%   WEKAOPENJAVADOCS(CLASSPATH) opens the Weka javadocs page for the
%   specified class.
%
%       CLASSPATH   A full and valid Weka classpath.
%
%   Notes:
%       It's difficult to check if the classpath provided is valid, so an
%       error is generally not returned if the page doesn't exist. 
%
%       Also, cannot tell if the classpath is a class or package
%       frame, so only class pages will open correctly. 
%       
%   Examples:
%   
%           % Opens the Weka package overview
%           wekaOpenJavadocs();
%
%           % Opens the Weka javadocs for NaiveBayes
%           wekaOpenJavadocs('weka.classifiers.bayes.NaiveBayes');
%
%   See also MATLAB2WEKA

%% Parse inputs

if exist('classpath', 'var')
    if ~ischar(classpath)
        error('WEKALAB:wekaOpenJavadocs:WrongFormat', 'Classpath argument must be a string.');
    end
else
    classpath = [];
end

%% Code

base_url = 'http://weka.sourceforge.net/doc.stable/';

if ~isempty(classpath)
    page = regexprep(classpath, '\.', '\/');
    url = [base_url page '.html'];
else 
    url = base_url;
end

try
    web(url, '-browser');
catch err
    error('WEKALAB:wekaOpenJavadocs:NetError', 'Error opening ''%s'' Weka javadocs page.', url);
end

success = true;

end

