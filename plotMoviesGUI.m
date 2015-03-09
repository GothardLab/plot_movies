function varargout = plotMoviesGUI(varargin)
% PLOTMOVIESGUI MATLAB code for plotMoviesGUI.fig
%      PLOTMOVIESGUI, by itself, creates a new PLOTMOVIESGUI or raises the existing
%      singleton*.
%
%      H = PLOTMOVIESGUI returns the handle to a new PLOTMOVIESGUI or the handle to
%      the existing singleton*.
%
%      PLOTMOVIESGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTMOVIESGUI.M with the given input arguments.
%
%      PLOTMOVIESGUI('Property','Value',...) creates a new PLOTMOVIESGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plotMoviesGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plotMoviesGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plotMoviesGUI

% Last Modified by GUIDE v2.5 09-Mar-2015 14:41:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plotMoviesGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @plotMoviesGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before plotMoviesGUI is made visible.
function plotMoviesGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plotMoviesGUI (see VARARGIN)

% Choose default command line output for plotMoviesGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plotMoviesGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = plotMoviesGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function spikeFileEdit_Callback(hObject, eventdata, handles)
% hObject    handle to spikeFileEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spikeFileEdit as text
%        str2double(get(hObject,'String')) returns contents of spikeFileEdit as a double


% --- Executes during object creation, after setting all properties.
function spikeFileEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spikeFileEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function itemFileEdit_Callback(hObject, eventdata, handles)
% hObject    handle to itemFileEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of itemFileEdit as text
%        str2double(get(hObject,'String')) returns contents of itemFileEdit as a double


% --- Executes during object creation, after setting all properties.
function itemFileEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to itemFileEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in spikeFindPushButton.
function spikeFindPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to spikeFindPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in itemFindPushButton.
function itemFindPushButton_Callback(hObject, eventdata, handles)
% hObject    handle to itemFindPushButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in timeRangeCheckbox.
function timeRangeCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to timeRangeCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of timeRangeCheckbox



function startTimeEdit_Callback(hObject, eventdata, handles)
% hObject    handle to startTimeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startTimeEdit as text
%        str2double(get(hObject,'String')) returns contents of startTimeEdit as a double


% --- Executes during object creation, after setting all properties.
function startTimeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startTimeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stopTimeEdit_Callback(hObject, eventdata, handles)
% hObject    handle to stopTimeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stopTimeEdit as text
%        str2double(get(hObject,'String')) returns contents of stopTimeEdit as a double


% --- Executes during object creation, after setting all properties.
function stopTimeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stopTimeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function monitorPixelWidthEdit_Callback(hObject, eventdata, handles)
% hObject    handle to monitorPixelWidthEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of monitorPixelWidthEdit as text
%        str2double(get(hObject,'String')) returns contents of monitorPixelWidthEdit as a double


% --- Executes during object creation, after setting all properties.
function monitorPixelWidthEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to monitorPixelWidthEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function monitorPixelHeightEdit_Callback(hObject, eventdata, handles)
% hObject    handle to monitorPixelHeightEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of monitorPixelHeightEdit as text
%        str2double(get(hObject,'String')) returns contents of monitorPixelHeightEdit as a double


% --- Executes during object creation, after setting all properties.
function monitorPixelHeightEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to monitorPixelHeightEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function monitorVoltageScaleEdit_Callback(hObject, eventdata, handles)
% hObject    handle to monitorVoltageScaleEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of monitorVoltageScaleEdit as text
%        str2double(get(hObject,'String')) returns contents of monitorVoltageScaleEdit as a double


% --- Executes during object creation, after setting all properties.
function monitorVoltageScaleEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to monitorVoltageScaleEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pres2angEdit_Callback(hObject, eventdata, handles)
% hObject    handle to pres2angEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pres2angEdit as text
%        str2double(get(hObject,'String')) returns contents of pres2angEdit as a double


% --- Executes during object creation, after setting all properties.
function pres2angEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pres2angEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in colorMenu.
function colorMenu_Callback(hObject, eventdata, handles)
% hObject    handle to colorMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns colorMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from colorMenu


% --- Executes during object creation, after setting all properties.
function colorMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colorMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function outputDirEdit_Callback(hObject, eventdata, handles)
% hObject    handle to outputDirEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outputDirEdit as text
%        str2double(get(hObject,'String')) returns contents of outputDirEdit as a double


% --- Executes during object creation, after setting all properties.
function outputDirEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputDirEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in outputDirButton.
function outputDirButton_Callback(hObject, eventdata, handles)
% hObject    handle to outputDirButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function timeScaleEdit_Callback(hObject, eventdata, handles)
% hObject    handle to timeScaleEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of timeScaleEdit as text
%        str2double(get(hObject,'String')) returns contents of timeScaleEdit as a double


% --- Executes during object creation, after setting all properties.
function timeScaleEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeScaleEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function monitorCMWidthEdit_Callback(hObject, eventdata, handles)
% hObject    handle to monitorCMWidthEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of monitorCMWidthEdit as text
%        str2double(get(hObject,'String')) returns contents of monitorCMWidthEdit as a double


% --- Executes during object creation, after setting all properties.
function monitorCMWidthEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to monitorCMWidthEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function monitorCMHeightEdit_Callback(hObject, eventdata, handles)
% hObject    handle to monitorCMHeightEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of monitorCMHeightEdit as text
%        str2double(get(hObject,'String')) returns contents of monitorCMHeightEdit as a double


% --- Executes during object creation, after setting all properties.
function monitorCMHeightEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to monitorCMHeightEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function monkeyMonitorEdit_Callback(hObject, eventdata, handles)
% hObject    handle to monkeyMonitorEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of monkeyMonitorEdit as text
%        str2double(get(hObject,'String')) returns contents of monkeyMonitorEdit as a double


% --- Executes during object creation, after setting all properties.
function monkeyMonitorEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to monkeyMonitorEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cyberNamesCheckbox.
function cyberNamesCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to cyberNamesCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cyberNamesCheckbox


% --- Executes on button press in plotButton.
function plotButton_Callback(hObject, eventdata, handles)
% hObject    handle to plotButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
