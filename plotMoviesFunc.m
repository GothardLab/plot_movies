%       plotMoviesFunc.m
%           Written by Philip Putnam, University of Arizona, 2015

%function [ output_args ] = plotMoviesFunc( plotDat )
%PLOTMOVIESFUNC Plots movie scanpath input from GUI or wrapper function
%   Inputs
%       'spike', (string): Path to spike file
%       'item', (string): Path to item file
%       'out'. (string): Path to output directory
%       'source', (string): Path to source directory

%Need to write vargin for plotDat or commands

%%%%%%Debug%%%%%%%%
clear all
clc
load('plotDat.mat');
%%%%%%%%%%%%%%%%%%%

% Set values from plotDat
sourceDir = plotDat.sourceParams.sourceDir;
outDir = plotDat.outParams.outDir;
spikePath = plotDat.smrParams.path;
itemPath = plotDat.itemParams.path;
presentParams = plotDat.presentParams;


% Load spike file
try 
    spike = load_smr(spikePath);

catch err
    warndlg(['Error loading spike file ->', err.identifier],'Spike error')
    return
end

% Load item file
try 
  items = loadItemFile(itemPath);

catch err
    warndlg(['Error loading item file ->', err.identifier],'Item file')
    return
end

% Find the eye channels
for c = 1:size(spike,2)
    if strcmp(spike(c).title, 'eyex')
        xChan = c;
    end
     if strcmp(spike(c).title, 'eyey')
         yChan = c;
     end
end

% Make sure we could find the eyes
if ~exist(xChan, 'var') ||  ~exist(yChan, 'var')
     warndlg('Cannot find X and/or Y eye channels in file');
     return
end 

% Find the movie trials
[ trial ] = findMovieTrials(spikePath);

% Seperate the eye channels
xEyes = spike(xChan);
yEyes = spike(yChan);

% Calibrate the eye data during the trials
[ trial_eyes ] = calibrateXY (trial, xEyes, yEyes, presentParams);



movieTrialCount = size(movie,2);

blackround=zeros(768,1024,3);
oricolor=[255 0 0]/255;
blackround=zeros(768,1024,3);
oricolor=[255 0 0]/255;


movspeed=0.5;%input('What speed would you like the movies to be made at (half speed=0.5)? ');
startmovie= 1;%input('What movie do you want to starton? ');

monitorPixelWidth = 1024; %the width of the monitor used during calibration (800x600 typically);
monitorPixelHeight = 768; %the height of the monitor used during calibration (800x600 typically);
monitorVoltageScale = 4.0; %the number of volts (out of 5) to distribute across the monitor (determned in presentation timing file);
xScaleFactor = (monitorPixelWidth/2)/monitorVoltageScale;
yScaleFactor = (monitorPixelHeight/2)/monitorVoltageScale;
monitorCmWidth = 37.8; %width of the monitor in cm
monitorCmHeight = 30; %height of the monitor in cm
monkeyMonitorDistance = 57; %distance of monkey's eye from screen
fixSpotXAngleWidth = 2*(atand((monitorCmWidth/2)/monkeyMonitorDistance)); %WIDTH OF FIXSPOT IN DVA
fixSpotYAngleWidth = 2*(atand((monitorCmHeight/2)/monkeyMonitorDistance)); %WIDTH OF FIXSPOT IN DVA
xPixelAngleFactor = fixSpotXAngleWidth/monitorPixelWidth; %conversion factor for taking pixels to DVA
yPixelAngleFactor = fixSpotYAngleWidth/monitorPixelHeight; %conversion factor for taking pixels to DVA
PRES2ANG=0.0368;
monitorWidth=1024;
monitorHeight=768;
PRESWIDTH=1024; %the width of the monitor used during calibration (800x600 typically);
PRESHEIGHT=768; %the height of the monitor used during calibration (800x600 typically);
VOLTAGESCALE=4.0; %the number of volts (out of 5) to distribute across the monitor (determned in presentation timing file);
PRESCAL2PIX_X=(PRESWIDTH/2)/VOLTAGESCALE;
PRESCAL2PIX_Y=(PRESHEIGHT/2)/VOLTAGESCALE;
MONITORWIDTH_CM = 37.8; %width of the monitor in cm
MONITORHEIGHT_CM = 30; %height of the monitor in cm
MONKDIST = 57; %distance of monkey's eye from screen
ANGWIDTH_X = 2*(atand((MONITORWIDTH_CM/2)/MONKDIST)); %WIDTH OF FIXSPOT IN DVA
ANGWIDTH_Y = 2*(atand((MONITORHEIGHT_CM/2)/MONKDIST)); %WIDTH OF FIXSPOT IN DVA
PIX2ANG_X = ANGWIDTH_X/PRESWIDTH; %conversion factor for taking pixels to DVA
PIX2ANG_Y = ANGWIDTH_Y/PRESHEIGHT; %conversion factor for taking pixels to DVA




figure;
set(gcf,'Position',[80         124        1120         840]);

for movieTrialIndex = 1:movieTrialCount
    
    oriFrames = 0;
    regFrames = 0;
    ambigFrames = 0;
    oriSamples = 0;
    regSamples = 0;
    ambigSamples = 0;
    
    samplesOnFrame = 0;
    samplesOffFrame  = 0;
    framesOnFrame = 0;
    framesOffFrame = 0;
    
    myMov = movie(movieTrialIndex);
    
    [~,stimName]=fileparts(movie(movieTrialIndex).stimFile);
    
    load([roiDir,stimName,'_eyes_score_res1024extended.mat']);
     
    movieTitle = [stimName,'_',num2str(movie(movieTrialIndex).viewing),'_',[num2str(round(movie(movieTrialIndex).start)),'-', num2str(round(movie(movieTrialIndex).end))]];
    
    movieWritePath = fullfile(outMovDir,movie(movieTrialIndex).dataFile,[movieTitle,'.avi']);
    
    movieNameDouble = double(movieTitle);
    movieNameBase36 = dec2base(movieNameDouble, 36);
    movieNameReshape = reshape(movieNameBase36,1,size(movieNameBase36,1)*size(movieNameBase36,2));
    originalMovieBase36 = reshape(movieNameReshape,size(movieNameReshape,2)/2,2);
    
    fileNameDouble = double(movie(movieTrialIndex).dataFile);
    fileNameBase36 = dec2base(fileNameDouble, 36);
    fileNameReshape = reshape(fileNameBase36,1,size(fileNameBase36,1)*size(fileNameBase36,2));
    originalFileBase36 = reshape(fileNameReshape,size(fileNameReshape,2)/2,2);
    
    movieWriteCipherPath = fullfile(outMovDir,fileNameReshape,[movieNameReshape,'.avi']);
    
    if ~isdir([outMovDir,fileNameReshape]);
        mkdir([outMovDir,fileNameReshape]);
    end
    
    if ~isdir([outMovDir,movie(movieTrialIndex).dataFile]);
         mkdir([outMovDir,movie(movieTrialIndex).dataFile]);
    end
    
     writerObj = VideoWriter(movieWritePath);
     open(writerObj);
     
     cipherObj = VideoWriter(movieWriteCipherPath);
     open(cipherObj);
    
    for frameIndex = 1:size(movie(movieTrialIndex).frame,2)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        
        rawX =myMov.frame(frameIndex).rawX;
        rawY =myMov.frame(frameIndex).rawY;

        calX=myMov.frame(frameIndex).calX;
        calY=myMov.frame(frameIndex).calY;
        
        if max(calX) > (720/2)*PIX2ANG_X || min(calX) < -(720/2)*PIX2ANG_X || max(calY) > (480/2)*PIX2ANG_Y || min(calY) < -(480/2)*PIX2ANG_Y
            myMov.onFrame(frameIndex) = 0;
            nowOnframe = 0;
            framesOffFrame=framesOffFrame+1;
        else
            myMov.onFrame(frameIndex) = 1;
            nowOnframe = 1;
            framesOnFrame=framesOnFrame+1;
        end
        
        for sampleIndex = 1:size(calX,2)
            
            if max(calX(sampleIndex)) > (720/2)*PIX2ANG_X || min(calX(sampleIndex)) < -(720/2)*PIX2ANG_X || max(calY(sampleIndex)) > (480/2)*PIX2ANG_Y || min(calY(sampleIndex)) < -(480/2)*PIX2ANG_Y
                samplesOffFrame = samplesOffFrame +1;
            else
                samplesOnFrame = samplesOnFrame+1;
            end
            
        end
        
        angX = rawX*PRESCAL2PIX_X*PIX2ANG_X;
        angY = rawY*PRESCAL2PIX_Y*PIX2ANG_Y;
        
        frameX = round(angX/PRES2ANG+monitorWidth/2);
        frameX(find(frameX<=0))=1;
        frameX(find(frameX>=monitorWidth+1))=monitorWidth;
        
        frameY = round(angY/PRES2ANG+monitorHeight/2);
        frameY(find(frameY<=0))=1;
        frameY(find(frameY>=monitorHeight+1))=monitorHeight;
      
        
        rtem=squeeze(ROIreg(frameIndex,:,:));
        rtem2=squeeze(ROIambig(frameIndex,:,:));
        rtem3=squeeze(ROIori(frameIndex,:,:));
        
        
        try
           idxs = sub2ind(size(rtem), monitorHeight-frameY+1, frameX);

            scores(frameIndex).reg =(rtem(idxs));
            scores(frameIndex).ambig =(rtem2(idxs)); 
            scores(frameIndex).ori =(rtem3(idxs)); 
        catch err
           scores(frameIndex).reg = zeros(1,size(frameY,2));
           scores(frameIndex).ambig = zeros(1,size(frameY,2));
           scores(frameIndex).ori = zeros(1,size(frameY,2));
            fprintf('*')
        end
        
        movieScore.reg(frameIndex) = sum(scores(frameIndex).reg);
        movieScore.ambig(frameIndex) = sum(scores(frameIndex).ambig);
        movieScore.ori(frameIndex) = sum(scores(frameIndex).ori);
        
        if size(scores(frameIndex).ori,2) > 0
            oriFrames = oriFrames+1;
        elseif size(scores(frameIndex).reg,2) > 0
            regFrames = regFrames+1;
        elseif size(scores(frameIndex).ambig,2) > 0
              ambigFrames = ambigFrames+1;
        else
  
        end
        
        
        
 %              plot(movie(movieTrialIndex).frame(frameIndex).calX,-movie(movieTrialIndex).frame(frameIndex).calY,'Color',oricolor,'LineWidth',5);       
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
       frameload=imread([sourceMovDir,stimName,'\',num2str(frameIndex),'.bmp']); %load the frame for frame1,movie1
        cla;
        imagesc([-(size(blackround,2)/2)*xPixelAngleFactor,(size(blackround,2)/2)*xPixelAngleFactor],[-(size(blackround,1)/2)*yPixelAngleFactor,(size(blackround,1)/2)*yPixelAngleFactor],blackround);
        hold on;    %hold the background on while we also show the image (otherwise the black baground will just dissappear)
        %display the image.  Center it on the center of the screen and
        %convert itto dva
        imagesc([-(size(frameload,2)/2)*xPixelAngleFactor (size(frameload,2)/2)*xPixelAngleFactor],[-(size(frameload,1)/2)*yPixelAngleFactor (size(frameload,1)/2)*yPixelAngleFactor],frameload);
        hold on;    %hold on the background and image while we plot the eye data
        %plot the eye data in dva, be sure to flip the y-axis (multiply eyey by -1) since matlab plots images in inverse y-cartesian coordinates
        
        
        oricolor =[0 0 255]/255;
        regcolor = [128 0 128]/255;
        ambigcolor = [127 0 255]/255;
        
        oncolor =[0 255 0]/255;
        othercolor =[255 0 0]/255;
        
        thisFramePlotX = movie(movieTrialIndex).frame(frameIndex).calX;
        thisFramePlotY = -movie(movieTrialIndex).frame(frameIndex).calY;
        
        for indexIndex = 1:size(idxs,2)
            
            if rtem(idxs(indexIndex))
                 hold on, scatter(thisFramePlotX(indexIndex), thisFramePlotY(indexIndex),5, oricolor);
                 fprintf('O')
                 oriSamples=oriSamples+1;
                 regSamples=regSamples+1;
                 ambigSamples=ambigSamples+1;
            elseif rtem2(idxs(indexIndex))
                hold on, scatter(thisFramePlotX(indexIndex), thisFramePlotY(indexIndex),5, regcolor);
                fprintf('R')
                regSamples=regSamples+1;
                ambigSamples=ambigSamples+1;
            elseif rtem3(idxs(indexIndex))
                hold on, scatter(thisFramePlotX(indexIndex), thisFramePlotY(indexIndex),5, ambigcolor);
                fprintf('A')
                ambigSamples=ambigSamples+1;
            else
                hold on, scatter(thisFramePlotX(indexIndex), thisFramePlotY(indexIndex),5, othercolor);
                fprintf('.')
            end
            
        end
        
        
        
        debugStringA = ['samples on ROIs- Reg: ',num2str(regSamples), 'Samples on image: ', num2str(samplesOnFrame)];
        
        if nowOnframe
             text(10,12,['ON FRAME'],'Color','w','FontSize',14);
        else
            text(10,12,['OFF FRAME'],'Color','w','FontSize',14);
        end
        
%             
        text(-16,-12,['\bf',num2str(movieTrialIndex), '   ',movie(movieTrialIndex).stimFile(1:end-4), ': frame ', num2str(frameIndex),', ', num2str(movie(movieTrialIndex).frame(frameIndex).start),' s'],'Color','w','FontSize',14);
        text(-16,12,[debugStringA],'Color','w','FontSize',14);
        
        
        
        frame = getframe;
        writeVideo(writerObj,frame);
        writeVideo(cipherObj,frame);
     
    end
    
    myMov.frameSampleScores = scores;
    myMov.summedFrameScores = movieScore;
 
    %newMovies(movieCount) = myMov;
    
    close(writerObj);
    close(cipherObj);
end



