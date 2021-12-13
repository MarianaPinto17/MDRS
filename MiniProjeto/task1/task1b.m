%close all, clear all, clc
% 1.b - lambda = 1800 pps and C = 10 Mbps, P = 10000 and 90% confidence 
% intervals of the average delay and packet loss performance parameters 
% when f = 100.000, 20.000, 10.000 and 2.000 Bytes. 
% Present the average packet delay results in one figure and the average 
% packet loss results in another figure (in both cases, in bar charts
% with the confidence intervals in error bars)

fprintf('Task 1 - Alinea B\n');

P = 10000;
lambda = 1800;
C = 10;
farray = [100000, 20000, 10000, 2000];

for index=1:numel(farray)
    N = 50;
    alfa=0.1;
    PL_lst = zeros(1,N);
    APD_lst = zeros(1,N);
    MPD_lst = zeros(1,N);
    TT_lst = zeros(1,N);
    
    for i = 1:N
        [PL_lst(i),APD_lst(i),MPD_lst(i),TT_lst(i)] = Simulator1(lambda,C,farray(index),P);
    end  
    
    fprintf('Valor %d de f :\n',farray(index));  
    
    % Calculate Average Packet Delay
    APD = mean(APD_lst);
    APD_conf = norminv(1-alfa/2)*sqrt(var(APD_lst)/N);
    fprintf('Av. Packet Delay (ms)= %.2e +-%.2e\n',APD,APD_conf);
    APD_Resultsb(index) = APD;
    APD_Errob(index) = APD_conf;
    
    % Calculate Average Packet Loss
    PL = mean(PL_lst);
    PL_conf = norminv(1-alfa/2)*sqrt(var(PL_lst)/N);
    fprintf('Av. Packet Loss (%%)= %.2e +-%.2e\n',PL,PL_conf);
    PL_Resultsb(index)= PL;
    PL_Errob(index)= PL_conf;
end

figure(1);
bar(farray,APD_Resultsb);
grid on 
xlabel("Queue size (Bytes)");
ylim([0 11])
ylabel("Packet Delay");
title(["Average Packet Delay - Alinea B"]);
hold on
er = errorbar(farray,APD_Resultsb,APD_Errob,APD_Errob);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
hold off

figure(2);
bar(farray,PL_Resultsb);
grid on
xlabel("Queue size (Bytes)");
ylim([0 11])
ylabel("Packet Lost");
title(["Average Packet Lost - Alinea B"]);
hold on
er = errorbar(farray,PL_Resultsb,PL_Errob,PL_Errob);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
hold off