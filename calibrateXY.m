function [trial_eyes] = calibrateXY (trial, xEyes, yEyes, presentParams)
 %keep trial xEyes yEyes presentParams
 
 
monitorPixelWidth = presentParams.monitorWidthPixels; %the width of the monitor used during calibration (800x600 typically);
monitorPixelHeight = presentParams.monitorHeightPixels; %the height of the monitor used during calibration (800x600 typically);
monitorVoltageScale = presentParams.monitorVoltageScale; %the number of volts (out of 5) to distribute across the monitor (determned in presentation timing file);

xScaleFactor = (monitorPixelWidth/2)/monitorVoltageScale;
yScaleFactor = (monitorPixelHeight/2)/monitorVoltageScale;

monitorCmWidth = presentParams.monitorCMWidth;%width of the monitor in cm
monitorCmHeight = presentParams.monitorCMHeight; %height of the monitor in cm
monkeyMonitorDistance = presentParams.monkeyMonitorDist; %distance of monkey's eye from screen

fixSpotXAngleWidth = 2*(atand((monitorCmWidth/2)/monkeyMonitorDistance)); %WIDTH OF FIXSPOT IN DVA
fixSpotYAngleWidth = 2*(atand((monitorCmHeight/2)/monkeyMonitorDistance)); %WIDTH OF FIXSPOT IN DVA

xPixelAngleFactor = fixSpotXAngleWidth/monitorPixelWidth; %conversion factor for taking pixels to DVA
yPixelAngleFactor = fixSpotYAngleWidth/monitorPixelHeight; %conversion factor for taking pixels to DVA

ntrials = size(trial,2);

rawX = xEyes.data;
rawY = yEyes.data;

calX = rawX * xScaleFactor * xPixelAngleFactor;
calY = rawY * xScaleFactor * yPixelAngleFactor;

trial_eyes = trial;

frameRatePerSecond = 30;
expectedFrameTime_s = (1/frameRatePerSecond);
expectedFrameTime_ms = round(expectedFrameTime_s*1000);

for t = 1:ntrials
 
    
    for f = 1:trial(t).numberFrames-1
        
 
        frameStart_ms = round(trial_eyes(t).frameTimes(f) * 1000);
        frameEnd_ms = round(trial_eyes(t).frameTimes(f+1) * 1000);
        
        trial_eyes(t).frame(f).frameStart_ms = frameStart_ms;
        trial_eyes(t).frame(f).frameEnd_ms = frameEnd_ms;
        trial_eyes(t).frame(f).rawX = rawX(frameStart_ms:frameEnd_ms);
        trial_eyes(t).frame(f).rawY = rawY(frameStart_ms:frameEnd_ms);
        trial_eyes(t).frame(f).calX = calX(frameStart_ms:frameEnd_ms);
        trial_eyes(t).frame(f).calY = calY(frameStart_ms:frameEnd_ms);

    end
    
    f = trial(t).numberFrames; % For the last frame
    frameStart_ms = round(trial_eyes(t).frameTimes(f) * 1000);
    frameEnd_ms = frameStart_ms + expectedFrameTime_ms;

    trial_eyes(t).frame(f).frameStart_ms = frameStart_ms;
    trial_eyes(t).frame(f).frameEnd_ms = frameEnd_ms;
    trial_eyes(t).frame(f).rawX = rawX(frameStart_ms:frameEnd_ms);
    trial_eyes(t).frame(f).rawY = rawY(frameStart_ms:frameEnd_ms);
    trial_eyes(t).frame(f).calX = calX(frameStart_ms:frameEnd_ms);
    trial_eyes(t).frame(f).calY = calY(frameStart_ms:frameEnd_ms);
 
end



% moviesStart=start;%input('When did you start showing the movies (in seconds)?  '); %ask the user to type in the start time of this part of the file
% moviesEnd=stop;%input('When did you stop showing the movies (in seconds)?  ');    %ask the user to type in the end time of this part of the file
% moviedir=itmPath; %the directory of where to look for the movies.  Make sure that each movie that you want to

% [movietrial]=decode_pres_movie_encode([eyePath,eyeFile], [itmPath itmFile],moviesStart, moviesEnd);    %run a sepearate function to decode the channel 32.  to read about this function, open it in a seperate script-editing window
% [eyeX,eyeY,time] = downsampleeyes([eyePath,eyeFile]);   %downsample the eyes, a program written by Chris and Robert to input the eye data from Spike
% eyeX = eyeX*PRESCAL2PIX_X*xPixelAngleFactor;
% eyeY = eyeY*PRESCAL2PIX_Y*yPixelAngleFactor;


% %upsample eye data to 1000Hz
% desiredx=[time(1):1:time(end)]; %get the start and end times of the eye data
% eyeX1=zeros(1,length(desiredx));    %make a vector that is the length of the datafile, sampled at 1000Hz
% eyeY1=zeros(1,length(desiredx));    %make a vector that is the length of the datafile, sampled at 1000Hz
% eyeX1=interp1(time,eyeX,desiredx);  %interpolate the eye data sampled at 250Hz (or whatever it was) so that it is now sampled at 1000Hz
% eyeY1=interp1(time,eyeY,desiredx);  %interpolate the eye data sampled at 250Hz (or whatever it was) so that it is now sampled at 1000Hz
% eyeX = eyeX1; eyeY = eyeY1;         %reassign the 1000Hz sampled data to the old variable names
% clear eyeX1 eyeY1;      %clear the temporary variables we made
% ends=[];    %assign NaNs to the extra values at the beginning and end of the interpolation (next 4 lines)
% ends(end+1) = time(end);
% eyeY(end+1:max(ends))=NaN;
% eyeY=eyeY;
% eyeX=eyeX;
% eyeX(end+1:max(ends))=NaN;

% for i=1:length(movietrial); %scroll through the movie trials
%     for j=1:length(movietrial(i).frametime)-1;  %for each movie frame (except the last)...
%         clear frame1 frame2;   %clear these temporary variables so we don't get confused
%         frame1=round(movietrial(i).frametime(j)*1000);  %get the time that one frame was shown
%         frame2=round(movietrial(i).frametime(j+1)*1000);    %get the tim that the next fram was shown
%         movietrial(i).eyex{j}=eyeX(frame1:frame2);  %cut teh eye data from one frame to the next and record it in the movietrial structure
%         movietrial(i).eyey{j}=eyeY(frame1:frame2);  %cut teh eye data from one frame to the next and record it in the movietrial structure
%     end
%     
%     endframe=round(movietrial(i).frametime(length(movietrial(i).frametime))*1000);  %the last frame will be equal to the length of the frames shown for this movie
%     
%     bc=sort([movietrial(i).frametime(1):-(1/30):movietrial(i).frametime(1)-1]);
%     ad=sort([endframe/1000+0.033:(1/30):endframe/1000+0.033+1]);
%     movietrial(i).preframetime=bc;
%     movietrial(i).postframetime=ad;
%     
%     for j=1:length(movietrial(i).preframetime)-1;  %for each movie frame (except the last)...
%         clear frame1 frame2;   %clear these temporary variables so we don't get confused
%         frame1=round(movietrial(i).preframetime(j)*1000);  %get the time that one frame was shown
%         frame2=round(movietrial(i).preframetime(j+1)*1000);    %get the tim that the next fram was shown
%         movietrial(i).preeyex{j}=eyeX(frame1:frame2);  %cut teh eye data from one frame to the next and record it in the movietrial structure
%         movietrial(i).preeyey{j}=eyeY(frame1:frame2);  %cut teh eye data from one frame to the next and record it in the movietrial structure
%     end
%     endpreframe=round(movietrial(i).preframetime(length(movietrial(i).preframetime))*1000);  %the last frame will be equal to the length of the frames shown for this movie
%     movietrial(i).preeyex{length(movietrial(i).preframetime)}=eyeX(endpreframe:endpreframe+33); %since the movie is shown at 30 Hz, the last frame turned off 33ms later, record the eye data durign this time period
%     movietrial(i).preeyey{length(movietrial(i).preframetime)}=eyeY(endpreframe:endpreframe+33); %since the movie is shown at 30 Hz, the last frame turned off 33ms later, record the eye data durign this time period
%     
%     for j=1:length(movietrial(i).postframetime)-1;  %for each movie frame (except the last)...
%         clear frame1 frame2;   %clear these temporary variables so we don't get confused
%         frame1=round(movietrial(i).postframetime(j)*1000);  %get the time that one frame was shown
%         frame2=round(movietrial(i).postframetime(j+1)*1000);    %get the tim that the next fram was shown
%         movietrial(i).posteyex{j}=eyeX(frame1:frame2);  %cut teh eye data from one frame to the next and record it in the movietrial structure
%         movietrial(i).posteyey{j}=eyeY(frame1:frame2);  %cut teh eye data from one frame to the next and record it in the movietrial structure
%     end
%     endpostframe=round(movietrial(i).postframetime(length(movietrial(i).postframetime))*1000);  %the last frame will be equal to the length of the frames shown for this movie
%     movietrial(i).posteyex{length(movietrial(i).postframetime)}=eyeX(endpostframe:endpostframe+33); %since the movie is shown at 30 Hz, the last frame turned off 33ms later, record the eye data durign this time period
%     movietrial(i).posteyey{length(movietrial(i).postframetime)}=eyeY(endpostframe:endpostframe+33); %since the movie is shown at 30 Hz, the last frame turned off 33ms later, record the eye data durign this time period
%     
%     movietrial(i).eyex{length(movietrial(i).frametime)}=eyeX(endframe:endframe+33); %since the movie is shown at 30 Hz, the last frame turned off 33ms later, record the eye data durign this time period
%     movietrial(i).eyey{length(movietrial(i).frametime)}=eyeY(endframe:endframe+33); %since the movie is shown at 30 Hz, the last frame turned off 33ms later, record the eye data durign this time period
%     movietrial(i).movieregions=20*ones(length(movietrial(i).frametime),1); %make a vector that will record the movie region that the monkey is looking at during each frame
% end
% 
% movienum=1; %set the initial movie number to 1
% frame_num=1;    %set the initial frame number to 1
% if ~isdir([eyePath,'matfiles\']);
%     mkdir([eyePath,'matfiles\']);
% end

