%--------------------------------------------------------------------------
%                           TIME LOCK DATA 
%--------------------------------------------------------------------------
clear all
tic
%Visual
directory  = 'DataDirectory\\Visual\\'; %directory of the data
subject = {'Subj01' 'Subj02' 'Subj03' 'Subj04' 'Subj05' 'Subj06' 'Subj07' 'Subj08' 'Subj09'...
    'Subj11' 'Subj12' 'Subj13' 'Subj14' 'Subj15' 'Subj16' 'Subj17' 'Subj18' 'Subj19'};

%Verbal
% directory  = '/Users/pex/phd/matlab/200316_play/Verbal/'; %directory of the data
% subject = {'Subj01' 'Subj02' 'Subj06' 'Subj07' 'Subj08' 'Subj09' 'Subj10' 'Subj11'...
%     'Subj12' 'Subj14' 'Subj15' 'Subj16' 'Subj17' 'Subj18' 'Subj19' 'Subj20' 'Subj21' 'Subj22'};


epoch = {'study' 'test'};
condition = {'FA', 'LM', 'OB'};
response = {'visual'}; %if Verbal, reponse lexical


for j  =  1:length(subject)
    for e = 1:length(epoch)
        %----------------------------------------------------------------------
        % LOAD CLEANED DATA
        %----------------------------------------------------------------------
        if strcmp(epoch{e},'study')
            for cn = 1:length(condition)
                eval(sprintf('load %s%s/3-CleanData/%s_CleanData_%s_%s.mat',directory,subject{j},subject{j},epoch{e},condition{cn}))
                %Filtering the data
                cfg = []; cfg.channel = {'all' '-VEOG' '-HEOG'}; cfg.demean = 'yes'; cfg.baselinewindow = [-0.2 0]; cfg.lpfilter = 'yes';  cfg.lpfreq = 30;
                eval(sprintf('%s%s%s%s',subject{j},'_CleanData_',epoch{e},'_',condition{cn},'= ft_preprocessing(cfg,',subject{j},'_CleanData_',epoch{e},'_',condition{cn},');'));
                % Time Lock Data
                cd(sprintf('%s%s%s',directory,subject{j},'/4-TimeLockData/'))
                cfg = []; cfg.channel = {'all' '-VEOG' '-HEOG'}; cfg.keeptrials = 'yes';
                eval(sprintf('%s_timelock_%s_%s = ft_timelockanalysis(cfg, %s_CleanData_%s_%s);',subject{j},epoch{e},condition{cn},subject{j},epoch{e},condition{cn}));
                eval(sprintf('save %s_timelock_%s_%s %s_timelock_%s_%s',subject{j},epoch{e},condition{cn},subject{j},epoch{e},condition{cn}));
            end
        elseif strcmp(epoch{e},'test')
           for cn = 1:length(condition)
                for r = 1:length(response)
                    eval(sprintf('load %s/%s/3-CleanData/%s_CleanData_%s_%s_%s.mat',directory,subject{j},subject{j},epoch{e},condition{cn},response{r}))
                    %Filtering the data
                    cfg = []; cfg.channel = {'all' '-VEOG' '-HEOG'}; cfg.demean = 'yes'; cfg.baselinewindow = [-0.2 0]; cfg.lpfilter = 'yes';  cfg.lpfreq = 30;
                    eval(sprintf('%s%s%s%s',subject{j},'_CleanData_',epoch{e},'_',condition{cn},'_',response{r},'= ft_preprocessing(cfg,',subject{j},'_CleanData_',epoch{e},'_',condition{cn},'_',response{r},');'));
                    % Time Lock Data
                    cd(sprintf('%s%s%s',directory,subject{j},'/4-TimeLockData/'))
                    cfg = []; cfg.channel = {'all' '-VEOG' '-HEOG'}; cfg.keeptrials = 'yes';
                    eval(sprintf('%s_timelock_%s_%s_%s = ft_timelockanalysis(cfg, %s_CleanData_%s_%s_%s);',subject{j},epoch{e},condition{cn},response{r},subject{j},epoch{e},condition{cn},response{r}));
                    eval(sprintf('save %s_timelock_%s_%s_%s %s_timelock_%s_%s_%s',subject{j},epoch{e},condition{cn},response{r},subject{j},epoch{e},condition{cn},response{r}));
                end
            end
        end
    end
    %----------------------------------------------------------------------
    % Clear from memory variables from the current subject
    %----------------------------------------------------------------------
    eval(sprintf('%s','clear -regexp ^',subject{j}))    
end

toc