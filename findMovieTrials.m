%       findMovieTrials.m
%           Written by Philip Putnam, University of Arizona, 2015
%   
%       Meant to find times of movies shown using the presentation script
%       show_movies.sce or similar by finding the sequential frames by
%       their encodes (frame number + 1000). This script reads a spike file
%       and combines high and low bytes on the condition channel to find
%       the encodes.
%
%       Code adopted from Clayton Mosher and others in the Gothard lab.  

%function [ output_args ] = findMovieTrials(spikePath, itemPath)
%FINDMOVIETRIALS Finds movie trials from show_movies.sce or similar
%   Inputs:
%       'spikePath', (string): Path to spike file
%       'itemPath', (string): Path to item file
%
%   Outputs:
%

% Load spike file
clear all
clc
spikePath = 'D:\dat\smr\ImageMovieTest.smr'
try 
    spike = load_smr(spikePath);

catch err
    warndlg(['Error loading spike file ->', err.identifier],'Spike error')
    return
end

% Load item file
% try 
%   items = loadItemFile(itemPath);
% 
% catch err
%     warndlg(['Error loading item file ->', err.identifier],'Item file')
%     return
% end

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
        if (timeDiffs(i)>0.002 && timeDiffs(i)<0.006)
            c=c+1;
            lob(c)=events(i);
            hib(c)=events(i+1);
            ts(c)=times(i);
        end
    end
    
else
    warndlg('Uneven number of encodes found, critical encode must have dropped');
end

codes = nan(1,c);


for i=1:length(lob);
    codes(i)=double(lob(i))+(double(hib(i))*256);
end

ts(codes==0)=[];
codes(codes==0)=[];



%Set number of items in fiile
%numberItems = size(itemFile,1);

%Clear unused array codes from events
% events(:,2:4) = [];
% 
% %Clear possible blank first event
% if events(1)==0;
%     events(1)=[];
%     times(1)=[];
% end
% 
% %Find markers outside time allowed
% badones=find(diff(times)<0.002)+1;
% 
% %Clear them from the array
% times(badones)=[];
% events(badones)=[];
% 
% %Seperate low and high bytes
% c=0;
% diffmarks=[diff(times)];
% for i=1:length(events)-1;
%     if (diffmarks(i)>0.002 && diffmarks(i)<0.006);
%         c=c+1;
%         lob(c)=events(i);
%         hib(c)=events(i+1);
%         marktimes(c)=times(i);
%     end
% end
% 
% %Combined low and high byte values into single value array
% for i=1:length(lob);
%     hiblob(i)=double(lob(i))+(double(hib(i))*256);
% end
% marktimes(hiblob==0)=[];
% hiblob(hiblob==0)=[];
% 
% 
% movieFrames = [1001:1299];
% allCodes = hiblob;
% allTimes = marktimes;
% 
% movieCandidates = cell(1, numel(movieFrames));
% for p = 1:(numel(movieFrames))
%     movieCandidates{p} = find(allCodes == movieFrames(p));
% end
% 
% movieCandidateStartIndexs = movieCandidates{1};
% movieCandidateStartTimes = allTimes(movieCandidates{1});
% 
% for i = 1:size(movieCandidateStartIndexs,2)
%     
%     fprintf('\t\tTrial:%3d\t', i);
%     movie(i).error = 1;
%      movie(i).condition = allCodes(movieCandidateStartIndexs(i)-1)-256*255;
%                fprintf('Condition: %2d\t', movie(i).condition);
%     
%     if size(allCodes,2) >= movieCandidateStartIndexs(i)+298 && ismember(movie(i).condition, [1:size(itemFile,1)])
%         expectedFrameIndexs = [movieCandidateStartIndexs(i):movieCandidateStartIndexs(i)+298];
%         expectedFrameCodes = allCodes(expectedFrameIndexs);
%         expectedFrameTimes = allTimes(expectedFrameIndexs);
% 
%         frameErrors = 0;
% 
%         correctTimes = nan(1,size(movieFrames,2));
%         correctFrames = nan(1,size(movieFrames,2));
% 
%         for j = 1:size(movieFrames,2)
%             expectedFrame = movieFrames(j);
% 
%             if size(find(expectedFrameCodes == expectedFrame),2) == 0 %If there is a missing frame
%                 frameErrors=frameErrors+1;
%                 fprintf('%d? ', expectedFrame);
% 
%                 if expectedFrame == movieFrames(end)
%                     correctFrames(j) = movieFrames(end);
%                     correctTimes(j) = expectedFrameTimes(end);  
%                 end
% 
%             elseif size(find(expectedFrameCodes == expectedFrame),2) > 1
%                 frameErrors=frameErrors+1;
%                 fprintf('%dx%d ', expectedFrame, size(find(expectedFrameCodes == expectedFrame),2));
%             else
%                 index = find(expectedFrameCodes == expectedFrame);
% 
%                 correctFrames(j) = expectedFrameCodes(index);
%                 correctTimes(j) = expectedFrameTimes(index);
%             end
% 
% 
%         end
% 
%         interpFrames=correctFrames-1000;
%         interpTimes=correctTimes;
%         interpFrames(size(movieFrames,2)+1) = nan;
%         interpTimes(size(movieFrames,2)+1) = nan;
%         interpFrames(isnan(interpFrames)) = interp1(find(~isnan(interpFrames)), interpFrames(~isnan(interpFrames)), find(isnan(interpFrames)), 'PCHIP');
%         interpTimes(isnan(interpTimes)) = interp1(find(~isnan(interpTimes)), interpTimes(~isnan(interpTimes)), find(isnan(interpTimes)), 'PCHIP');
% 
%         if interpFrames == [1:300]
% 
% 
% 
%             for j = 1:size(movieFrames,2)
% 
%                 if j == interpFrames(j)
%                     movie(i).frame(j).start = interpTimes(j);
%                     movie(i).frame(j).end  = interpTimes(j+1);
%                 else
%                     movie(i).error = 1;
%                     error('Movie %d error', i);
%                 end
%             end
% 
%            
% 
%             movie(i).start = interpTimes(1);
%             movie(i).end = interpTimes(end);
%             movie(i).stimFile = itemFile{movie(i).condition};
%             movie(i).itemFile = itemFileName;
%             movie(i).dataFile = spikeName;
%             movie(i).frameErrors=frameErrors;
%             movie(i).error = 0;
%              fprintf('Errors:%d\t', movie(i).frameErrors);
%         else
%             movie(i).error = 1;
%             error('Movie %d error', i);
%         end
%     else
%         movie(i).error = 1;
%           fprintf('Movie stopped early or invalid condition');
%     end
%     fprintf('\n');
% end
% 
% movieViewCounts = zeros(1,size(movie,2));
% validMovieCount = 0;
% for movieIndex = 1:size(movie,2)
%     
%     if ~movie(movieIndex).error 
%         
%      validMovieCount = validMovieCount+1;
%      
%      movieViewCounts(movie(movieIndex).condition) = movieViewCounts(movie(movieIndex).condition)+1;
%      movie(movieIndex).viewing = movieViewCounts(movie(movieIndex).condition);
%        trial(validMovieCount).frame = movie(movieIndex).frame;
%       trial(validMovieCount).viewing = movie(movieIndex).viewing;
%        trial(validMovieCount).start = movie(movieIndex).start;
%        trial(validMovieCount).end = movie(movieIndex).end;
%        trial(validMovieCount).stimFile = movie(movieIndex).stimFile;
%        trial(validMovieCount).itemFile = movie(movieIndex).itemFile;
%        trial(validMovieCount).dataFile = movie(movieIndex).dataFile;
%        trial(validMovieCount).frameErrors = movie(movieIndex).frameErrors;
%          trial(validMovieCount).condition = movie(movieIndex).condition;
%      
%     end
% end


