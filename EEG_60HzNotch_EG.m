function EEG_60HzNotch_EG()%(handles)
load mtlb

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

teast = 0;
                




Fs = sample_rate;
t = (0:length(EEG)-1)/Fs;

plot(t,EEG)
ylabel('Voltage (V)')
xlabel('Time (s)')
title('EEG')
grid

d = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',59,'HalfPowerFrequency2',61, ...
               'DesignMethod','butter','SampleRate',Fs);
           
buttEEG = filtfilt(d,EEG);

plot(t,EEG,t,buttEEG)
ylabel('Voltage (V)')
xlabel('Time (s)')
title('EEG')
legend('Unfiltered','Filtered')
grid

[pEEG,fEEG] = periodogram(EEG,[],[],Fs);
[pbutt,fbutt] = periodogram(buttEEG,[],[],Fs);

plot(fEEG,20*log10(abs(pEEG)),fbutt,20*log10(abs(pbutt)),'--')
xlim([0,100])
ylabel('Power/frequency (dB/Hz)')
xlabel('Frequency (Hz)')
title('Power Spectrum')
legend('Unfiltered','Filtered')
grid
