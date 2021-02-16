clear
clc
format long

%%
l = 1:25;
hl = 2.^(-l);
P1 = 0.01;
P2 = 0.001;
thresholdParameter001 = norminv((1-P1).^(hl));
thresholdParameter0001 = norminv((1-P2).^(hl));



%%
m = 1000;

figure(1)
hold on
plot(thresholdParameter001/sqrt(m));
plot(thresholdParameter0001/sqrt(m));
axis([min(l) max(l) 0 1]);
hold off


%disp(thresholdParameter001)
%disp(thresholdParameter0001)

%%

save('+ParameterIdentification/thresholdParameter001.mat','thresholdParameter001')
save('+ParameterIdentification/thresholdParameter0001.mat','thresholdParameter0001')
