function success = makeHistogram(detector,scatterRange,type,nbins,xlimits)
% function success = makeHistogram(detector,nbins,type,xlimits)
%       
%   This function makes a histogram from the frequencies, which can be 
%   converted to vacuum wavelengths, collected from checkDetector. A 
%   histogram is first made from all the data collected and then a second 
%   histogram is made from the data just generated by rayBundleB1 and then 
%   overlaid on the first histogram.
%
%       detector - the detector structure containing the data to be made
%                  into a histogram
%   scatterRange - string containing the scatter range to be used in the
%                  title of the histogram, i.e '80:1:100', '-90',
%                  '20:10:180'
%           type - type of x-axis ['freq'(frequency) or 'lambda'(wavelength)
%          nbins - number of bins desired for the x-axis
%        xlimits - a 1x2 row vector containing the desired start and end
%                  value of the x-axis [start end]

% Last edited by: SMH 13/AUG/2020
global cnst

if ~exist('type','var')
    type = 'lambda'; % sets default x-axis type to wavelength
end

% Creates a row vector of frequencies generated by rayBundleB1
B1 = [detector.sourceParams(:,2)] == 1;
freqB1 = [detector.frequencies{B1,:}];

% makeHistogram for a wavelength histogram
if strcmp(type,'lambda')
    if ~exist('nbins','var')
        nbins = 41; % sets the default number of bins so that the bin size is 10nm
    end
    
    if ~exist('xlimits','var')
        xlimits = [350 750]; % sets default x-axis range to 350-750nm
    end
    
    binSize = (xlimits(2)-xlimits(1))/(nbins-1);
    edges = [xlimits(1):binSize:xlimits(2)];
    
    lambda = (10^9)*(cnst.twopi)*(cnst.c)./detector.histogram;
    lambdaB1 = (10^9)*(cnst.twopi)*(cnst.c)./freqB1;
    
    figure
    hold on
    histogram(lambda,edges)
    histogram(lambdaB1,edges)
    xlabel('Wavelength [nm]')
    ylabel('# of Rays at Detector')
    title(['Raman Scatter Angle: ', scatterRange])
    legend('+23 Degree Incident Beam','-23 Degree Incident Beam')
    
% makeHistogram for a frequency histogram
elseif strcmp(type,'freq')
    if ~exist('nbins','var')
        nbins = 61; % sets the default number of bins so that the bin size is 50e12 rad/s
    end
    
    if ~exist('xlimits','var')
        xlimits = [2.5e15 5.5e15]; % sets default x-axis range to 2.5e15-5.5e15 rad/s
    end
    
    binSize = (xlimits(2)-xlimits(1))/(nbins-1);
    edges = [xlimits(1):binSize:xlimits(2)];
    
    figure
    hold on
    histogram(detector.histogram,edges)
    histogram(freqB1,edges)
    xlabel('Frequency [rad/s]')
    ylabel('# of Rays at Detector')
    title(['Raman Scatter Angle: ', scatterRange])
    legend('+23 Degree Incident Beam','-23 Degree Incident Beam')
else
    error('Only wavelength(type=lambda) and frequency(type=freq) are allowed')
end
    success = 1;
end