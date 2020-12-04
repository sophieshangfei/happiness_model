function result = fit_happy_model_rewardSWB(certainmtx,evmtx,rpemtx,happyscore,constant)

% result = fit_happy_model_rewardSWB(certainmtx,evmtx,rpemtx,happyscore,constant)
%
% fit happiness model with constant term:
%    result = fit_happy_model_rewardSWB(certainmtx,evmtx,rpemtx,rawhappy,1)
% fit happiness model with z-scored ratings:
%    result = fit_happy_model_rewardSWB(certainmtx,evmtx,rpemtx,zhappy)
%
% Robb Rutledge, November 2014

result.certainmtx = certainmtx;
result.evmtx      = evmtx;
result.rpemtx     = rpemtx;
result.rewardmtx  = certainmtx+evmtx+rpemtx; %all outcomes
result.happyscore = happyscore;

inx = [0.5 0.5 0.2 0.5];
options = optimset('Display','off','MaxIter',1000,'TolFun',1e-5,'TolX',1e-5,...
    'DiffMaxChange',1e-2,'DiffMinChange',1e-4,'MaxFunEvals',1000,'LargeScale','off');
warning off; %display,iter to see outputs
lb = [-5 -5 -1 0]; %larger bounds maybe needed if z-scored
ub = [5 5 1 1]; %max tau of 1.1 or use 1.5
%lb = [-1 0];
%ub = [1 1]; %max tau of 1.1 or use 1.5
if exist('constant'),
    inx = [inx 0.5];
    lb = [lb 0.01];
    ub = [ub 0.99];
end;

result.inx = inx;
dof = length(inx);
result.options = options;
result.lb = lb;
result.ub = ub;
result.b = zeros(1,length(inx));
result.se = result.b;
result.r2 = 0;
result.happypred = 0;

[b, ~, ~, ~, ~, ~, H] = fmincon(@model_param, inx, [],[],[],[],lb,ub,[], options, result);
%result.blabel = {'reward','tau','const'};
result.blabel = {'certain','ev','rpe','tau','const'};
result.b      = b;
result.se     = transpose(sqrt(diag(inv(H)))); %does not always work
[sse, happypred, happyr2] = model_param(b, result);
result.happypred = happypred;
result.r2     = happyr2;
result.sse    = sse;


function [sse, happypred, happyr2] =  model_param(x, data)

a   = x(1); %reward
tau = x(4); %decay constant
c = x(2); % ev
b = x(3); % rpe
if length(x)==5, const = x(5); else const = 0; 

end;

decayvec  = tau.^[0:size(data.rewardmtx,2)-1]; decayvec = decayvec(:);
reward    = data.rewardmtx; dec = decayvec;
ev        = data.evmtx;
rpe       = data.rpemtx;
happypred = a*reward*dec + b*rpe*dec + c*ev*dec + const;
sse       = sum((data.happyscore-happypred).^2); %sum least-squares error
re        = sum((data.happyscore-mean(data.happyscore)).^2); happyr2 = 1-sse/re;