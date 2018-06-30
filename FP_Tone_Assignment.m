
%%Import data and then name tones and responses based on what those columns
%%are named from behavioral text file.

FL = 1017.25;

tone_length = 100/(1000*FL); %100 ms

tones = CMEDPC;
responses = VarName5;
init_delay = VarName4/(1000*FL);
resp_time = IVDATA20180608/(1000*FL);

init_delay(init_delay==0) = [];
tones(tones==0) = [];
responses(responses==0) = [];

compiled_tones = [trigger_pks_locs tones];
compiled_resp = [trigger_pks_locs responses];

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
        TONE(1).deltaf(ii,:) = Lfilter(trigger_pks_locs(ii)-FL:trigger_pks_locs(ii)+(3*FL))/baseline;
        TONE(1).init_delay(ii) = init_delay(ii);
    elseif tones(ii) == 1000
         TONE(2).deltaf(ii,:) = Lfilter(trigger_pks_locs(ii)-(FL):trigger_pks_locs(ii)+(3*FL))/baseline;   
         TONE(2).init_delay(ii) = init_delay(ii);
    elseif tones(ii) == 2000
         TONE(3).deltaf(ii,:) = Lfilter(trigger_pks_locs(ii)-(FL):trigger_pks_locs(ii)+(3*FL))/baseline;
         TONE(3).init_delay(ii) = init_delay(ii);
    elseif tones(ii) == 4000
         TONE(4).deltaf(ii,:) = Lfilter(trigger_pks_locs(ii)-(FL):trigger_pks_locs(ii)+(3*FL))/baseline;
         TONE(4).init_delay(ii) = init_delay(ii);
    elseif tones(ii) == 8000
         TONE(5).deltaf(ii,:) = Lfilter(trigger_pks_locs(ii)-(FL):trigger_pks_locs(ii)+(3*FL))/baseline;
         TONE(5).init_delay(ii) = init_delay(ii);
    elseif tones(ii) == 16000
         TONE(6).deltaf(ii,:) = Lfilter(trigger_pks_locs(ii)-(FL):trigger_pks_locs(ii)+(3*FL))/baseline;
         TONE(6).init_delay(ii) = init_delay(ii);
    elseif tones(ii) == 32000
         TONE(7).deltaf(ii,:) = Lfilter(trigger_pks_locs(ii)-(FL):trigger_pks_locs(ii)+(3*FL))/baseline;
         TONE(7).init_delay(ii) = init_delay(ii);
    else
    end
end

%% Remove zeroes

for iii = 1:size(TONE,2)
    TONE(iii).deltaf = TONE(iii).deltaf(any(TONE(iii).deltaf,2),:);
    TONE(iii).init_delay(TONE(iii).init_delay==0) = [];
    %TONE(iii).init_delay = TONE(iii).init_delay(any(TONE(iii).init_delay,2),:);
end


%%  Integral and Peak Analysis

for iv = 1:size(TONE,2)
    for v = 1:size(TONE(iv).deltaf,1)
    TONE(iv).integ(v) = trapz(TONE(iv).deltaf(v,FL:2*FL)); %from tone onset two 2 seconds after tone onset (FL = sample rate)
    TONE(iv).peak(v) = max(TONE(iv).deltaf(v,FL:2*FL)); %from tone onset two 2 seconds after tone onset (FL = sample rate)
    end
end


%% Plot Integral and Peak Analysis


for j = 1:size(TONE,2)
plot(ones(numel(TONE(j).integ),1)*j, TONE(j).integ, 'k.', 'MarkerSize', 15); hold on; 
end 



for vi = 1:size(TONE,2)
plot(ones(numel(TONE(vi).peak),1)*vi, TONE(vi).peak, 'k.', 'MarkerSize', 15); hold on; 
end 
hold off


figure;imagesc([TONE(1).deltaf' TONE(2).deltaf' TONE(3).deltaf' TONE(4).deltaf' TONE(5).deltaf' TONE(7).deltaf']'); colormap jet; colorbar; caxis([0.98 1.04])44

figure; imagesc(TONE(6).deltaf); colormap jet; colorbar; caxis([0.98 1.04])

%% If want to label whole trace with tones


tone_label = num2str(tones);
figure; plot(Ca); hold on; plot(trigger_pks_locs',num_points,'sr', 'MarkerSize',5,'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'none');
 hold on; plot(trigger_high_pks_locs',num_high_points,'sr', 'MarkerSize',5,'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'none');

num_points_Ca = 920*ones(1,length(trigger_pks_locs));

for i = 1:length(trigger_pks_locs)
    t = text(trigger_pks_locs(i)', num_points_Ca(i), {tone_label(i,:)});
end