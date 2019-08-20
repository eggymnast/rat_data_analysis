function [low, high] = filter_eeg()%(handles)

sample_rate = 100000;    %handles.filedata.sample_rate;
 

p = path;                                                                  % to restore the path afterwards
disp('Pick the folder with files to analyze');                            % display in command window info about what type of folder you should pick 
filestosort = uigetdir;                                                    % open folder selection dialog box
path(p, filestosort);                                                      % temporarily add random folder to the path to read things about it
tempp = path; 
d     = dir(filestosort); 
filelist = listdlg('PromptString', 'Pick files to sort: ', ...
                    'SelectionMode', 'single',...
                    'ListString', {d.name}); 
               
fname=[filestosort,'/',d(filelist).name];
input=abfload(fname);
EEG = input(:,1,:);
stim = input(:,2,:);

figure; plot(input); title('Trace');

                
stim_start = find(stim(:,1)>0.02);
stim_start = stim_start(1);
sampleRate = 100000; % Hz
lowEnd = 3; % Hz
highEnd = 10; % Hz
filterOrder = 2; % Filter order (e.g., 2 for a second-order Butterworth filter). Try other values too
[b, a] = butter(filterOrder, [lowEnd highEnd]/(sampleRate/2)); % Generate filter coefficients
filteredData = filtfilt(b, a, EEG); % Apply filter to data using zero-phase filtering


lowEnd2 = 25; % Hz
highEnd2 = 60; % Hz

filterOrder = 2; % Filter order (e.g., 2 for a second-order Butterworth filter). Try other values too
[b, a] = butter(filterOrder, [lowEnd2 highEnd2]/(sampleRate/2)); % Generate filter coefficients
filteredData2 = filtfilt(b, a, EEG); % Apply filter to data using zero-phase filtering

Fs = sample_rate;
t = (0:length(EEG)-1)/Fs;

figure; plot(t,filteredData, t, filteredData2, '--')
line([stim_start/Fs stim_start/Fs], [-2 2]);
ylabel('Voltage (V)')
xlabel('Time (s)')
xlim([stim_start/Fs-5 stim_start/Fs+5])
title('EEG')
grid



baseline_low = filteredData(stim_start-(sample_rate*4):stim_start);
stim_low = filteredData(stim_start+sample_rate*0.5:stim_start+(sample_rate*4.5));

baseline_high = filteredData2(stim_start-(sample_rate*4):stim_start);
stim_high = filteredData2(stim_start+sample_rate*0.5:stim_start+(sample_rate*4.5));

low_pow_baseline = sum(baseline_low.^2);
low_pow_stim = sum(stim_low.^2);

high_pow_baseline = sum(baseline_high.^2);
high_pow_stim = sum(stim_high.^2);

low = low_pow_stim/low_pow_baseline
high = high_pow_stim/high_pow_baseline