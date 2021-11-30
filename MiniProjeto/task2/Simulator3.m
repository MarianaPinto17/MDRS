
function [PL_d, PL_v, APD_d, APD_v, MPD_d, MPD_v, TT] = Simulator3(lambda,C,f,P,n)
% INPUT PARAMETERS:
%  lambda - packet rate (packets/sec)
%  C      - link bandwidth (Mbps)
%  f      - queue size (Bytes)
%  P      - number of packets (stopping criterium)
%  n      - number of VoIP packets flows

% OUTPUT PARAMETERS:
%  PLdata   - packet loss of data packtes (%)
%  PLVoIP   - packet loss of VoIP packtes (%)
%  APDdata  - average packet delay of data packets (milliseconds)
%  APDVoIP  - average packet delay of VoIP packets (milliseconds)
%  MPDdata  - maximum packet delay of data packets (milliseconds)
%  MPDVoIP  - maximum packet delay of VoIP packets (milliseconds)
%  TT   - transmitted throughput (data+VoIP) (Mbps)


%Events:
ARRIVAL= 0;       % Arrival of a packet            
DEPARTURE= 1;     % Departure of a packet

%State variables:
STATE = 0;          % 0 - connection free; 1 - connection bysy
QUEUEOCCUPATION= 0; % Occupation of the queue (in Bytes)
QUEUE= [];          % Size and arriving time instant of each packet in the queue

%Statistical Counters:
TRANSMITTEDPACKETS = 0;
TOTALPACKETS = 0;
%Data
TOTALPACKETS_data= 0;       % No. of data packets arrived to the system
LOSTPACKETS_data= 0;        % No. of data packets dropped due to buffer overflow
TRANSMITTEDPACKETS_data= 0; % No. of data transmitted packets
TRANSMITTEDBYTES_data= 0;   % Sum of data the Bytes of transmitted packets
DELAYS_data= 0;             % Sum of data the delays of transmitted packets
MAXDELAY_data= 0;           % Maximum delay among all transmitted data packets

%VoIP
TOTALPACKETS_VoIP= 0;       % No. of packets arrived to the system
LOSTPACKETS_VoIP= 0;        % No. of packets dropped due to buffer overflow
TRANSMITTEDPACKETS_VoIP= 0; % No. of transmitted packets
TRANSMITTEDBYTES_VoIP= 0;   % Sum of the Bytes of transmitted packets
DELAYS_VoIP= 0;             % Sum of the delays of transmitted packets
MAXDELAY_VoIP= 0;           % Maximum delay among all transmitted packets


% Initializing the simulation clock:
Clock= 0;

% Initializing the List of Events with the first ARRIVAL:
tmp= Clock + exprnd(1/lambda);
packetType=0; % tipo data
EventList = [ARRIVAL, tmp, GeneratePacketSize_Data(), tmp, packetType];

packetType=1; % tipo VoIP
for i=1:n
    time = unifrnd (0,0.02); % 20000 ms = 0.02s
    EventList = [EventList; ARRIVAL, time, GeneratePacketSize_VoIP(), time,packetType];
end

%Similation loop:
while TRANSMITTEDPACKETS<P               % Stopping criterium
    EventList= sortrows(EventList,2);    % Order EventList by time
    Event= EventList(1,1);               % Get first event and 
    Clock= EventList(1,2);               %   and
    PacketSize= EventList(1,3);          %   associated
    ArrivalInstant= EventList(1,4);      %   parameters.
    packetType = EventList(1,5);
    EventList(1,:)= [];                  % Eliminate first event
    
    
    switch Event
        case ARRIVAL                     % If first event is an ARRIVAL
            TOTALPACKETS = TOTALPACKETS +1;
            if packetType == 0 % Data
                TOTALPACKETS_data= TOTALPACKETS_data+1;
                tmp= Clock + exprnd(1/lambda);
                EventList = [EventList; ARRIVAL, tmp, GeneratePacketSize_Data(), tmp,packetType];
                if STATE==0
                    STATE= 1;
                    EventList = [EventList; DEPARTURE, Clock + 8*PacketSize/(C*10^6), PacketSize, Clock,packetType];
                else
                    if QUEUEOCCUPATION + PacketSize <= f
                        QUEUE= [QUEUE;PacketSize , Clock,packetType];
                        QUEUEOCCUPATION= QUEUEOCCUPATION + PacketSize;
                    else
                        LOSTPACKETS_data= LOSTPACKETS_data + 1;
                    end
                end
            else %VoIP
                TOTALPACKETS_VoIP= TOTALPACKETS_VoIP+1;
                time = Clock + unifrnd (0.016,0.024); % 20000 ms = 0.02s
                EventList = [EventList; ARRIVAL, time, GeneratePacketSize_VoIP(), time,packetType];
                if STATE==0
                    STATE= 1;
                    EventList = [EventList; DEPARTURE, Clock + 8*PacketSize/(C*10^6), PacketSize, Clock,packetType];
                else
                    if QUEUEOCCUPATION + PacketSize <= f
                        QUEUE= [QUEUE;PacketSize , Clock,packetType];
                        QUEUEOCCUPATION= QUEUEOCCUPATION + PacketSize;
                    else
                        LOSTPACKETS_VoIP= LOSTPACKETS_VoIP + 1;
                    end
                end
            end
  
        case DEPARTURE                     % If first event is a DEPARTURE
            TRANSMITTEDPACKETS = TRANSMITTEDPACKETS +1;
            if packetType == 0 % Data
                TRANSMITTEDBYTES_data= TRANSMITTEDBYTES_data + PacketSize;
                DELAYS_data= DELAYS_data + (Clock - ArrivalInstant);
                if Clock - ArrivalInstant > MAXDELAY_data
                    MAXDELAY_data= Clock - ArrivalInstant;
                end
                TRANSMITTEDPACKETS_data= TRANSMITTEDPACKETS_data + 1;
                if QUEUEOCCUPATION > 0
                    EventList = [EventList; DEPARTURE, Clock + 8*QUEUE(1,1)/(C*10^6), QUEUE(1,1), QUEUE(1,2),QUEUE(1,3)];
                    QUEUEOCCUPATION= QUEUEOCCUPATION - QUEUE(1,1);
                    QUEUE(1,:)= [];
                else
                    STATE= 0;
                end  

            else %VoIP
                TRANSMITTEDBYTES_VoIP= TRANSMITTEDBYTES_VoIP + PacketSize;
                DELAYS_VoIP= DELAYS_VoIP + (Clock - ArrivalInstant);
                if Clock - ArrivalInstant > MAXDELAY_VoIP
                    MAXDELAY_VoIP= Clock - ArrivalInstant;
                end
                TRANSMITTEDPACKETS_VoIP= TRANSMITTEDPACKETS_VoIP + 1;
                if QUEUEOCCUPATION > 0
                    EventList = [EventList; DEPARTURE, Clock + 8*QUEUE(1,1)/(C*10^6), QUEUE(1,1), QUEUE(1,2),QUEUE(1,3)];
                    QUEUEOCCUPATION= QUEUEOCCUPATION - QUEUE(1,1);
                    QUEUE(1,:)= [];
                else
                    STATE= 0;
                end  
            end
    end
end

%Performance parameters determination:
PL_d= 100*LOSTPACKETS_data/TOTALPACKETS_data;      % in %
APD_d= 1000*DELAYS_data/TRANSMITTEDPACKETS_data;   % in milliseconds
MPD_d= 1000*MAXDELAY_data;                    % in milliseconds

PL_v= 100*LOSTPACKETS_VoIP/TOTALPACKETS_VoIP;      % in %
APD_v= 1000*DELAYS_VoIP/TRANSMITTEDPACKETS_VoIP;   % in milliseconds
MPD_v= 1000*MAXDELAY_VoIP;                    % in milliseconds

TRANSMITTEDBYTES_TT = TRANSMITTEDBYTES_data + TRANSMITTEDBYTES_VoIP;
TT= 10^(-6)*TRANSMITTEDBYTES_TT*8/Clock;  % in Mbps

end

function out= GeneratePacketSize_Data()
    aux= rand();
    aux2= [65:109 111:1517];
    if aux <= 0.19
        out= 64;
    elseif aux <= 0.19 + 0.23
        out= 110;
    elseif aux <= 0.19 + 0.23 + 0.17
        out= 1518;
    else
        out = aux2(randi(length(aux2)));
    end
end


function out= GeneratePacketSize_VoIP()
    %aux2= [110:130];
    %out = aux2(randi(length(aux2)));
    out = randi([110,130]);
    % gera um valor inteiro para o numero de bytes
end
