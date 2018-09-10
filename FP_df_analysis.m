TONE = BASE_LONG; %%change based on saved data

FL = 1017.25;

%%  Integral and Peak Analysis

for iv = 1:size(TONE,2)
    for v = 1:size(TONE(iv).deltaf,1)
    TONE(iv).integ(v) = trapz(TONE(iv).deltaf(v,FL:3*FL)); %from tone onset to one second after tone onset (FL = sample rate)
    TONE(iv).peak(v) = max(TONE(iv).deltaf(v,FL:3*FL)); %from tone onset to one second after tone onset (FL = sample rate)
    TONE(iv).peak_resp(v) = max(TONE(iv).deltaf_resp(v,FL:3*FL)); %from tone onset to one second after tone onset (FL = sample rate)
    end
end


%% Plot Integral and Peak Analysis

figure;
for j = 1:size(TONE,2)
plot(ones(numel(TONE(j).integ),1)*j, TONE(j).integ, 'k.', 'MarkerSize', 15); hold on; 
end 

hold off;

figure;
for vi = 1:size(TONE,2)
plot(ones(numel(TONE(vi).peak),1)*vi, TONE(vi).peak, 'k.', 'MarkerSize', 15); hold on; 
end 
hold off

figure;
for m = 1:size(TONE,2)
plot(ones(numel(TONE(m).peak_resp),1)*m, TONE(m).peak_resp, 'k.', 'MarkerSize', 15); hold on; 
end 
hold off

%%




foils_rev = [TONE(1).deltaf' TONE(2).deltaf' TONE(3).deltaf' TONE(4).deltaf' TONE(5).deltaf' TONE(7).deltaf']';

foils_noTT = [TONE(1).deltaf' TONE(2).deltaf' TONE(3).deltaf' TONE(5).deltaf' TONE(7).deltaf']';

figure;imagesc([TONE(1).deltaf' TONE(2).deltaf' TONE(3).deltaf' TONE(4).deltaf' TONE(5).deltaf' TONE(7).deltaf']'); colormap jet;... 
colorbar; caxis([1.00 1.04])

figure;imagesc([TONE(4).detect' TONE(4).withold']'); colormap jet; colorbar; caxis([1.00 1.04])

figure;imagesc([TONE(6).detect' TONE(6).withold']'); colormap jet; colorbar; caxis([1.00 1.04])

figure; imagesc(TONE(6).deltaf); colormap jet; colorbar; caxis([1.00 1.04])

foils_out = downsample(foils_rev',20);
foils_noTT_out = downsample(foils_noTT',20);
target_new_out = downsample(TONE(6).deltaf',20);
target_old_out = downsample(TONE(4).deltaf',20);


mean_foils = mean(foils_out');
mean_foils_noTT = mean(foils_noTT_out');
mean_newTT = mean(target_new_out');
mean_oldTT = mean(target_old_out');

%mat2clip([mean_newTT' mean_foils_noTT' mean_oldTT']);


%% Analysis based on response type

%1 or 3 = hit or false positive; 2 or 4 = miss or withold

detect = [1 3];
%withold = [2 4];


for vii = 1:size(TONE,2)
    for viii = 1:size(TONE(vii).deltaf,1)
        if ismember(TONE(vii).response(viii),detect) == 1
            TONE(vii).detect(viii,:) = TONE(vii).deltaf(viii,:);
        else
            TONE(vii).withold(viii,:) = TONE(vii).deltaf(viii,:);
        end
    end
end



% comp = [REV4_1(4).deltaf' REV4_2(4).deltaf' REV5_1(4).deltaf' REV5_2(4).deltaf' REV6_1(4).deltaf' REV6_2(4).deltaf']';
% comp_down = downsample(comp',20);
% mean_comp = mean(comp_down');
% mat2clip(mean_comp')



