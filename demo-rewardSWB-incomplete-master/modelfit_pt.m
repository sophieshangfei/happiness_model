function result = modelfit_pt(indata)

% RESULT = modelfit_pt(DATA)
%
% Does Prospect Theory model fit

% Robb Rutledge, January 2017


data = struct([]);
data(1).data = indata.behavedata(2:end,[3 4 5 7]);
% data.data should be 4-column matrix (certain, gain, loss(neg numbers), choice=1or0)


options = optimset('Display','off','MaxIter',100000,'TolFun',1e-10,'TolX',1e-10,...
    'DiffMaxChange',1e-2,'DiffMinChange',1e-4,'MaxFunEvals',10000,'LargeScale','off');
warning off; %display,iter to see outputs
%eps should work but for some reason if the min is eps, it will still try
%negative numbers and the LL will be NaN and it will not converge

inx = [1     1.1  0.8   0.8 0.2 -0.4];
lb =  [0.01  0.5  0.3   0.3 -1.0 -5.0]; %min for data set
ub =  [20     5  1.3   1.3 1.0 5.0]; %mu/lambda/alphagain/alphaloss/betagain/betaloss
% betalabel = {'mu','lambda','alpha+','alpha-'}; 
betalabel = {'mu','lambda','alpha+','alpha-', 'beta+', 'beta-'};
dof = length(inx);
result = struct;
result.data = data.data;
result.inx = inx;
result.lb = lb;
result.ub = ub;
result.options = options;
result.betalabel = betalabel;

try
    [b, ~, exitflag, output, ~, ~, H] = fmincon(@model_param, inx, [],[],[],[],lb,ub,[], options, data);
    clear temp;
    [loglike, utildiff, logodds, probchoice] = model_param(b, data);
    result.b  = b;
    result.H  = H;
    se      = transpose(sqrt(diag(inv(result.H))));
    result.se = se(:);
    result.modelLL    = -loglike;
    result.nullLL     = log(0.5)*length(probchoice);
    result.pseudoR2   = 1 + loglike / result.nullLL;
    result.LRstat     = -2*(result.nullLL - result.modelLL);
    result.LRtestp    = chi2pdf(result.LRstat,length(b));
    result.exitflag   = exitflag;
    result.output     = output;
    result.utildiff   = utildiff;
    result.logodds    = logodds;
    result.probchoice = probchoice;
catch
    lasterr
end;


function [loglike, utildiff, logodds, probchoice] = model_param(x, data)

data.mu        = x(1);
data.lambda    = x(2);
data.alpha     = x(3);
data.beta      = x(4);
data.gamma     = x(5);
data.omega     = x(6);

[loglike, utildiff, logodds, probchoice] = pt_model(data);
