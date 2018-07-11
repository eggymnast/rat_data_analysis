%function FP_highlow_input_analysis()%(handles)


load('TYRN20180604rec1-180604-185029.mat')

% bandpass to 5 Hz via rec from Dayu

FL = 1017.25;                       %%Sampling rate
[b, a] = butter(4, 5/FL, 'low');
Lfilter = filtfilt(b, a, double(Ca));
%Lfilter = smooth(Lfilter);
figure; plot(Lfilter)



trigger = input(:);

%%Fnd all trigger points, high and low

for j=1:length(trigger)
    if trigger(j)<7.5
        trigger(j) = 0;
    else trigger(j) = trigger(j);
    end
end

[trigger_pks, trigger_pks_locs] = findpeaks(trigger);

%%Isolate only high trigger points

trigger_high = trigger;

for k=1:length(trigger_high)
    if trigger_high(k)<60
        trigger_high(k) = 0;
    else trigger_high(k) = trigger_high(k);
    end
end

[trigger_high_pks, trigger_high_pks_locs] = findpeaks(trigger_high);
num_high_points = .01*ones(1,length(trigger_high_pks_locs));

%%Remove high peaks from total list to get low peaks only
run_off = 0;
overlap = ismember(trigger_pks_locs, trigger_high_pks_locs);

for i=2:(length(trigger_pks_locs))
    for w=1:length(trigger_high_pks)
        if (trigger_high_pks_locs(w)<trigger_pks_locs(i)) && (trigger_pks_locs(i)<2000+trigger_high_pks_locs(w))
            run_off = 1;
        else
        end
        if run_off == 1
            trigger_pks_locs(i) = 0;
        end
        run_off = 0;
    end
    if (trigger_pks_locs(i-1)<trigger_pks_locs(i)) && (trigger_pks_locs(i)<90+trigger_pks_locs(i-1))
         trigger_pks_locs(i) = 0;   
    elseif overlap(i) == 1
        trigger_pks_locs(i) = 0;
    else
    end
    run_off = 0;
end

trigger_pks_locs(trigger_pks_locs==0) = [];
num_points = 0.01*ones(1,length(trigger_pks_locs));

 figure; plot(input); hold on; plot(trigger_pks_locs',num_points,'sr', 'MarkerSize',5,'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'none');
 hold on; plot(trigger_high_pks_locs',num_high_points,'sr', 'MarkerSize',5,'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'none');

