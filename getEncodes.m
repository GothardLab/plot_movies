function [ codes, ts ] = getEncodes( spikePath )
%GETENCODES Summary of this function goes here
%   Detailed explanation goes here

tooClose = 0.002; %Closest two paired encodes can be, usually 0.002 seconds
tooFar =0.006; %Farthest two paired encodes can be, usually 0.006 seconds

try 
    spike = load_smr(spikePath);

catch err
    warndlg(['Error loading spike file ->', err.identifier],'Spike error')
    return
end

% Find condition channel
for c = 1:size(spike,2)
    if strcmp(spike(c).title, 'conditio') || strcmp(spike(c).title, 'DigMark') 
        condChan = c;
    end
end

if ~exist('condChan', 'var')
   warndlg('No condition channel found, please title it either "conditio" or "DigMark".', 'Spike error');
   return;
end

% Save condition channel
conditionChan = spike(condChan);

%Extract times and events
times = conditionChan.data.timings;
events = conditionChan.data.markers(:,1);


%Clear possible blank first event
if events(1)==0;
    events(1)=[];
    times(1)=[];
end

timeDiffs = diff(times);

c = 0;
if ~mod(size(events,1),2) %If there are an even amount of events for pairing
    
    for i = 1:(size(events,1)-1)
        if (timeDiffs(i)>tooClose && timeDiffs(i)<tooFar)
            c=c+1;
            lob(c)=events(i);
            hib(c)=events(i+1);
            ts(c)=times(i);
        end
    end
    
    codes = nan(1,c);


    for i=1:length(lob);
        codes(i)=double(lob(i))+(double(hib(i))*256);
    end

    ts(codes==0)=[];
    codes(codes==0)=[];

    
else
    %warndlg('Uneven number of encodes found, critical encode must have dropped... using exceptions!');
    
    [ts, codes ] = encodeExceptions(events, times);
end

