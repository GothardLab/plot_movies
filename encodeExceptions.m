function [ts, codes ] = encodeExceptions(events, times)
%ENCODEEXCEPTIONS Summary of this function goes here
%   Detailed explanation goes here

% N=10000;
% s=zeros(N,1);
% for a=1:N
% s(a)=tan(a); %*sin(-a/10); 
% end
% Fs=12000; %increase value to speed up the sound, decrease to slow it down
% soundsc(s,Fs)

warndlg('Warning! There is an uneven number of encodes, meaning that one OR more has been dropped! Remaining codes will attempt to be paired however there still may be issues with the pairing.')
beep

tooClose = 0.002; %Closest two paired encodes can be, usually 0.002 seconds
tooFar =0.006; %Farthest two paired encodes can be, usually 0.006 seconds

timeDiffs = diff(times);

c = 0;

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
    
    
end





