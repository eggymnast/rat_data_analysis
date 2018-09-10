%function behav_analysis_EG()%(handles)

p = path;
disp('Pick the folder with files to analyze');                            % display in command window info about what type of folder you should pick 
filestosort = uigetdir;                                                    % open folder selection dialog box
path(p, filestosort);                                                      % temporarily add random folder to the path to read things about it
tempp = path; 
d     = dir(filestosort); 
filelist = listdlg('PromptString', 'Pick files to sort: ', ...
                    'SelectionMode', 'multiple',...
                    'ListString', {d.name}); 
                
%fname=[filestosort,'/',d(filelist).name]; 

for i = 1:length(filelist)
    BEHAV(i).fname=[filestosort,'/',d(filelist(i)).name]; 
    BEHAV(i).raw = dlmread(BEHAV(i).fname, '\t');
    BEHAV(i).hit = 0;
    BEHAV(i).miss = 0;
    BEHAV(i).falz = 0;
    BEHAV(i).withold = 0;
end

for ii = 1:size(BEHAV,2)
    for iii = 1:size(BEHAV(ii).raw,1)
        if BEHAV(ii).raw(iii,4) == 0
            BEHAV(ii).raw(iii,:) = [0 0 0 0];
        else
        end
    end
end

for iv = 1:size(BEHAV,2)
    BEHAV(iv).raw = BEHAV(iv).raw(any(BEHAV(iv).raw,2),:);
end


for v = 1:size(BEHAV,2)
    for i = 1:size(BEHAV(v).raw,1)
        if BEHAV(v).raw(i,4) == 1
            BEHAV(v).hit = BEHAV(v).hit+1;
        elseif BEHAV(v).raw(i,4) == 2
            BEHAV(v).miss = BEHAV(v).miss+1;
        elseif BEHAV(v).raw(i,4) == 3
            BEHAV(v).falz = BEHAV(v).falz+1;
        elseif BEHAV(v).raw(i,4) == 4
            BEHAV(v).withold = BEHAV(v).withold+1;
        else
        end
    end
end

for i = 1:size(BEHAV,2)
    if BEHAV(i).hit==0
        if BEHAV(i).hit+BEHAV(i).miss==0
            BEHAV(i).HR = NaN;
        else
            BEHAV(i).HR = (0.5/(BEHAV(i).hit+BEHAV(i).miss));
        end
    else
        BEHAV(i).HR = BEHAV(i).hit/(BEHAV(i).hit+BEHAV(i).miss);
    end


       
    if BEHAV(i).HR == 1
        BEHAV(i).HR = (BEHAV(i).hit-0.5)/(BEHAV(i).hit+BEHAV(i).miss);
    else
    end



    if BEHAV(i).falz==0
        if BEHAV(i).falz+BEHAV(i).withold == 0
            BEHAV(i).FP = NaN;
        else
            BEHAV(i).FP = (0.5/(BEHAV(i).falz+BEHAV(i).withold));
        end
    else
        BEHAV(i).FP = BEHAV(i).falz/(BEHAV(i).falz+BEHAV(i).withold);
    end
  
    
    
    if BEHAV(i).FP == 1
        BEHAV(i).FP = (BEHAV(i).falz-0.5)/(BEHAV(i).falz+BEHAV(i).withold);
    else
    end

    BEHAV(i).d_prime = norminv(BEHAV(i).HR,0,1) - norminv(BEHAV(i).FP,0,1);
    BEHAV(i).hit_slide = 0;
    BEHAV(i).miss_slide = 0;
    BEHAV(i).false_slide = 0;
    BEHAV(i).withold_slide = 0;
end

for ii = 1:size(BEHAV,2)
    for iii = 30:size(BEHAV(ii).raw,1)
        for iv=iii-29:iii
            if BEHAV(ii).raw(iv,4) == 1
                BEHAV(ii).hit_slide = BEHAV(ii).hit_slide+1;
            elseif BEHAV(ii).raw(iv,4) == 2
                BEHAV(ii).miss_slide = BEHAV(ii).miss_slide+1;
            elseif BEHAV(ii).raw(iv,4) == 3
                BEHAV(ii).false_slide = BEHAV(ii).false_slide+1;
            elseif BEHAV(ii).raw(iv,4) == 4
                BEHAV(ii).withold_slide = BEHAV(ii).withold_slide+1;
            else
            end
        end
    
        if BEHAV(ii).hit_slide==0
            if BEHAV(ii).hit_slide+BEHAV(ii).miss_slide == 0
            BEHAV(ii).HR_slide = NaN;
            else
                BEHAV(ii).HR_slide = (0.5/(BEHAV(ii).hit_slide+BEHAV(ii).miss_slide));
            end
        else
            BEHAV(ii).HR_slide = BEHAV(ii).hit_slide/(BEHAV(ii).hit_slide+BEHAV(ii).miss_slide);
        end
    
        if BEHAV(ii).HR_slide == 1
            BEHAV(ii).HR_slide = (BEHAV(ii).hit_slide-0.5)/(BEHAV(ii).hit_slide+BEHAV(ii).miss_slide);
        else
        end
    
        if BEHAV(ii).false_slide==0
            if BEHAV(ii).false_slide+BEHAV(ii).withold_slide == 0
                BEHAV(ii).FP_slide = NaN;
            else
                BEHAV(ii).FP_slide = (0.5/(BEHAV(ii).false_slide+BEHAV(ii).withold_slide));
            end
        else
            BEHAV(ii).FP_slide = BEHAV(ii).false_slide/(BEHAV(ii).false_slide+BEHAV(ii).withold_slide);
        end
    
        if BEHAV(ii).FP_slide == 1
            BEHAV(ii).FP_slide = (BEHAV(ii).false_slide-0.5)/(BEHAV(ii).false_slide+BEHAV(ii).withold_slide);
        else
        end            
                   
        BEHAV(ii).d_slide(iii-29) = norminv(BEHAV(ii).HR_slide,0,1) - norminv(BEHAV(ii).FP_slide,0,1);
        BEHAV(ii).hit_slide = 0;
        BEHAV(ii).miss_slide = 0;
        BEHAV(ii).false_slide = 0;
        BEHAV(ii).withold_slide = 0;
    end 
end

figure
for iii = 1:size(BEHAV,2)
    subplot(round(size(BEHAV,2)/2),2,iii)
    plot(BEHAV(iii).d_slide); title(BEHAV(iii).fname(75:end-4), 'Interpreter', 'none'); ylim([-3.50 3.50])
    ylabel('d-prime') 
    xlabel('time (min)') 
end

% figure
% for iii = 1:size(BEHAV,2)
%     subplot(round(size(BEHAV,2)/2),2,iii)
%     plot(BEHAV(iii).hit_slide); title(BEHAV(iii).fname(75:end-4), 'Interpreter', 'none'); ylim([-3.50 3.50])
%     ylabel('hit rate') 
%     xlabel('time (min)') 
% end
% 
% figure
% for iii = 1:size(BEHAV,2)
%     subplot(round(size(BEHAV,2)/2),2,iii)
%     plot(BEHAV(iii).false_slide); title(BEHAV(iii).fname(75:end-4), 'Interpreter', 'none'); ylim([-3.50 3.50])
%     ylabel('fp rate') 
%     xlabel('time (min)') 
% end
%     

    
% figure; plot(d_slide); title(fname(75:end-4), 'Interpreter', 'none'); ylim([-3.50 3.50])
% clear all
% test = 0;
