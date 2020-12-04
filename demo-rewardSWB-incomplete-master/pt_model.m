function [loglike, utildiff, logodds, probchoice] = pt_model(data)

% function [loglike, utildiff, logodds, probchoice] = pt_model(data)
% 
% data.data should be a 4-column matrix (certain, gain, loss(neg numbers), choice=1gamor0)
% data.lambda, data.alpha, data.beta, data.mu
%
% Robb Rutledge, November 2014

%utilcertain = (data.data(:,1)>0).*abs(data.data(:,1)).^data.alpha - ...
%    (data.data(:,1)<0).*data.lambda.*abs(data.data(:,1)).^data.beta;
%winutil       = data.data(:,2).^data.alpha;
%lossutil      = -data.lambda*(-data.data(:,3)).^data.beta;
%utilgamble    = 0.5*winutil+0.5*lossutil;
%utildiff      = utilgamble - utilcertain;
%logodds       = data.mu*utildiff;
%probchoice    = 1 ./ (1+exp(-logodds));     %prob of choosing gamble
%choice        = data.data(:,4);

% approach-avoidance model % not specified by Robb
utilcertain = (data.data(:,1)>0).*abs(data.data(:,1)).^data.alpha - ...
    (data.data(:,1)<0).*data.lambda.*abs(data.data(:,1)).^data.beta;
winutil       = data.data(:,2).^data.alpha;
lossutil      = -data.lambda*(-data.data(:,3)).^data.beta;
utilgamble    = 0.5*winutil+0.5*lossutil;
utildiff      = utilgamble - utilcertain;
logodds       = data.mu*utildiff;
if  data.data(:,1)>0
    if data.gamma >= 0
        probchoice = (1 - data.gamma) ./ (1+exp(-logodds)) + data.gamma;
    else
        probchoice = (1 + data.gamma) ./ (1+exp(-logodds));
    end
else
    if data.omega >= 0
        probchoice = (1 - data.omega) ./ (1+exp(-logodds)) + data.omega;
    else
        probchoice = (1 + data.omega) ./ (1+exp(-logodds));
    end
end
%probchoice    = 1 ./ (1+exp(-logodds));     %prob of choosing gamble
choice        = data.data(:,4);

%in the approach-avoidance model, include extra parameters and transform
%probabilities
%change the model so that prob can either be (0,x) or (x,1) but not (x,y)

% If either ? parameter is positive, 
% the function maps choice probabilities 
% in that domain from (?, 1). If either ? parameter is negative, 
% the function maps choice probabilities in that domain from (0, 1+?)

probchoice(probchoice==0) = eps;   %to prevent fminunc crashing from log zero
probchoice(probchoice==1) = 1-eps;

loglike = - (transpose(choice(:))*log(probchoice(:)) + transpose(1-choice(:))*log(1-probchoice(:)));
loglike = sum(loglike); %need on number to minimize

