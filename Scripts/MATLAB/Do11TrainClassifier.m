%--------------------------------------------------------------------------
% Training the Classifier
% Frequency
%--------------------------------------------------------------------------
clear all

%Visual
directory  = 'DataDirectory\\Visual\\'; %directory of the data
%subject = {'Subj01' 'Subj02' 'Subj03' 'Subj04' 'Subj05' 'Subj06' 'Subj07' 'Subj08' 'Subj09' 'Subj11' 'Subj12' 'Subj13' 'Subj14' 'Subj15' 'Subj16' 'Subj17' 'Subj18' 'Subj19'};
subject = {'Subj01'};

%Verbal
% directory  = '//psysrv004/psymemlab/Projects/TAPMVPA-LTH/Verbal/'; %directory of the data
% subject = {'Subj01' 'Subj02' 'Subj06' 'Subj07' 'Subj08' 'Subj09' 'Subj10' 'Subj11'...
%     'Subj12' 'Subj14' 'Subj15' 'Subj16' 'Subj17' 'Subj18' 'Subj19' 'Subj20' 'Subj21' 'Subj22'};


epoch = {'study'};
response = {'visual'}; %if Verbal, reponse lexical

for j = 1:length(subject)
    disp(subject{j})
    for e  =  1:length(epoch)
        cd(sprintf('%s%s%s',directory,subject{j},'/6-ClassificationData/'));
        eval(sprintf('load %s_%s_data %s_%s_data',subject{j},epoch{e},subject{j},epoch{e}))
        % partiation of the data
        cfg = []; cfg.classifiernumber = 20; cfg.fold = 10;
        eval(sprintf('%s_%s_datapart = mvpa_datapartition(cfg,%s_%s_data);',subject{j},epoch{e},subject{j},epoch{e}))
        disp('Data was partitioned and feature reduction for each partion is complete')
        %Train the cross validated classifier
        cfg = []; cfg.training_algorithm = 1; cfg.fold = 10; cfg.classifiernumber = 20; cfg.category_model = {'Face' 'Landmark' 'Object'};
        eval(sprintf('%s_%s_crossvalclass = mvpa_traincrossvalclassifier(cfg,%s_%s_datapart);',subject{j},epoch{e},subject{j},epoch{e}))
        disp('Cross Validated model successfully performed!')
        %Performance
        cfg = []; cfg.performance = 1; cfg.category_model = {'Face' 'Landmark' 'Object'};
        cfg.classifiernumber = 20;
        eval(sprintf('%s_%s_crossvalclass_performance = mvpa_classifierperf(cfg,%s_%s_crossvalclass);',subject{j},epoch{e},subject{j},epoch{e}))
        disp('Performance calculated!')        
        %save
        eval(sprintf('cd %s/%s/7-ClassifierTraining/',directory,subject{j}))
        eval(sprintf('save %s_%s_crossvalclass %s_%s_crossvalclass',subject{j},epoch{e},subject{j},epoch{e}))
        eval(sprintf('save %s_%s_datapart %s_%s_datapart',subject{j},epoch{e},subject{j},epoch{e}))
        eval(sprintf('save %s_%s_crossvalclass_performance %s_%s_crossvalclass_performance',subject{j},epoch{e},subject{j},epoch{e}))
        eval(sprintf('clear %s_%s_crossvalclass %s_%s_datapart',subject{j},epoch{e},subject{j},epoch{e}))
    end
end
% 

%--------------------------------------------------------------------------
% Training the Classifier
% Amplitude
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


epoch = {'study'};
response = {'visual'}; %if Verbal, reponse lexical

for j = 1:length(subject)
    display (subject{j})
    for e  =  1:length(epoch)
        cd(sprintf('%s%s%s',directory,subject{j},'/6-ClassificationData/'));
        eval(sprintf('load %s_%s_data_amp %s_%s_data_amp',subject{j},epoch{e},subject{j},epoch{e}))
        % partiation of the data
        cfg = []; cfg.classifiernumber = 40; cfg.fold = 10;
        eval(sprintf('%s_%s_datapart_amp = mvpa_datapartition(cfg,%s_%s_data_amp);',subject{j},epoch{e},subject{j},epoch{e}))
        disp('Data was partitioned and feature reduction for each partion is complete')
        %Train the cross validated classifier
        cfg = []; cfg.training_algorithm = 1; cfg.fold = 10; cfg.classifiernumber = 40; cfg.category_model = {'Face' 'Landmark' 'Object'};
        eval(sprintf('%s_%s_crossvalclass_amp = mvpa_traincrossvalclassifier(cfg,%s_%s_datapart_amp);',subject{j},epoch{e},subject{j},epoch{e}))
        disp('Cross Validated model successfully performed!')
        %Performance
        cfg = []; cfg.performance = 1; cfg.category_model = {'Face' 'Landmark' 'Object'};
        cfg.classifiernumber = 40;
        eval(sprintf('%s_%s_crossvalclass_performance_amp = mvpa_classifierperf(cfg,%s_%s_crossvalclass_amp);',subject{j},epoch{e},subject{j},epoch{e}))
        disp('Performance calculated!')        
        %save
        eval(sprintf('cd %s/%s/7-ClassifierTraining/',directory,subject{j}))
        eval(sprintf('save %s_%s_crossvalclass_amp %s_%s_crossvalclass_amp',subject{j},epoch{e},subject{j},epoch{e}))
        eval(sprintf('save %s_%s_datapart_amp %s_%s_datapart_amp',subject{j},epoch{e},subject{j},epoch{e}))
        eval(sprintf('save %s_%s_crossvalclass_performance_amp %s_%s_crossvalclass_performance_amp',subject{j},epoch{e},subject{j},epoch{e}))
        eval(sprintf('clear %s_%s_crossvalclass %s_%s_datapart',subject{j},epoch{e},subject{j},epoch{e}))
    end
end