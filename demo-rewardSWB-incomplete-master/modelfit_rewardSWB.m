function result = modelfit_rewardSWB(data)

% RESULT = modelfit_rewardSWB(DATA)
%
% example:
%    result = modelfit_rewardSWB(data)
%
% Robb Rutledge, November 2014


%collect decision and happiness measures
data.datalabel    = {'trialno','gambleside','certain','win','loss','buttonpress','chosegamble','outcome','choicert','rating','ratingstart','ratingrt'};
temp              = data.behavedata;
data.meanhappy    = nanmean(temp(:,10)); %mean happiness, SD happiness
data.sdhappy      = nanstd(temp(:,10));
%gambling fractions for overall, gain-only, mixed, loss-only
data.chosegam     = mean(temp(2:end,7));
data.chosegaingam = mean(temp(temp(:,3)>0,7));
data.chosemixgam  = mean(temp(temp(:,3)==0,7));
data.choselossgam = mean(temp(temp(:,3)<0,7));



%for each subject compile a matrix of all certain, ev, and rpe indexed by
%trials ago each rating 
temp       = data.behavedata(2:end,:); %toss first rating
rawhappy   = temp(~isnan(temp(:,10)),10); %60 ratings
zhappy     = (rawhappy-data.meanhappy) / data.sdhappy;
evmtx      = zeros(length(rawhappy),size(temp,1));
certainmtx = evmtx; %all zeros
rpemtx     = evmtx;
rewardmtx  = evmtx;
happyind   = find(~isnan(temp(:,10)));
for m=1:length(happyind), %to first rating
    temp2       = temp(1:happyind(m),:); %clip out all trials up to rating
    tempev      = mean(temp2(:,4:5),2) .* double(temp2(:,7)==1); %0 if no gamble or error, ev if gambled
    temprpe     = temp2(:,8) .* double(temp2(:,7)==1) - tempev; %0 if no gamble or error, rpe if gambled
    tempreward  = temp2(:,8) .* double(temp2(:,7)==1); %gamble rewards (0 if chose certain)
    tempcertain = temp2(:,3) .* double(temp2(:,7)==0); %0 if gambled, otherwise certain amount
    evmtx(m,1:length(tempev))           = fliplr(transpose(tempev)) / 100; %convert to £
    certainmtx(m,1:length(tempcertain)) = fliplr(transpose(tempcertain))/ 100;
    rpemtx(m,1:length(temprpe))         = fliplr(transpose(temprpe)) / 100;
    rewardmtx(m,1:length(tempreward))   = fliplr(transpose(tempreward)) / 100;
end;

result = fit_happy_model_rewardSWB(certainmtx,evmtx,rpemtx,rawhappy,1); %no 1 argument if z-scored
%result = fit_happy_model_rewardSWB(certainmtx,evmtx,rpemtx,zhappy); %z-scored

