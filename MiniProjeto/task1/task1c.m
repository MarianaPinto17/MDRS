%close all, clear all, clc

% lambda = 1800 pps and f = 1.000.000 Bytes. N=50, P = 10000,
% 90% confidence intervals and C = 10, 20, 30 and 40 Mbps. 
% Present the average packet delay results in bar charts with the confidence
% intervals in error bars. 

fprintf('Task 1 - Alinea C\n');

P = 10000;
lambda = 1800;
Carray = [10, 20, 30, 40];
f = 1000000;

for index=1:numel(Carray)
    N = 50;
    alfa=0.1;
    PL_lst = zeros(1,N);
    APD_lst = zeros(1,N);
    MPD_lst = zeros(1,N);
    TT_lst = zeros(1,N);
    
    for i = 1:N
        [PL_lst(i),APD_lst(i),MPD_lst(i),TT_lst(i)] = Simulator1(lambda,Carray(index),f,P);
    end  
    
    fprintf('Valor %d de C:\n',Carray(index));
    % Calculate Average Packet Delay
    APD = mean(APD_lst);
    APD_conf = norminv(1-alfa/2)*sqrt(var(APD_lst)/N);
    fprintf('Av. Packet Delay (ms)= %.2e +-%.2e\n',APD,APD_conf);
    APD_Resultsc(index) = APD;
    APD_Erroc(index) = APD_conf;
end

figure(1);
bar(Carray,APD_Resultsc);
grid on
xlabel("Link bandwidth (Mbps)");
ylabel("Packet Delay");
title(["Average Packet Delay"]);
hold on
er = errorbar(Carray,APD_Resultsc,APD_Erroc,APD_Erroc);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
hold off
