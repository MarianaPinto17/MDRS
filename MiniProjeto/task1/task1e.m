%close all, clear all, clc

% lambda = 1800 pps and f = 1.000.000 Bytes. N=50, P = 10000,
% 90% confidence intervals and C = 10, 20, 30 and 40 Mbps. 
% Present the average packet delay results in bar charts with the confidence
% intervals in error bars. 

fprintf('Task 1 - Alinea E\n');

P = 10000;
lambda = 1800;
Carray = [10, 20, 30, 40];
f = 1000000;

for index=1:numel(Carray)
    N = 50;
    alfa=0.1;
    PL_lst = zeros(1,N);
    APD_lst = zeros(1,N);
    APD_lst_64 = zeros(1,N);
    APD_lst_110 = zeros(1,N);
    APD_lst_1518 = zeros(1,N);
    MPD_lst = zeros(1,N);
    TT_lst = zeros(1,N);
    
    for i = 1:N
        [PL_lst(i),APD_lst(i),APD_lst_64(i),APD_lst_110(i),APD_lst_1518(i),MPD_lst(i),TT_lst(i)] = Simulator1New(lambda,Carray(index),f,P);
    end  
    
    fprintf('Valor %d de C:\n',Carray(index));
   
    % Calculate Average Packet Delay
    % pode dar jeito para comparar os resultados por isso nao apaguei
    %APD = mean(APD_lst);
    %APD_conf = norminv(1-alfa/2)*sqrt(var(APD_lst)/N);
    %fprintf('Av. Packet Delay (ms)= %.2e +-%.2e\n',APD,APD_conf);

    APD_64 = mean(APD_lst_64);
    APD_conf_64 = norminv(1-alfa/2)*sqrt(var(APD_lst_64)/N);
    fprintf('Av. Packet Delay with size 64 (ms)= %.2e +-%.2e\n',APD_64,APD_conf_64);

    APD_110 = mean(APD_lst_110);
    APD_conf_110 = norminv(1-alfa/2)*sqrt(var(APD_lst_110)/N);
    fprintf('Av. Packet Delay with size 110 (ms)= %.2e +-%.2e\n',APD_110,APD_conf_110);

    APD_1518 = mean(APD_lst_1518);
    APD_conf_1518 = norminv(1-alfa/2)*sqrt(var(APD_lst_1518)/N);
    fprintf('Av. Packet Delay with size 1518 (ms)= %.2e +-%.2e\n',APD_1518,APD_conf_1518);


    %APD_Resultsc(index) = APD;
    %APD_Erroc(index) = APD_conf;

    APD_Resultsc_64(index) = APD_64;
    APD_Erroc_64(index) = APD_conf_64;

    APD_Resultsc_110(index) = APD_110;
    APD_Erroc_110(index) = APD_conf_110;
    APD_Resultsc_1518(index) = APD_1518;
    APD_Erroc_1518(index) = APD_conf_1518;

end

% pode dar jeito para comparar os resultados por isso nao apaguei
%figure(4);
%bar(Carray,APD_Resultsc);
%xlabel("Link bandwidth (Mbps)");
%ylabel("Packet Delay");
%title(["Average Packet Delay"]);
%hold on
%er = errorbar(Carray,APD_Resultsc,APD_Erroc,APD_Erroc);    
%er.Color = [0 0 0];                            
%er.LineStyle = 'none';
%hold off

figure(1);
bar(Carray,APD_Resultsc_64);
grid on 
xlabel("Link bandwidth (Mbps)");
ylim([0 6])
ylabel("Packet Delay");
title(["Average Packet Delay Size 64 - Alinea E"]);
hold on
er = errorbar(Carray,APD_Resultsc_64,APD_Erroc_64,APD_Erroc_64);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
hold off


figure(2);
bar(Carray,APD_Resultsc_110);
grid on 
xlabel("Link bandwidth (Mbps)");
ylim([0 6])
ylabel("Packet Delay");
title(["Average Packet Delay Size 110 - Alinea E"]);
hold on
er = errorbar(Carray,APD_Resultsc_110,APD_Erroc_110,APD_Erroc_110);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
hold off

figure(3);
bar(Carray,APD_Resultsc_1518);
grid on 
xlabel("Link bandwidth (Mbps)");
ylim([0 6])
ylabel("Packet Delay");
title(["Average Packet Delay Size 1518 - Alinea E"]);
hold on
er = errorbar(Carray,APD_Resultsc_1518,APD_Erroc_1518,APD_Erroc_1518);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';
hold off



