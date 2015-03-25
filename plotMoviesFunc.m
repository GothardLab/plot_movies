%       plotMoviesFunc.m
%           Written by Philip Putnam, University of Arizona, 2015

function plotMoviesFunc( plotDat )
%PLOTMOVIESFUNC Plots movie scanpath input from GUI or wrapper function
%   Inputs
%       'spike', (string): Path to spike file
%       'item', (string): Path to item file
%       'out'. (string): Path to output directory
%       'source', (string): Path to source directory

%Need to write vargin for plotDat or commands

%%%%%%Debug%%%%%%%%
% clear all
% clc
% load('plotDat.mat');
%%%%%%%%%%%%%%%%%%%

% Set values from plotDat
sourceDir = plotDat.sourceParams.sourceDir;
outDir = plotDat.outParams.outDir;
spikePath = plotDat.smrParams.path;
itemPath = plotDat.itemParams.path;
presentParams = plotDat.presentParams;
outParams = plotDat.outParams;

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

%Get the data file name
[~, dataName, ~] = fileparts(plotDat.smrParams.fname);

%Find the output path
if plotDat.plotParams.cypherNames
    [ cipherDataName ] = cipherName( dataName );
    saveDir = fullfile(outParams.outDir, cipherDataName);
else  
    saveDir = fullfile(outParams.outDir, dataName);
end

if ~isdir(saveDir)
        mkdir(saveDir)
end

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
    
    %Make a movie title
    movieTitle = strcat(stimName, '_',num2str(thisTrial.instance), '_', num2str(round(thisTrial.movieOnS)), '-', num2str(round(thisTrial.movieOffS)));
    
    %Find where to save the file
    if plotDat.plotParams.cypherNames
        [ cipherMovieTitle ] = cipherName( movieTitle );
        movieWritePath = fullfile(saveDir, [cipherMovieTitle, '.avi']);
    else  
        movieWritePath = fullfile(saveDir, [movieTitle, '.avi']);
    end
    
    %Create writer object for the movie
    writerObj = VideoWriter(movieWritePath);
    
    %Open the writer object
    open(writerObj);

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
    
   % set(gca,'xdir','reverse')
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
        plot(calX,-calY,'Color',fixColor,'LineWidth',5);
        
        
        if ~plotDat.plotParams.cypherNames
            %Create a movie info string to display
            movieInfoStr = ['\bf',num2str(t), '   ',stimName, ': frame ', num2str(f),', ', num2str(round(thisTrial.movieOnS)),' s'];
            
            %Display the string
            text(-17,-15, movieInfoStr, 'Color','w','FontSize',14);
        
        end
        
        %Get the frame to save
        frame = getframe;
        
        %Write the frame to the movie
        writeVideo(writerObj,frame);
        
        %Clear varibles just in case
        clear frameLoad frame rawX rawY calX calY
    end
    
    %Clear varibles just in case
    clear thisTrial stimFrames f
    
    %Close the writer object
    close(writerObj);
    
    %Close the figure
    close(plotH)
    
end

