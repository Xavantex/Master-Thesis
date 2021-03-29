%------------------------------------------------------------------------------
%  TEST THE CROSS VALIDATED CLASSIFIER ON THE RETRIEVAL DATA
%------------------------------------------------------------------------------
%  USE DATA FROM visual CLASSIFIED TRIALS - FREQUENCY
%------------------------------------------------------------------------------
clear all

%Visual
directory  = 'DataDirectory\\Visual\\'; %directory of the data
%subject = {'Subj01' 'Subj02' 'Subj03' 'Subj04' 'Subj05' 'Subj06' 'Subj07' 'Subj08' 'Subj09' 'Subj11' 'Subj12' 'Subj13' 'Subj14' 'Subj15' 'Subj16' 'Subj17' 'Subj18' 'Subj19'};
subject = {'Subj01'};
epoch = {'study'};

%Verbal
% directory  = '//psysrv004/psymemlab/Projects/TAPMVPA-LTH/Verbal/'; %directory of the data
% subject = {'Subj01' 'Subj02' 'Subj06' 'Subj07' 'Subj08' 'Subj09' 'Subj10' 'Subj11'...
%     'Subj12' 'Subj14' 'Subj15' 'Subj16' 'Subj17' 'Subj18' 'Subj19' 'Subj20' 'Subj21' 'Subj22'};


for j = 1:length(subject)
    for e = 1:length(epoch)
        disp(subject{j})
        cd(sprintf('%s%s',directory,subject{j},'/6-ClassificationData/'));
        eval(sprintf('load %s_test_data_visual %s_test_data_visual',subject{j},subject{j})) %give imput data
        eval(sprintf('cd %s/%s/7-ClassifierTraining/',directory,subject{j}))
        eval(sprintf('load %s_%s_crossvalclass %s_%s_crossvalclass',subject{j},epoch{e},subject{j},epoch{e})) %give classifier
        % apply calssifier into the correct visual/ correct visual trials
        cfg = []; cfg.fold = 10; cfg.classifiernumber = 20; cfg.timebinsnumber = 20;
        cfg.category_predict = {'Face' 'Landmark' 'Object'}; cfg.trials = 'all';
        cfg.category_model = {'Face' 'Landmark' 'Object'};
        eval(sprintf('%s_%s_predtest_visual = mvpa_applycrossvalclassifier(cfg,%s_%s_crossvalclass,%s_test_data_visual);',subject{j},epoch{e},subject{j},epoch{e},subject{j}))
        disp(subject{j})
        disp('Done!')
        eval(sprintf('cd %s/%s/8-ClassifierTesting/',directory,subject{j}))
        eval(sprintf('save %s_%s_predtest_visual %s_%s_predtest_visual',subject{j},epoch{e},subject{j},epoch{e}))
        % Performance
        cfg = []; cfg.performance = 2; cfg.category_model = {'Face' 'Landmark' 'Object'};
        cfg.category_predict = {'Face' 'Landmark' 'Object'};
        cfg.classifiernumber = 20; cfg.timebinsnumber = 20;
        eval(sprintf('%s_%s_predtest_visual_performance = mvpa_classifierperf(cfg,%s_%s_predtest_visual);',subject{j},epoch{e},subject{j},epoch{e}))
        eval(sprintf('save %s_%s_predtest_visual_performance %s_%s_predtest_visual_performance',subject{j},epoch{e},subject{j},epoch{e}))
        disp('Performance calculated!')
    end
end
