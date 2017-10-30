%Use this to read the inputs. Change the output variable name and 'csv'
%file names based on the problem size
%ips6=[load('0_var.csv') load('1_var.csv') load('2_var.csv') load('3_var.csv') load('4_var.csv') load('5_var.csv') load('6_var.csv') load('7_var.csv')];

hiddenLayerSize = 5;
persForTest=0.005;

%----------change this include all the problem sizes----------%
feat_temp = getFeat2(ips6,6);
feat=getFeat2(ips5,5);
feat=[feat;feat_temp];
feat_temp = getFeat2(ips4,4);
feat=[feat;feat_temp];
feat_temp = getFeat2(ips7,7);
feat=[feat;feat_temp];

%-------------Need not change anything after this-------------%
ordering = randperm(size(feat,1));
feat = feat(ordering, :);
 feat_neg=feat;
for i=1:size(feat,1)
    feat_neg(i,1)=typecast( int64(bitxor(typecast(double(feat(i,1)), 'int64'), bitsll(1,randi([44 62],1,1)))), 'double');
end

%---------------Divide samples for training and train the neural net--------%
numTestSamples=floor(size(feat,1)*persForTest);
x_train=feat(numTestSamples+1:end,2:end);
y_train=feat(numTestSamples+1:end,1);

x = x_train';
t = y_train';
trainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.
% Create a Fitting Network

net = fitnet(hiddenLayerSize,trainFcn);
% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
% Train the Network
[net,tr] = train(net,x,t);

%---------------------------Testing--------------------%
x_ptest=feat(1:numTestSamples,2:end);
y_ptest=feat(1:numTestSamples,1);
x_ntest=feat_neg(1:numTestSamples,2:end);
y_ntest=feat_neg(1:numTestSamples,1);

%Test positive
pos_outputs = net(x_ptest');
pos_errors = abs(gsubtract(y_ptest,pos_outputs')./(y_ptest+1e-10));

%Test Negative
neg_outputs = net(x_ntest');
neg_errors = abs(gsubtract(y_ntest,neg_outputs')./(y_ntest+1e-10));
plot_roc(pos_errors,neg_errors)