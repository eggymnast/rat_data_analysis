for i = 1:2
    data(i,1) = EEG_EG;
    [data(i,2) data(i,3)] = filter_eeg;
end