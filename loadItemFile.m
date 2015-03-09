%% loadItemFile
% Written by Philip Putnam, 2014
% Gothard Laboratory, University of Arizona
%
%   This script loads a text item file used by presentation
%   and returns cell of the movie names
%
%   Inputs:
%       itmFilePath - A string of the absolute path to the text file
%
%
%   Outputs:
%       item - A cell of the item file names, in order of the text file

function item = loadItemFile(itmFilePath)

fID=fopen(itmFilePath,'r'); %open the file

firstLine = fgetl(fID); %get the firstline of the itmfile

stimIndex=strfind(firstLine, '|moviename'); %movie names aligned under 

condition=0; %set a counter variable "c" to a value zero

while ~feof(fID)    %keep reading as long as there are still lines
    readLine = fgetl(fID); %read in the next line from the itm file
    aviIndex=strfind(readLine,'.avi'); %all files use .avi, even images...
    lineFilename = readLine(stimIndex+1:aviIndex+3); %Read the line
    
    if size(lineFilename,2) %If the line isn't empty
        condition=condition+1; %Increase the condition count
        item{condition} = lineFilename; %Save the file name
    end 
end

item=item';