
%load KRSY20180327rec2-180327-111655.mat;

figure; plot(Ca)


sample_rate = 1017.25;

FL = 1017.25;                       %%Sampling rate
[b, a] = butter(4, 5/FL, 'low');
Lfilter = filtfilt(b, a, double(Ca));


figure; plot(Lfilter)

%% Hard-code onset values based on FP trace

%25;55;85

onset1 = 46400;
onset2 = 88500;
onset3 = 107500;

NOX(1).onset = onset1;
NOX(2).onset = onset2;
NOX(3).onset = onset3;

%%

for i = 1:size(NOX,2)
    baseline = mean(Lfilter((NOX(i).onset-(0.2*sample_rate)):(NOX(i).onset)));
    NOX(i).deltaf = Lfilter((NOX(i).onset-(sample_rate)):(NOX(i).onset+(3*sample_rate)))/baseline;
    figure; plot(NOX(i).deltaf, 'k')
end

x = (1:size(NOX(1).deltaf,2));
figure; shadedErrorBar(x,[NOX(1).deltaf' NOX(2).deltaf' NOX(3).deltaf']',{@mean,@std}); ylim([0.98 1.10])




