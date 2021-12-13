%close all, clear all, clc

% task 1 - Use simulator 1
% 1.a - C = 10 Mbps and f = 1.000.000 Bytes. Run Simulator1 50 times with a
% stopping criterion of P = 10000. 90% confidence intervals of the average 
% delay performance parameter when lambda = 400, 800, 1200, 1600 and 2000 pps.
% Present the average packet delay results in bar charts with the
% confidence intervals in error bars.

fprintf('Task 1 - Alinea A\n');
P = 10000;
lambdaArray = [400,800,1200,1600,2000];
C = 10;
f = 1000000;

for index=1:numel(lambdaArray)
    N = 50;
    alfa=0.1;
    PL_lst = zeros(1,N);
    APD_lst = zeros(1,N);
    MPD_lst = zeros(1,N);
    TT_lst = zeros(1,N);
    
    for i = 1:N
        [PL_lst(i),APD_lst(i),MPD_lst(i),TT_lst(i)] = Simulator1(lambdaArray(index),C,f,P);
    end  
    
    fprintf('Valor %d de labmda:\n',lambdaArray(index));
    % Calculate Average Packet Delay
    APD = mean(APD_lst);
    APD_conf = norminv(1-alfa/2)*sqrt(var(APD_lst)/N);
    fprintf('Av. Packet Delay (ms)= %.2e +-%.2e\n',APD,APD_conf);
    APD_Results(index) = APD;
    APD_Erro(index) = APD_conf;
end

figure(1);
bar(lambdaArray,APD_Results);
grid on
xlabel("Packet Rate (pps)");
ylabel("Packet Delay");
title(["Average Packet Delay - Alinea A"]);
hold on
er = errorbar(lambdaArray,APD_Results,APD_Erro,APD_Erro);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
hold off
