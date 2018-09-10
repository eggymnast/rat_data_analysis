
%%Import data and then name tones and responses based on what those columns
%%are named from behavioral text file.


p = path;
disp('Pick the folder with files to analyze');                            % display in command window info about what type of folder you should pick 
filestosort = uigetdir;                                                    % open folder selection dialog box
path(p, filestosort);                                                      % temporarily add random folder to the path to read things about it
tempp = path; 
d     = dir(filestosort); 
filelist = listdlg('PromptString', 'Pick files to sort: ', ...
                    'SelectionMode', 'single',...
                    'ListString', {d.name}); 
                
fname=[filestosort,'/',d(filelist).name]; 
            
BEHAV = dlmread(fname, '\t');

FL = 1017.25;

tone_length = 100/(1000*FL); %100 ms


tones = BEHAV(:,1);
responses = BEHAV(:,4);
init_delay = BEHAV(:,3)/(1000*FL);
resp_time = BEHAV(:,2)/(1000*FL); %change based on name of behav data file

init_delay(init_delay==0) = [];
tones(tones==0) = [];
resp_time(responses==0) = [];
responses(responses==0) = [];


compiled_tones = [trigger_pks_locs tones];
compiled_resp = [trigger_pks_locs responses];
tone_resp = [tones responses];

%% Frequency alloction
TONE(1).freq = 500;
TONE(2).freq = 1000;
TONE(3).freq = 2000;
TONE(4).freq = 4000;
TONE(5).freq = 8000;
TONE(6).freq = 16000;
TONE(7).freq = 32000;

%% Assigning deltaf/f for each tone

for ii=1:length(tones)
    baseline = mean(Lfilter((trigger_pks_locs(ii)-init_delay(ii)-FL):trigger_pks_locs(ii)-init_delay(ii))); % shifted baseline so is before initiation
    if tones(ii) == 500
        TONE(1).deltaf(ii,:) = Lfilter(trigger_pks_locs(ii)-FL:trigger_pks_locs(ii)+(4*FL))/baseline;
        TONE(1).deltaf_resp(ii,:) = Lfilter(trigger_pks_locs(ii)+resp_time(ii)-FL:trigger_pks_locs(ii)+resp_time(ii)+(3*FL))/baseline;
        TONE(1).init_delay(ii) = init_delay(ii);
        TONE(1).response(ii) = responses(ii);
        TONE(1).resp_time(ii) = resp_time(ii);
    elseif tones(ii) == 1000
         TONE(2).deltaf(ii,:) = Lfilter(trigger_pks_locs(ii)-(FL):trigger_pks_locs(ii)+(4*FL))/baseline;
         TONE(2).deltaf_resp(ii,:) = Lfilter(trigger_pks_locs(ii)+resp_time(ii)-FL:trigger_pks_locs(ii)+resp_time(ii)+(3*FL))/baseline;
         TONE(2).init_delay(ii) = init_delay(ii);
         TONE(2).response(ii) = responses(ii);
         TONE(2).resp_time(ii) = resp_time(ii);
    elseif tones(ii) == 2000
         TONE(3).deltaf(ii,:) = Lfilter(trigger_pks_locs(ii)-(FL):trigger_pks_locs(ii)+(4*FL))/baseline;
         TONE(3).deltaf_resp(ii,:) = Lfilter(trigger_pks_locs(ii)+resp_time(ii)-FL:trigger_pks_locs(ii)+resp_time(ii)+(3*FL))/baseline;
         TONE(3).init_delay(ii) = init_delay(ii);
         TONE(3).response(ii) = responses(ii);
         TONE(3).resp_time(ii) = resp_time(ii);
    elseif tones(ii) == 4000
         TONE(4).deltaf(ii,:) = Lfilter(trigger_pks_locs(ii)-(FL):trigger_pks_locs(ii)+(4*FL))/baseline;
         TONE(4).deltaf_resp(ii,:) = Lfilter(trigger_pks_locs(ii)+resp_time(ii)-FL:trigger_pks_locs(ii)+resp_time(ii)+(3*FL))/baseline;
         TONE(4).init_delay(ii) = init_delay(ii);
         TONE(4).response(ii) = responses(ii);
         TONE(4).resp_time(ii) = resp_time(ii);
    elseif tones(ii) == 8000
         TONE(5).deltaf(ii,:) = Lfilter(trigger_pks_locs(ii)-(FL):trigger_pks_locs(ii)+(4*FL))/baseline;
         TONE(5).deltaf_resp(ii,:) = Lfilter(trigger_pks_locs(ii)+resp_time(ii)-FL:trigger_pks_locs(ii)+resp_time(ii)+(3*FL))/baseline;
         TONE(5).init_delay(ii) = init_delay(ii);
         TONE(5).response(ii) = responses(ii);
         TONE(5).resp_time(ii) = resp_time(ii);
    elseif tones(ii) == 16000
         TONE(6).deltaf(ii,:) = Lfilter(trigger_pks_locs(ii)-(FL):trigger_pks_locs(ii)+(4*FL))/baseline;
         TONE(6).deltaf_resp(ii,:) = Lfilter(trigger_pks_locs(ii)+resp_time(ii)-FL:trigger_pks_locs(ii)+resp_time(ii)+(3*FL))/baseline;
         TONE(6).init_delay(ii) = init_delay(ii);
         TONE(6).response(ii) = responses(ii);
         TONE(6).resp_time(ii) = resp_time(ii);
    elseif tones(ii) == 32000
         TONE(7).deltaf(ii,:) = Lfilter(trigger_pks_locs(ii)-(FL):trigger_pks_locs(ii)+(4*FL))/baseline;
         TONE(7).deltaf_resp(ii,:) = Lfilter(trigger_pks_locs(ii)+resp_time(ii)-FL:trigger_pks_locs(ii)+resp_time(ii)+(3*FL))/baseline;
         TONE(7).init_delay(ii) = init_delay(ii);
         TONE(7).response(ii) = responses(ii);
         TONE(7).resp_time(ii) = resp_time(ii);
    else
    end
    TONE(8).deltaf(ii,:) = Lfilter(trigger_pks_locs(ii)-(FL):trigger_pks_locs(ii)+(4*FL))/baseline;
end


%% Remove zeroes

for iii = 1:(size(TONE,2)-1)
    if size(TONE(iii).deltaf,1) > 1
        TONE(iii).deltaf = TONE(iii).deltaf(any(TONE(iii).deltaf,2),:);
        TONE(iii).deltaf_resp = TONE(iii).deltaf_resp(any(TONE(iii).deltaf_resp,2),:);
        TONE(iii).init_delay(TONE(iii).init_delay==0) = [];
        TONE(iii).response(TONE(iii).response==0) = [];
        TONE(iii).resp_time(TONE(iii).resp_time==0) = [];
    else
    end
end


%%  Integral and Peak Analysis

for iv = 1:(size(TONE,2)-1)
    for v = 1:size(TONE(iv).deltaf,1)
    TONE(iv).integ(v) = trapz(TONE(iv).deltaf(v,FL:3.5*FL)); %from tone onset to 2.5 secs after tone onset (FL = sample rate)
    TONE(iv).peak(v) = max(TONE(iv).deltaf(v,FL:3.5*FL)); %from tone onset to 2.5 secs after tone onset (FL = sample rate)
    TONE(iv).peak_resp(v) = max(TONE(iv).deltaf_resp(v,FL:3.5*FL)); %from tone onset to 2.5 secs after tone onset (FL = sample rate)
    end
end


%% Plot Integral and Peak Analysis

% figure;
% for j = 1:size(TONE,2)
% plot(ones(numel(TONE(j).integ),1)*j, TONE(j).integ, 'k.', 'MarkerSize', 15); hold on; 
% end 
% 
% hold off;
% 
% figure;
% for vi = 1:size(TONE,2)
% plot(ones(numel(TONE(vi).peak),1)*vi, TONE(vi).peak, 'k.', 'MarkerSize', 15); hold on; 
% end 
% hold off
% 
% figure;
% for m = 1:size(TONE,2)
% plot(ones(numel(TONE(m).peak_resp),1)*m, TONE(m).peak_resp, 'k.', 'MarkerSize', 15); hold on; 
% end 
% hold off


figure;imagesc([TONE(1).deltaf' TONE(2).deltaf' TONE(3).deltaf' TONE(4).deltaf' TONE(5).deltaf' TONE(7).deltaf']'); colormap jet; colorbar; caxis([1.00 1.04]); title('Foils');


figure; imagesc(TONE(4).deltaf); colormap jet; colorbar; caxis([1.00 1.04]); title('4 kHz');

figure; imagesc(TONE(6).deltaf); colormap jet; colorbar; caxis([1.00 1.04]); title('16 kHz');

figure; imagesc(TONE(8).deltaf); colormap jet; colorbar; caxis([1.00 1.04]); title('Trials in Order');
%% Analysis based on response type

%1 or 3 = hit or false positive; 2 or 4 = miss or withold

detect = [1 3];
%withold = [2 4];


for vii = 1:(size(TONE,2)-1)
    for viii = 1:size(TONE(vii).deltaf,1)
        if ismember(TONE(vii).response(viii),detect) == 1
            TONE(vii).detect(viii,:) = TONE(vii).deltaf(viii,:);
        else
            TONE(vii).withold(viii,:) = TONE(vii).deltaf(viii,:);
        end
    end
end

for ix = 1:(size(TONE,2)-1)
    TONE(ix).withold = TONE(ix).withold(any(TONE(ix).withold,2),:);
    TONE(ix).detect = TONE(ix).detect(any(TONE(ix).detect,2),:);
end


%% Plotting routine

figure; plot(mean(TONE(4).deltaf)); ylim([0.98 1.04])


x = (1:size(TONE(4).deltaf,2));

if size(TONE(4).deltaf,1) > 1
    figure; shadedErrorBar(x,TONE(4).deltaf,{@mean,@std}); ylim([0.98 1.04]); title('4 kHz') % original targt tone plotted
else
end


figure; shadedErrorBar(x,TONE(6).deltaf,{@mean,@std}); ylim([0.98 1.04]); title('16 kHz')% reversed target tone plotted

foils_rev = [TONE(1).deltaf' TONE(2).deltaf' TONE(3).deltaf' TONE(4).deltaf' TONE(5).deltaf' TONE(7).deltaf']';

figure; shadedErrorBar(x,foils_rev,{@mean,@std}); ylim([0.98 1.04]); title('foils');

%% If want to label whole trace with tones

trial_no = 1:length(tones);

tone_label = num2str(tones);
trial_no_label = num2str(trial_no');
figure; plot(Ca); hold on; plot(trigger_pks_locs',num_points,'sr', 'MarkerSize',5,'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'none');

hold on; plot(trigger_high_pks_locs',num_high_points,'sr', 'MarkerSize',5,'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'none');

num_points_Ca = 675*ones(1,length(trigger_pks_locs));
num_points_Ca2 = 665*ones(1,length(trigger_pks_locs));

for i = 1:length(trigger_pks_locs)
    t = text(trigger_pks_locs(i)', num_points_Ca(i), {tone_label(i,:)});
    t = text(trigger_pks_locs(i)', num_points_Ca2(i), {trial_no_label(i,:)});
end

% num_points_Ca = 865*ones(1,length(trigger_pks_locs));
% 
% for trial_label = 1:length(trigger_pks_locs)
%     trials = text(trigger_pks_locs(trial_label)', num_points_Ca(trial_label), {trial_no_label(trial_label,:)});
% end


% 
% for xi = 1:size(TONE,2)
%     for xii = 1:size(TONE(xi).deltaf,1)
%     figure; plot(TONE(xi).deltaf(xii,:)); title(num2str([xi xii])); ylim([0.97 1.05])
%     end
% end