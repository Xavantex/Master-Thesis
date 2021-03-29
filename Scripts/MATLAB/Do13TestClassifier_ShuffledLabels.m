%------------------------------------------------------------------------------
%  PERMUTATION FOR EACH PARTICIPANT!!!! FREQUENCY
%------------------------------------------------------------------------------
clear all
tic
%Visual
directory  = 'F:\\EXJOBB\\to_xavante\\Visual\\'; %directory of the data
%subjects = {'Subj01' 'Subj02' 'Subj03' 'Subj04' 'Subj05' 'Subj06' 'Subj07' 'Subj08' 'Subj09' 'Subj11' 'Subj12' 'Subj13' 'Subj14' 'Subj15' 'Subj16' 'Subj17' 'Subj18' 'Subj19'};
subjects = {'Subj01'};
epoch = {'study'};
% Keeping the number of permutations low just to save time for now:
NOF_PERMUTATIONS = 5;
%NOF_PERMUTATIONS = 5;

%Verbal
% directory  = '//psysrv004/psymemlab/Projects/TAPMVPA-LTH/Verbal/'; %directory of the data
% subject = {'Subj01' 'Subj02' 'Subj06' 'Subj07' 'Subj08' 'Subj09' 'Subj10' 'Subj11'...
%     'Subj12' 'Subj14' 'Subj15' 'Subj16' 'Subj17' 'Subj18' 'Subj19' 'Subj20' 'Subj21' 'Subj22'};

tstart = tic;
for j = 1:length(subjects)
    for e = 1:length(epoch)
        display (subjects{j})
        cd(sprintf('%s%s',directory,subjects{j},'/6-ClassificationData/'));
        eval(sprintf('load %s_test_data_visual %s_test_data_visual',subjects{j},subjects{j})) %give imput data
        eval(sprintf('cd %s/%s/7-ClassifierTraining/',directory,subjects{j}))
        eval(sprintf('load %s_%s_crossvalclass %s_%s_crossvalclass',subjects{j},epoch{e},subjects{j},epoch{e}))
        
        for PERMUTATION = 1:NOF_PERMUTATIONS %Number of Permutations
            eval(sprintf('R = randperm(length(%s_test_data_visual.category_name));',subjects{j}))
            eval(sprintf('PER%d.category_name=%s_test_data_visual.category_name(R);',PERMUTATION,subjects{j}))
            eval(sprintf('PER%d.category=%s_test_data_visual.category(R);',PERMUTATION,subjects{j}))
            eval(sprintf('PER%d.feature_name = %s_test_data_visual.feature_name;',PERMUTATION,subjects{j}))
            eval(sprintf('PER%d.trialinfo = %s_test_data_visual.trialinfo;',PERMUTATION,subjects{j}))
            eval(sprintf('PER%d.feature = %s_test_data_visual.feature;',PERMUTATION,subjects{j}))
            eval(sprintf('PER%d.numclassifiers = %s_test_data_visual.numclassifiers;',PERMUTATION,subjects{j}))
            
            % apply calssifier into the shuffled category trials
            cfg.fold = 10; cfg.classifiernumber = 20; cfg.timebinsnumber = 20;
            cfg.category_predict = {'Face' 'Landmark' 'Object'}; cfg.trials = 'all';
            cfg.category_model = {'Face' 'Landmark' 'Object'};
            eval(sprintf('PER%d_predtest = mvpa_applycrossvalclassifier(cfg,%s_%s_crossvalclass,PER%d);',PERMUTATION,subjects{j},epoch{e},PERMUTATION))
            
            %Construct and save the Permutation Map
            tstartin = tic;
            for col = 1:20 %timebins at retrieval
                for row = 1:20 %classifiers
                    eval(sprintf('trials = sum(PER%d_predtest.timebin{col}.confmatfinal{row},2);',PERMUTATION))
                    eval(sprintf('%s_P%d(row,col) = ((PER%d_predtest.timebin{col}.confmatfinal{row}(1,1)/trials(1)*100) + (PER%d_predtest.timebin{col}.confmatfinal{row}(2,2)/trials(2)*100) + (PER%d_predtest.timebin{col}.confmatfinal{row}(3,3)/trials(3)*100))/3;',subjects{j},PERMUTATION,PERMUTATION,PERMUTATION,PERMUTATION))
                end
            end
            tendin = toc(tstartin);
            eval(sprintf('cd %s/%s/8-ClassifierTesting/PermutationStudyDecodeTestVisual',directory,subjects{j}));
            eval(sprintf('save %s_P%d %s_P%d',subjects{j},PERMUTATION,subjects{j},PERMUTATION));
            eval(sprintf('clear %s_P%d PER% PER%d_predtest',subjects{j},PERMUTATION,PERMUTATION,PERMUTATION));
            fprintf('Permutation %d done! /n', PERMUTATION);
        end
    end
end
fprintf('First Loop %s', toc(tstart));
fprintf('Inner first loop %s', tendin);

%------------------------------------------------------------------------------
% For each permutation a T-Test is calculated
% (classification accuracy is compared against chance (33.33))
% Each T test is stored in a Struture called Random_Distribution
%------------------------------------------------------------------------------ 
clear all
directory  = 'F:\\EXJOBB\\to_xavante\\Visual\\'; %directory of the data
%subjects = {'Subj01' 'Subj02' 'Subj03' 'Subj04' 'Subj05' 'Subj06' 'Subj07' 'Subj08' 'Subj09' 'Subj11' 'Subj12' 'Subj13' 'Subj14' 'Subj15' 'Subj16' 'Subj17' 'Subj18' 'Subj19'};
subjects = {'Subj01'};
NOF_PERMUTATIONS = 5;

%InfoSubjects_mvpa
%subjects = fieldnames(Infosubjects);
%Infosubjects = struct2cell(Infosubjects);
epoch = {'study'};
tstart = tic;
Permutation_total(1,1:20) = 0;
for PERMUTATION = 1:NOF_PERMUTATIONS
    for e = 1:length(epoch)
        for j = 1:length(subjects)
            eval(sprintf('cd %s/%s/8-ClassifierTesting/PermutationStudyDecodeTestVisual',directory,subjects{j}))
            eval(sprintf('load %s_P%d',subjects{j},PERMUTATION))
            eval(sprintf('%s_P%d = imgaussfilt(%s_P%d,1);',subjects{j},PERMUTATION,subjects{j},PERMUTATION))
        end
        ttendin = tic;
        tendin = tic;
        for col = 1:20 %timebins at retrieval
            for row = 1:20 %classifiers
                for j = 1:length(subjects)
                    eval(sprintf('X(j) = %s_P%d(row,col);',subjects{j},PERMUTATION));
                end
                ttendin = tic;
                [H,P,CI,STATS] = ttest(X,33.33,'tail','both');
                ttendin = toc(ttendin);
                eval(sprintf('T_P%d(row,col) = STATS(1).tstat;',PERMUTATION));
                eval(sprintf('P_P%d(row,col) = P;',PERMUTATION));
            end
        end
        tendin = toc(tendin);
        for j = 1:length(subjects)
            eval(sprintf('clear %s_P%d',subjects{j},PERMUTATION))
        end
        fprintf('permutation %d.../n',PERMUTATION);
        
        eval(sprintf('Random_Distribution.Plevel{%d} = P_P%d;',PERMUTATION,PERMUTATION));
        eval(sprintf('Random_Distribution.Ttest{%d} = T_P%d;',PERMUTATION,PERMUTATION));
    end
end

save Random_Distribution Random_Distribution
fprintf('Second loop %s', toc(tstart));
fprintf('Second inner loop %s', tendin);
fprintf('Second in inner loop %s', ttendin);
