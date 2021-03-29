%--------------------------------------------------------------------------
%            Preparing the data for training the classifier
% This script takes the data from fieldtrip and put it in a way that
%         classification is Matlab can be performed
%--------------------------------------------------------------------------
%                             FREQUENCY
%--------------------------------------------------------------------------
clear all
tic
%Visual
directory  = 'DataDirectory\\Visual\\'; %directory of the data
subject = {'Subj01' 'Subj02' 'Subj03' 'Subj04' 'Subj05' 'Subj06' 'Subj07' 'Subj08' 'Subj09' 'Subj11' 'Subj12' 'Subj13' 'Subj14' 'Subj15' 'Subj16' 'Subj17' 'Subj18' 'Subj19'};
%subject = {'Subj01'};

%Verbal
% directory  = '//psysrv004/psymemlab/Projects/TAPMVPA-LTH/Verbal/'; %directory of the data
% subject = {'Subj01' 'Subj02' 'Subj06' 'Subj07' 'Subj08' 'Subj09' 'Subj10' 'Subj11'...
%     'Subj12' 'Subj14' 'Subj15' 'Subj16' 'Subj17' 'Subj18' 'Subj19' 'Subj20' 'Subj21' 'Subj22'};


epoch = {'study' 'test'};
response = {'visual'}; %if Verbal, reponse lexical

for j  =  1:length(subject)
    cfg.channels = 1:31;
    cfg.freq = 4:45;
    cfg.timepoints = 1:5;
    cfg.numtimebins = 20;
    cfg.startingsample = 150;
    for e = 1:length(epoch)
        fprintf('Starting %s %s.../',subject{j},epoch{e});
        if strcmp(epoch{e},'study')
            %load data
            eval(sprintf('load %s/%s/5-FreqData/%s_wv_%s_FA.mat',directory,subject{j},subject{j},epoch{e}))
            eval(sprintf('load %s/%s/5-FreqData/%s_wv_%s_LM.mat',directory,subject{j},subject{j},epoch{e}))
            eval(sprintf('load %s/%s/5-FreqData/%s_wv_%s_OB.mat',directory,subject{j},subject{j},epoch{e}))
            %prepare data for classifiation           
            cfg.trialinfo = 0; cfg.name = {'Face','Landmark','Object'}; cfg.dimension = 3;
            cfg.label = eval(sprintf('%s_wv_%s_FA.label;',subject{j},epoch{e}));
            eval(sprintf('%s_%s_data = mvpa_dataprep(cfg,%s_wv_%s_FA.powspctrm,%s_wv_%s_LM.powspctrm,%s_wv_%s_OB.powspctrm);'...
                ,subject{j},epoch{e},subject{j},epoch{e},subject{j},epoch{e},subject{j},epoch{e}))
            %save data
            eval(sprintf('cd %s/%s/6-ClassificationData/',directory,subject{j}))
            eval(sprintf('save %s_%s_data %s_%s_data',subject{j},epoch{e},subject{j},epoch{e}))
        elseif strcmp(epoch{e},'test')
            for r = 1:length(response)
                fprintf('Starting %s.../',response{r});
                % load data
                eval(sprintf('load %s/%s/5-FreqData/%s_wv_%s_FA_%s.mat',directory,subject{j},subject{j},epoch{e},response{r}))
                eval(sprintf('load %s/%s/5-FreqData/%s_wv_%s_LM_%s.mat',directory,subject{j},subject{j},epoch{e},response{r}))
                eval(sprintf('load %s/%s/5-FreqData/%s_wv_%s_OB_%s.mat',directory,subject{j},subject{j},epoch{e},response{r}))
                % prepare data for classifiation
                cfg.label = eval(sprintf('%s_wv_%s_FA_%s.label;',subject{j},epoch{e},response{r}));
                cfg.trialinfo = 1; cfg.name = {'Face','Landmark','Object'}; cfg.dimension = 3;
                eval(sprintf('cfg.specifytrialinfo = [%s_wv_%s_FA_%s.trialinfo;%s_wv_%s_LM_%s.trialinfo;%s_wv_%s_OB_%s.trialinfo];'...
                    ,subject{j},epoch{e},response{r},subject{j},epoch{e},response{r},subject{j},epoch{e},response{r}))
                eval(sprintf('%s_%s_data_%s = mvpa_dataprep(cfg,%s_wv_%s_FA_%s.powspctrm,%s_wv_%s_LM_%s.powspctrm,%s_wv_%s_OB_%s.powspctrm);',...
                    subject{j},epoch{e},response{r},subject{j},epoch{e},response{r},subject{j},epoch{e},response{r},subject{j},epoch{e},response{r}))
                % save data
                eval(sprintf('cd %s/%s/6-ClassificationData/',directory,subject{j}))
                eval(sprintf('save %s_%s_data_%s %s_%s_data_%s',subject{j},epoch{e},response{r},subject{j},epoch{e},response{r}))
            end
        end
        fprintf('%s %s finished.../n',subject{j},epoch{e});
        %CLEAR VARIABLES%
        clearvars -except cfg directory e epoch j r response subject condition
    end
end


%--------------------------------------------------------------------------
%                             AMPLITUDE
%--------------------------------------------------------------------------

clear all

%Visual
directory  = 'DataDirectory\\Visual\\'; %directory of the data
subject = {'Subj01' 'Subj02' 'Subj03' 'Subj04' 'Subj05' 'Subj06' 'Subj07' 'Subj08' 'Subj09' 'Subj11' 'Subj12' 'Subj13' 'Subj14' 'Subj15' 'Subj16' 'Subj17' 'Subj18' 'Subj19'};
%subject = {'Subj01'};

%Verbal
% directory  = '//psysrv004/psymemlab/Projects/TAPMVPA-LTH/Verbal/';
% subject = {'Subj01' 'Subj02' 'Subj06' 'Subj07' 'Subj08' 'Subj09' 'Subj10' 'Subj11'...
%     'Subj12' 'Subj14' 'Subj15' 'Subj16' 'Subj17' 'Subj18' 'Subj19' 'Subj20' 'Subj21' 'Subj22'};


epoch = {'study' 'test'};
condition = {'FA', 'LM', 'OB'};
response = {'visual'}; %if Verbal, reponse lexical


for j  =  1:length(subject)
    cfg.channels = 1:31;
    cfg.timepoints = 1:11;
    cfg.numtimebins = 40;
    cfg.startingsample = 758;
    for e = 1:length(epoch)
        fprintf('Starting %s %s.../n',subject{j},epoch{e});
        if strcmp(epoch{e},'study')
            % load data
            eval(sprintf('load %s/%s/4-TimeLockData/%s_timelock_%s_FA.mat',directory,subject{j},subject{j},epoch{e}))
            eval(sprintf('load %s/%s/4-TimeLockData/%s_timelock_%s_LM.mat',directory,subject{j},subject{j},epoch{e}))
            eval(sprintf('load %s/%s/4-TimeLockData/%s_timelock_%s_OB.mat',directory,subject{j},subject{j},epoch{e}))
            % prepare data for classifiation           
            cfg.trialinfo = 0; cfg.name = {'Face','Landmark','Object'}; cfg.dimension = 2;
            cfg.label = eval(sprintf('%s_timelock_%s_FA.label;',subject{j},epoch{e}));
            eval(sprintf('%s_%s_data_amp = mvpa_dataprep(cfg,%s_timelock_%s_FA.trial,%s_timelock_%s_LM.trial,%s_timelock_%s_OB.trial);'...
                ,subject{j},epoch{e},subject{j},epoch{e},subject{j},epoch{e},subject{j},epoch{e}))
            % save data
            eval(sprintf('cd %s/%s/6-ClassificationData/',directory,subject{j}))
            eval(sprintf('save %s_%s_data_amp %s_%s_data_amp',subject{j},epoch{e},subject{j},epoch{e}))
        elseif strcmp(epoch{e},'test')
            for r = 1:length(response)
                fprintf('Starting %s.../n',response{r});
                % load data
                eval(sprintf('load %s/%s/4-TimeLockData/%s_timelock_%s_FA_%s.mat',directory,subject{j},subject{j},epoch{e},response{r}))
                eval(sprintf('load %s/%s/4-TimeLockData/%s_timelock_%s_LM_%s.mat',directory,subject{j},subject{j},epoch{e},response{r}))
                eval(sprintf('load %s/%s/4-TimeLockData/%s_timelock_%s_OB_%s.mat',directory,subject{j},subject{j},epoch{e},response{r}))
                % prepare data for classifiation
                cfg.label = eval(sprintf('%s_timelock_%s_FA_%s.label;',subject{j},epoch{e},response{r}));
                cfg.trialinfo = 1; cfg.name = {'Face','Landmark','Object'}; cfg.dimension = 2;
                eval(sprintf('cfg.specifytrialinfo = [%s_timelock_test_FA_%s.trialinfo;%s_timelock_test_LM_%s.trialinfo;%s_timelock_test_OB_%s.trialinfo];'...
                    ,subject{j},response{r},subject{j},response{r},subject{j},response{r}))
                eval(sprintf('%s_%s_data_amp_%s = mvpa_dataprep(cfg,%s_timelock_%s_FA_%s.trial,%s_timelock_%s_LM_%s.trial,%s_timelock_%s_OB_%s.trial);',...
                    subject{j},epoch{e},response{r},subject{j},epoch{e},response{r},subject{j},epoch{e},response{r},subject{j},epoch{e},response{r}))
                % save data
                eval(sprintf('cd %s/%s/6-ClassificationData/',directory,subject{j}))
                eval(sprintf('save %s_%s_data_amp_%s %s_%s_data_amp_%s',subject{j},epoch{e},response{r},subject{j},epoch{e},response{r}))
            end
        end
        fprintf('%s %s finished.../n',subject{j},epoch{e});
        %----------------------------------------------------------------------
        % Clear from memory variables from the current subject
        %----------------------------------------------------------------------
        clearvars -except cfg directory e epoch j r response subject condition
    end
end
toc