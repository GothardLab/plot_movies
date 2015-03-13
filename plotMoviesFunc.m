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
if ~exist('xChan', 'var') ||  ~exist('yChan', 'var')
    warndlg('Cannot find X and/or Y eye channels in file');
    return
end

% Find the movie trials
[ trial ] = findMovieTrials(spikePath);

% Seperate the eye channels
xEyes = spike(xChan);
yEyes = spike(yChan);

% Calibrate the eye data during the trials
[ trial_eyes ] = calibrateEyes (trial, xEyes, yEyes, presentParams);

%Extract plotting calibration factors from the plotDat structure
monitorPixelWidth = presentParams.monitorWidthPixels; %the width of the monitor used during calibration (800x600 typically)
monitorPixelHeight = presentParams.monitorHeightPixels; %the height of the monitor used during calibration (800x600 typically)
monitorVoltageScale = presentParams.monitorVoltageScale; %the number of volts (out of 5) to distribute across the monitor (determined in presentation timing file)
xScaleFactor = (monitorPixelWidth/2)/monitorVoltageScale;
yScaleFactor = (monitorPixelHeight/2)/monitorVoltageScale;
monitorCmWidth = presentParams.monitorCMWidth;%width of the monitor in cm
monitorCmHeight = presentParams.monitorCMHeight; %height of the monitor in cm
monkeyMonitorDistance = presentParams.monkeyMonitorDist; %distance of monkey's eye from screen
fixSpotXAngleWidth = 2*(atand((monitorCmWidth/2)/monkeyMonitorDistance)); %WIDTH OF FIXSPOT IN DVA
fixSpotYAngleWidth = 2*(atand((monitorCmHeight/2)/monkeyMonitorDistance)); %WIDTH OF FIXSPOT IN DVA
xPixelAngleFactor = fixSpotXAngleWidth/monitorPixelWidth; %conversion factor for taking pixels to DVA
yPixelAngleFactor = fixSpotYAngleWidth/monitorPixelHeight; %conversion factor for taking pixels to DVA
PRES2ANG = presentParams.pres2ang;

%Set the plotting color
fixColor = plotDat.plotParams.plotColor;

% Number of trials found
ntrials = size(trial,2);

for t = 1:ntrials
    
    %Create a figure
    plotH = figure;
    
    %Set the figure size
    set(plotH,'Position',[80         124        1120         840]);
    
    %Create background images
    blackround=zeros(768,1024,3);
    
    %Seperate this trial for readability
    thisTrial = trial_eyes(t);
    
    %Get the condition's stimulus file
    stimNameWithExt = items{thisTrial.condition};
    
    %Extract the name without the extention
    [~,stimName]=fileparts(stimNameWithExt);
    
    %Get the number of frames
    nFrames = thisTrial.numberFrames;
    
    %Preload the stimulus file
    for f = 1:nFrames
        
        if regexp(stimName,'_\d*','start')% %If this is a picture trial
            
            [startIndex,endIndex] =regexp(stimName,'_\d*');
            frameImageName = [stimName(startIndex+1:endIndex),'.bmp'];
            
            orginalStimName =  stimName(1:startIndex-1);
            frameImagePath = fullfile(sourceDir, orginalStimName, frameImageName);
            
            frameLoad=imread(frameImagePath);
            
            stimFrames(f).img = frameLoad;
            
            clear frameLoad frameImageName
            
        else %This is a movie trial
            
            frameImageName = [num2str(f),'.bmp'];
            frameImagePath = fullfile(sourceDir, stimName, frameImageName);
            frameLoad=imread(frameImagePath);
            
            stimFrames(f).img = frameLoad;
            
            clear frameLoad frameImageName
            
        end
        
    end
    
    set(gca,'xdir','reverse')
    %Loop through the frames that were shown
    for f = 1:nFrames
        
        %Get the raw eye X and Y from trial_eyes
        rawX = thisTrial.frame(f).rawX;
        rawY = thisTrial.frame(f).rawY;
        
        %Get the calibrated eye X and Y from trial_eyes
        calX= thisTrial.frame(f).calX;
        calY= thisTrial.frame(f).calY;
        
        %Clear the image
        cla;
        
        %Put plot hold on
        hold on;
        
        %Display the background
        imagesc([-(size(blackround,2)/2)*xPixelAngleFactor,(size(blackround,2)/2)*xPixelAngleFactor],[-(size(blackround,1)/2)*yPixelAngleFactor,(size(blackround,1)/2)*yPixelAngleFactor],blackround);
        hold on;
        
       % set(gca,'xdir','reverse')
        
        %Get this frame to plot
        frameLoad = stimFrames(f).img;
        
        %Plot the stimulus frame
        
        imagesc([-(size(frameLoad,2)/2)*xPixelAngleFactor (size(frameLoad,2)/2)*xPixelAngleFactor],[-(size(frameLoad,1)/2)*yPixelAngleFactor (size(frameLoad,1)/2)*yPixelAngleFactor],frameLoad);
        hold on;
        
        %Plot the scanpath
        plot(thisTrial(t).frame(f).calX,-thisTrial(t).frame(f).calY,'Color',fixColor,'LineWidth',5);
        
        %Get the frame to save
        frame = getframe;
        
        %Clear varibles just in case
        clear frameLoad frame rawX rawY calX calY
    end
    
    %Clear varibles just in case
    clear thisTrial stimFrames f
    
    %Close the figure
    close(plotH)
    
end



















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
    
    for f = 1:size(movie(movieTrialIndex).frame,2)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        rawX =myMov.frame(f).rawX;
        rawY =myMov.frame(f).rawY;
        
        calX=myMov.frame(f).calX;
        calY=myMov.frame(f).calY;
        
        if max(calX) > (720/2)*PIX2ANG_X || min(calX) < -(720/2)*PIX2ANG_X || max(calY) > (480/2)*PIX2ANG_Y || min(calY) < -(480/2)*PIX2ANG_Y
            myMov.onFrame(f) = 0;
            nowOnframe = 0;
            framesOffFrame=framesOffFrame+1;
        else
            myMov.onFrame(f) = 1;
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
        
        
        rtem=squeeze(ROIreg(f,:,:));
        rtem2=squeeze(ROIambig(f,:,:));
        rtem3=squeeze(ROIori(f,:,:));
        
        
        try
            idxs = sub2ind(size(rtem), monitorHeight-frameY+1, frameX);
            
            scores(f).reg =(rtem(idxs));
            scores(f).ambig =(rtem2(idxs));
            scores(f).ori =(rtem3(idxs));
        catch err
            scores(f).reg = zeros(1,size(frameY,2));
            scores(f).ambig = zeros(1,size(frameY,2));
            scores(f).ori = zeros(1,size(frameY,2));
            fprintf('*')
        end
        
        movieScore.reg(f) = sum(scores(f).reg);
        movieScore.ambig(f) = sum(scores(f).ambig);
        movieScore.ori(f) = sum(scores(f).ori);
        
        if size(scores(f).ori,2) > 0
            oriFrames = oriFrames+1;
        elseif size(scores(f).reg,2) > 0
            regFrames = regFrames+1;
        elseif size(scores(f).ambig,2) > 0
            ambigFrames = ambigFrames+1;
        else
            
        end
        
        
        
        %              plot(movie(movieTrialIndex).frame(f).calX,-movie(movieTrialIndex).frame(f).calY,'Color',oricolor,'LineWidth',5);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        frameLoad=imread([sourceMovDir,stimName,'\',num2str(f),'.bmp']); %load the frame for frame1,movie1
        cla;
        imagesc([-(size(blackround,2)/2)*xPixelAngleFactor,(size(blackround,2)/2)*xPixelAngleFactor],[-(size(blackround,1)/2)*yPixelAngleFactor,(size(blackround,1)/2)*yPixelAngleFactor],blackround);
        hold on;    %hold the background on while we also show the image (otherwise the black baground will just dissappear)
        %display the image.  Center it on the center of the screen and
        %convert itto dva
        imagesc([-(size(frameLoad,2)/2)*xPixelAngleFactor (size(frameLoad,2)/2)*xPixelAngleFactor],[-(size(frameLoad,1)/2)*yPixelAngleFactor (size(frameLoad,1)/2)*yPixelAngleFactor],frameLoad);
        hold on;    %hold on the background and image while we plot the eye data
        %plot the eye data in dva, be sure to flip the y-axis (multiply eyey by -1) since matlab plots images in inverse y-cartesian coordinates
        
        
        oricolor =[0 0 255]/255;
        regcolor = [128 0 128]/255;
        ambigcolor = [127 0 255]/255;
        
        oncolor =[0 255 0]/255;
        othercolor =[255 0 0]/255;
        
        thisFramePlotX = movie(movieTrialIndex).frame(f).calX;
        thisFramePlotY = -movie(movieTrialIndex).frame(f).calY;
        
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
        text(-16,-12,['\bf',num2str(movieTrialIndex), '   ',movie(movieTrialIndex).stimFile(1:end-4), ': frame ', num2str(f),', ', num2str(movie(movieTrialIndex).frame(f).start),' s'],'Color','w','FontSize',14);
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
