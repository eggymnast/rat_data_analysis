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


figure;imagesc([TONE(1).deltaf' TONE(2).deltaf' TONE(3).deltaf' TONE(4).deltaf' TONE(5).deltaf' TONE(7).deltaf']'); colormap jet; colorbar; caxis([0.98 1.04])

figure; imagesc(TONE(6).deltaf); colormap jet; colorbar; caxis([0.98 1.04])

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