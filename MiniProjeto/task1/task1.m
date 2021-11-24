% task 1 - Use simulator 1
% 1.a - C = 10 Mbps and f = 1.000.000 Bytes. Run Simulator1 50 times with a
% stopping criterion of P = 10000. 90% confidence intervals of the average 
% delay performance parameter when lambda = 400, 800, 1200, 1600 and 2000 pps.

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
    fprintf('EXERCISE A:\n');
    % Calculate Packet Loss
    PL = mean(PL_lst);
    PL_conf = norminv(1-alfa/2)*sqrt(var(PL_lst)/N);
    fprintf('Packet Loss (%%)= %.2e +-%.2e\n',PL,PL_conf);

    % Calculate Average Packet Delay
    APD = mean(APD_lst);
    APD_conf = norminv(1-alfa/2)*sqrt(var(APD_lst)/N);
    fprintf('Av. Packet Delay (ms)= %.2e +-%.2e\n',APD,APD_conf);

    % Calculate Maximum Packet Delay
    MPD = mean(MPD_lst);
    MPD_conf = norminv(1-alfa/2)*sqrt(var(MPD_lst)/N);
    fprintf('Max. Packet Delay (ms)= %.2e +-%.2e\n',MPD,MPD_conf);

    % Calculate Throughput
    TT = mean(TT_lst);
    TT_conf = norminv(1-alfa/2)*sqrt(var(TT_lst)/N);
    fprintf('Throughput (Mbps)= %.2e +-%.2e\n',TT,TT_conf);
    
    PL_Results(index) = PL;
    APD_Results(index) = APD;
    MPD_Results(index) = MPD;
    TT_Results(index) = TT;
end
