clear all;
close all;

fprintf("Task 3 - Alinea C\n");
Nodes= [30 70
       350 40
       550 180
       310 130
       100 170
       540 290
       120 240
       400 310
       220 370
       550 380];
   
Links= [1 2
        1 5
        2 3
        2 4
        3 4
        3 6
        3 8
        4 5
        4 8
        5 7
        6 8
        6 10
        7 8
        7 9
        8 9
        9 10];

T= [1  3  1.0 1.0
    1  4  0.7 0.5
    2  7  2.4 1.5
    3  4  2.4 2.1
    4  9  1.0 2.2
    5  6  1.2 1.5
    5  8  2.1 2.5
    5  9  1.6 1.9
    6 10  1.4 1.6];

nNodes= 10;

nLinks= size(Links,1);
nFlows= size(T,1);

B= 625;  %Average packet size in Bytes

co= Nodes(:,1)+j*Nodes(:,2);

L= inf(nNodes);    %Square matrix with arc lengths (in Km)
for i=1:nNodes
    L(i,i)= 0;
end
C= zeros(nNodes);  %Square matrix with arc capacities (in Gbps)
for i=1:nLinks
    C(Links(i,1),Links(i,2))= 10;  %Gbps
    C(Links(i,2),Links(i,1))= 10;  %Gbps
    d= abs(co(Links(i,1))-co(Links(i,2)));
    L(Links(i,1),Links(i,2))= d+5; %Km
    L(Links(i,2),Links(i,1))= d+5; %Km
end
L= round(L);  %Km

MTBF = (450*360*24)./L;
A = MTBF./(MTBF+24); % a= availability
A(isnan(A))=0; % quando a matriz a tiver Nan mete essa posicao a 0 em vez do Nan

%mins de L = shorted path 
[sP nSP]= calculatePaths(L,T,1); %retorna o 1º caminho para cada link que e o melhor
%sP sao os caminhos e o nSp sao os custos dos caminhos sP
av = ones(1,nFlows); %avalibility tudo a 1 - inicializacao
AuxL = -log(A)*100;

[sP2 nSP2]= calculatePaths(AuxL,T,1);%retorna o 1º e o 2º caminhos para cada link que sao os melhores

bandwidth = zeros(1,nLinks);
bt = T(:,3);
bt_2 = T(:,4);
orig = T(:,1);
dest = T(:,2);
no1_link = Links(:,1);
no2_link = Links(:,2);
for i=1:nFlows
    aux = cell2mat(sP{i}); %caminho do fluxo i
    arr = size(aux);
    %ver origem e destino e ver qual é a bt respetivo
    origem = aux(1);
    destino = aux(arr(1,2));
    for k=1:nFlows
        if orig(k)==origem && dest(k) == destino
            capacidade = bt(k);
        end
        if orig(k)==destino && dest(k) == origem
            capacidade = bt_2(k);
        end
    end
    
    for j=1:arr(1,2)-1       %percorrer nós do fluxo i
        no1 = aux(j);
        no2 = aux(j+1);
        for m = 1:nLinks
            if (no1 == no1_link(m) && no2 == no2_link(m)) || (no1 == no2_link(m) && no2 == no1_link(m))
                bandwidth(m) = bandwidth(m) + capacidade;
            end
        end
    end
end

%sP2

bt = T(:,3);
bt_2 = T(:,4);
orig = T(:,1);
dest = T(:,2);
no1_link = Links(:,1);
no2_link = Links(:,2);
for i=1:nFlows
    aux = cell2mat(sP2{i}); %caminho do fluxo i
    arr = size(aux);
    %ver origem e destino e ver qual é a bt respetivo
    origem = aux(1);
    destino = aux(arr(1,2));
    for k=1:nFlows
        if orig(k)==origem && dest(k) == destino
            capacidade = bt(k);
        end
        if orig(k)==destino && dest(k) == origem
            capacidade = bt_2(k);
        end
    end
    
    for j=1:arr(1,2)-1       %percorrer nós do fluxo i
        no1 = aux(j);
        no2 = aux(j+1);
        for m = 1:nLinks
            if (no1 == no1_link(m) && no2 == no2_link(m)) || (no1 == no2_link(m) && no2 == no1_link(m))
                bandwidth(m) = bandwidth(m) + capacidade;
            end
        end
    end
end
bandwidth

