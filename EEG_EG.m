function [bakin_post] = EEG_EG()%(handles)
load mtlb

sample_rate = 100000;    %handles.filedata.sample_rate;
Fs = sample_rate; 

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

figure; plot(input); title(fname(66:end-4));

                
stim_start = find(stim(:,1)>0.02);
stim_start = stim_start(1);



t = (0:length(EEG)-1)/Fs;

figure; plot(t,EEG, 'black')
line([stim_start/Fs stim_start/Fs], [-3 6],'Color', 'r');
line([(stim_start+sample_rate*.5)/Fs (stim_start+sample_rate*.5)/Fs], [-3 6],'Color', 'r');
ylabel('Voltage (V)')
xlabel('Time (s)')
xlim([stim_start/Fs-5 stim_start/Fs+5])
title(fname(66:end-4))
grid


% stim_int = sum(abs(EEG(stim_start:stim_start+sample_rate*2)));
% base_int = sum(abs(EEG(stim_start-(sample_rate*2):stim_start)));
% bakin_wein_sum = base_int/stim_int;

stim_int_post = sum(abs(EEG(stim_start+sample_rate*0.5:stim_start+sample_rate*5.5)));
base_int_post = sum(abs(EEG(stim_start-(sample_rate*5):stim_start)));
bakin_post = base_int_post/stim_int_post;

% 
% 
% theta = bandpass(EEG,[3,8]);
% alpha = bandpass(EEG,[8,12]);
% beta = bandpass(EEG,[12,38]);
% % 
% theta_pow = theta.^2;
% alpha_pow = alpha.^2;
% beta_pow = beta.^2;




% 
% 
% 
% theta_ratio = theta_pow(stim_start-sample_rate*2:stim_start)/theta_pow(stim_start:stim_start+sample_rate*2);
% alpha_ratio = alpha_pow(stim_start-sample_rate*2:stim_start)/alpha_pow(stim_start:stim_start+sample_rate*2);
% beta_ratio = beta_pow(stim_start-sample_rate*2:stim_start)/beta_pow(stim_start:stim_start+sample_rate*2);
% 
% 
% baseline = EEG(stim_start-(sample_rate*1):stim_start);
% stim = EEG(stim_start:stim_start+(sample_rate*1));
% 
% 
% Fs = sample_rate;
% t = (0:length(EEG)-1)/Fs;
% 
% plot(t,EEG)
% ylabel('Voltage (V)')
% xlabel('Time (s)')
% title('EEG')
% grid
% 
% 
% [pEEG,fEEG] = periodogram(EEG,rectwin(length(EEG)),length(EEG),Fs);
% [pbase,fbase] = periodogram(baseline,rectwin(length(baseline)),length(baseline),Fs);
% [pstim,fstim] = periodogram(stim,rectwin(length(stim)),length(stim),Fs);
% 
% plot(fstim,20*log10(abs(pstim)),fbase,20*log10(abs(pbase)),'--')
% xlim([0,100])
% ylabel('Power/frequency (dB/Hz)')
% xlabel('Frequency (Hz)')
% title('Power Spectrum')
% legend('Stimulation','Baseline')
% grid
% 
% 
% 
% plot(fstim,pstim,fbase,pbase,'--')
% xlim([0,100])
% ylabel('Power')
% xlabel('Frequency (Hz)')
% title('Power Spectrum')
% legend('Stimulation','Baseline')
% grid
% 
% % stim_power = [fstim,20*log10(abs(pstim))];
% % base_power = [fbase,20*log10(abs(pbase))];
% 
% stim_power = [fstim,pstim];
% base_power = [fbase,pbase];
% 
% 
% 
% low_freq_index = stim_power(:,1) < 7 & stim_power(:,1) > 4; %theta
% high_freq_index = stim_power(:,1) < 32 & stim_power(:,1) > 8; %alpha and beta
% 
% low_stim = sum(stim_power(low_freq_index,2));
% high_stim = sum(stim_power(high_freq_index,2));
% 
% low_base = sum(base_power(low_freq_index,2));
% high_base = sum(base_power(high_freq_index,2));
% 
% ratio_high = high_stim/high_base;
% ratio_low = low_stim/low_base;
% 
% 
