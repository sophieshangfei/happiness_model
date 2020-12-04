

load('ldopadata_anon.mat');
dataall = [dopadata, placdata]
% create variables score, pred, parameters using placeholders zeros
score = zeros(60,89);
pred = zeros(60,89);
parameters = zeros(60, 5);

%run happiness model fit
for i = 1:60
    data = dataall(i);
    happyresult = modelfit_rewardSWB(data); %currently incomplete code will crash
    score(i,:) = happyresult.happyscore;
    pred(i,:) = happyresult.happypred;
    parameters(i,:) = happyresult.b;
end

%plot happiness model fits
figure('color',[1 1 1]);
subplot(2,2,1); hold on;
plot(mean(score, 1),'b');
plot(mean(pred, 1),'r'); legend('happiness','model fit');
xlabel('Rating number'); ylabel('Happiness'); axis tight; ylim([0 1]);
title('Happiness model prediction vs actual rating using plac and l-DOPA dataset')

mean_parameter = mean(parameters, 1)
nb = length(mean_parameter); %plot all parameters
%nb = 5;
subplot(2,2,2); bar(1:nb,mean_parameter(1:nb)); ylabel('Happiness per £');
set(gca,'xtick',1:nb,'xticklabel',happyresult.blabel(1:nb));
title(sprintf('Happiness model parameters r2=%.3f',happyresult.r2));




%run prospect theory fit

%decisionresult = modelfit_pt(data)
%for n=1:length(decisionresult.b), fprintf(1,'%s = %.3f\n',decisionresult.betalabel{n},decisionresult.b(n)); end;

pt_parameters = zeros(60, 6);
for i = 1:60
    data = dataall(i);
    decisionresult = modelfit_pt(data); %currently incomplete code will crash
    pt_parameters(i,:) = decisionresult.b;
end

% prepare bar plot
dopa_par = pt_parameters(1:30,:);
plac_par = pt_parameters(31:60,:);
mean_dopa = mean(dopa_par, 1);
mean_plac = mean(plac_par, 1);
par = [mean_dopa(1) mean_plac(1); 
    mean_dopa(2) mean_plac(2); 
    mean_dopa(3) mean_plac(3); 
    mean_dopa(4) mean_plac(4); 
    mean_dopa(5) mean_plac(5); 
    mean_dopa(6) mean_plac(6)]

nb_pt = length(mean_pt_parameter); %plot all parameters

%nb = 5;
subplot(2,2,3); bar(par); ylabel('Parameter Estimate');
set(gca,'xtick',1:nb_pt,'xticklabel',decisionresult.betalabel(1:nb_pt));
title('Approach-Avoidance Model Fitted using plac and l-DOPA dataset')
%title(sprintf('r2=%.3f',happyresult.r2));


