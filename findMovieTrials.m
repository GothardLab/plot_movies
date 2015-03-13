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

function [ trial ] = findMovieTrials(spikePath)
%FINDMOVIETRIALS Finds movie trials from show_movies.sce or similar
%   Inputs:
%       'spikePath', (string): Path to spike file
%       'itemPath', (string): Path to item file
%
%   Outputs:
%

% Load spike file
try 
    [ codes, ts ] = getEncodes( spikePath );

catch err
    warndlg(['Error loading encodes ->', err.identifier],'Spike error')
    return
end

nevents = size(codes,2);

frameRatePerSecond = 30;
expectedFrameTime_s = 1/frameRatePerSecond;

method = 'cue';

switch method
    
    case 'cumsumdiff' % Not functional yet
        
        diffCodes = [0 cumsum(diff(codes)~=1)];
        
        uniqueDiffCodes = unique(diffCodes);
        
        numUniqueDiffCodes = size(uniqueDiffCodes,2);
        
        for u = 1:numUniqueDiffCodes
            
            theseLocs = find(diffCodes == uniqueDiffCodes(u));
            
            thisSeqFirst = codes(theseLocs(1));
            thisSeqLast = codes(theseLocs(end));
            thisDiffCode = diffCodes(theseLocs(1));
            numTheseLocs = size(theseLocs,2);
            fprintf('Codes: %6d -> %6d\t\tElements: %6d -> %6d\tDiff: %d\tInstances: %d\t\n',thisSeqFirst, thisSeqLast,theseLocs(1), theseLocs(end), thisDiffCode, numTheseLocs);
        end

        
        %codes(diffCodes==mode(diffCodes))
        
    case 'frames' % Not functional yet    
        
    case 'cue'
       
        potentials = 0;
        
        maxframes = 300;
        
        t = 0;
        
        for c = 1:nevents % Loop through events

           if codes(c) == 35 % If 'cue on', a potential trial start
               
               if c < nevents
               
                   if codes(c+1) == 36% If folloed by 'cue off'
                       
                       cue_on_s = ts(c);
                       cue_off_s = ts(c+1);
                       condition = codes(c+3)-(256*255);
                       
                       if condition < 1 || condition > 100 %If condition is out of range, try the 2nd code
                           condition = codes(c+2)-(256*255);
                       end
                       
                       fprintf('Potential trial at: %06.4fs', cue_on_s);
                        fprintf('\n\tCondition: %d', condition);
                       

                       expectedFirstFrame = 1001;
                       
                       
                       l = c; % Create a seperate index to look for the first frame
                       
                       while l <= nevents && l < c+6 % Look up to five frames ahead
                           
                           
                           
                           if codes(l) == expectedFirstFrame % If we find our expected start frame
                               
                                fprintf('\n\tFirst frame found at: %06.4fs', ts(l));
                                
                                frames_start_index = l;
                                first_frame = 1;
                                
                                frames_start_s = ts(l);
                                
                               
                                break;
                                
                           elseif codes(l) == expectedFirstFrame+1 % If the first frame droppped
                               
                               fprintf('\n\tFound 2nd frame at: %06.4fs', ts(l));
                               
                               frames_start_index = l;
                               first_frame = 2;
                               
                               frames_start_s = ts(l)-expectedFrameTime_s; % F
                               frames_ts(1) = ts(l)-expectedFrameTime_s;
                               
                               break;
                           end
                           
                           l = l+1;
                       end
                       
                       f = first_frame; %Frame number
                       i = frames_start_index; %Index
                       
                       while i <= nevents
                          
                           if codes(i) == 1000+f
                               
                               frames_ts(f)= ts(i);
                               
                              % fprintf('\n\t\t\t frame %d @ %06.4fs',f, ts(i));
                               
                               f = f+1;
                               i = i+1;
                           elseif i+1 <= nevents %If we are able to look one ahead
                               
                               a = i+1;
                               
                               if codes(a) == 1000+f+1 %If we dropped a frame
                                  
                                   frames_ts(f) = ts(a)-expectedFrameTime_s; %The 
                                   
                                   fprintf('\n\tDropped frame %d @ %06.4fs',f, ts(a)-expectedFrameTime_s); 
                                   
                                   f = f+1;
                                   i = i+1;
                               else
                                   %fprintf('\n\t\t\tEnd');
                                break;
                               end
                           else
                               %fprintf('\n\t\t\tEnd');
                               break;
                                
                           end
                           
                       end
                       
                       nframes = f-1;
                       frames_stop_s = ts(i-1);
                       
                        
                       fprintf('\n\tTrial end at: %06.4fs', frames_stop_s);
                       fprintf('\n\tTrial length: %06.4fs', frames_stop_s-frames_start_s);
                       fprintf('\n\tFrames found: %d',  nframes);   
                       
                     
                     
                     
                     t = t + 1;
                     
                     trial(t).cueOnS = cue_on_s;
                     trial(t).cueOffS = cue_off_s;
                     trial(t).movieOnS = frames_start_s;
                     trial(t).movieOffS = frames_stop_s;
                     trial(t).movieLengthS = frames_stop_s-frames_start_s;
                     trial(t).numberFrames = nframes;
                     trial(t).condition = condition;
                     trial(t).frameTimes = frames_ts;
                     
                     fprintf('\n\tRecording as trial number: %d',  t);
                     
                     clear cue_on_s cue_off_s frames_start_s frames_stop_s nframes condition frames_ts
                     fprintf('\n');
                   end
               
               end
               
           end
               
        end
        
    otherwise
end
    
        

% if exist('itemPath', 'var')
%     
%     %Load item file
%     try 
%       items = loadItemFile(itemPath);
%       
%       
%       for t = 1 : size(trial,2)
%           
%       end
% 
%     catch err
%         warndlg(['Error loading item file ->', err.identifier],'Item file')
%         return
%     end
% 
% end



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


