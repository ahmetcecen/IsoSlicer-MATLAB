function varargout = IsoSlicer(varargin)
% ISOSLICER MATLAB code for IsoSlicer.fig
%      ISOSLICER, by itself, creates a new ISOSLICER or raises the existing
%      singleton*.
%
%      H = ISOSLICER returns the handle to a new ISOSLICER or the handle to
%      the existing singleton*.
%
%      ISOSLICER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ISOSLICER.M with the given input arguments.
%
%      ISOSLICER('Property','Value',...) creates a new ISOSLICER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IsoSlicer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IsoSlicer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IsoSlicer

% Last Modified by GUIDE v2.5 24-Feb-2016 15:44:16
% Copyright (c) 2015, Ahmet Cecen  -  All rights reserved.

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IsoSlicer_OpeningFcn, ...
                   'gui_OutputFcn',  @IsoSlicer_OutputFcn, ...
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

% --- Executes just before IsoSlicer is made visible.
function IsoSlicer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IsoSlicer (see VARARGIN)

% Choose default command line output for IsoSlicer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global hlink
hlink = linkprop([handles.axes1,handles.axes3],{'CameraPosition','CameraUpVector'});
set(handles.axes1,'view',[45 45]);
set(handles.axes3,'view',[45 45]);

vars = evalin('base','whos');
j = 2;
list{1} = 'Load (Workspace)';
for i = 1:length(vars)
   if  length(vars(i).size) == 3
       list{j} = vars(i).name;
       j = j+1;
   end
end
set(handles.popupmenu4,'String',list);

global surfacecount
surfacecount = 0;



% This sets up the initial plot - only do when we are invisible
% so window can get raised using IsoSlicer.

% UIWAIT makes IsoSlicer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = IsoSlicer_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global GG
global level

axes(handles.axes1);
cla

level=get(hObject,'Value');

set(handles.edit1,'String',num2str(level));

% Construct Iso-surface
[faces,verts] = isosurface(GG,level); 


% Display Current Surface
patch('Vertices', verts, 'Faces', faces, ... 
    'FaceColor', [0 0 0], ...
    'FaceAlpha', 0.3, ...
    'EdgeAlpha',0)

% Formatting
axis image;
grid on;

set(handles.axes1,'YLim',[0 size(GG,1)]);
set(handles.axes1,'XLim',[0 size(GG,2)]);
set(handles.axes1,'ZLim',[0 size(GG,3)]);

set(handles.axes1,'YTick',[0 round((size(GG,1)+1)/4) ((size(GG,1)+1)/2) round(3*(size(GG,1)+1)/4) (size(GG,1))]);
set(handles.axes1,'XTick',[0 round((size(GG,2)+1)/4) ((size(GG,2)+1)/2) round(3*(size(GG,2)+1)/4) (size(GG,2))]);
set(handles.axes1,'ZTick',[0 round((size(GG,3)+1)/4) ((size(GG,3)+1)/2) round(3*(size(GG,3)+1)/4) (size(GG,3))]);

set(handles.axes1,'YTickLabel',[((size(GG,1)+1)/2) round((size(GG,1)+1)/4) 0 round((size(GG,1)+1)/4) ((size(GG,1)+1)/2)]);
set(handles.axes1,'XTickLabel',[((size(GG,2)+1)/2) round((size(GG,2)+1)/4) 0 round((size(GG,2)+1)/4) ((size(GG,2)+1)/2)]);
set(handles.axes1,'ZTickLabel',[((size(GG,3)+1)/2) round((size(GG,3)+1)/4) 0 round((size(GG,3)+1)/4) ((size(GG,3)+1)/2)]);

set(handles.axes3,'YLim',[0 size(GG,1)]);
set(handles.axes3,'XLim',[0 size(GG,2)]);
set(handles.axes3,'ZLim',[0 size(GG,3)]);

set(handles.axes3,'YTick',[0 round((size(GG,1)+1)/4) ((size(GG,1)+1)/2) round(3*(size(GG,1)+1)/4) (size(GG,1))]);
set(handles.axes3,'XTick',[0 round((size(GG,2)+1)/4) ((size(GG,2)+1)/2) round(3*(size(GG,2)+1)/4) (size(GG,2))]);
set(handles.axes3,'ZTick',[0 round((size(GG,3)+1)/4) ((size(GG,3)+1)/2) round(3*(size(GG,3)+1)/4) (size(GG,3))]);

set(handles.axes3,'YTickLabel',[((size(GG,1)+1)/2) round((size(GG,1)+1)/4) 0 round((size(GG,1)+1)/4) ((size(GG,1)+1)/2)]);
set(handles.axes3,'XTickLabel',[((size(GG,2)+1)/2) round((size(GG,2)+1)/4) 0 round((size(GG,2)+1)/4) ((size(GG,2)+1)/2)]);
set(handles.axes3,'ZTickLabel',[((size(GG,3)+1)/2) round((size(GG,3)+1)/4) 0 round((size(GG,3)+1)/4) ((size(GG,3)+1)/2)]);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global GG
ESS = uiimport;
vars = fieldnames(ESS);
GG = ESS.(vars{1});

set(handles.slider1,'Value',max(GG(:)));
set(handles.slider1,'Max',max(GG(:)));
set(handles.slider1,'Min',min(GG(:)));
set(handles.slider1,'SliderStep', [ 0.0001 , 0.01 ] );


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

set(handles.slider1,'Value',str2double(get(hObject,'String')));
handles.slider1.Callback(handles.slider1,eventdata)

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global plist
axes(handles.axes3);
plist{get(handles.popupmenu2,'Value')}.FaceAlpha= get(handles.slider2,'Value');

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global plist
axes(handles.axes3);
plist{get(handles.popupmenu2,'Value')}.FaceColor=[get(handles.slider3,'Value') get(handles.slider4,'Value') get(handles.slider5,'Value')];

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global plist
axes(handles.axes3);
plist{get(handles.popupmenu2,'Value')}.FaceColor=[get(handles.slider3,'Value') get(handles.slider4,'Value') get(handles.slider5,'Value')];

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global plist
axes(handles.axes3);
plist{get(handles.popupmenu2,'Value')}.FaceColor=[get(handles.slider3,'Value') get(handles.slider4,'Value') get(handles.slider5,'Value')];

% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global surfacecount
global GG
global level
global plist
global levellist

surfacecount = surfacecount +1;

for ii=1:surfacecount
    popcell{ii} = ii;
end

set(handles.popupmenu2,'String',popcell)

axes(handles.axes3);

level=get(handles.slider1,'Value');

levellist(surfacecount) = level;

set(handles.edit1,'String',num2str(level));

% Construct Iso-surface
[faces,verts] = isosurface(GG,level); 


% Display Current Surface
plist{surfacecount}=patch('Vertices', verts, 'Faces', faces, ... 
    'FaceColor', [0 0 0], ...
    'FaceAlpha', 0.3, ...
    'EdgeAlpha',0);

% Formatting
axis image;
grid on;

set(handles.axes3,'YLim',[0 size(GG,1)]);
set(handles.axes3,'XLim',[0 size(GG,2)]);
set(handles.axes3,'ZLim',[0 size(GG,3)]);

set(handles.axes3,'YTick',[0 round((size(GG,1)+1)/4) ((size(GG,1)+1)/2) round(3*(size(GG,1)+1)/4) (size(GG,1))]);
set(handles.axes3,'XTick',[0 round((size(GG,2)+1)/4) ((size(GG,2)+1)/2) round(3*(size(GG,2)+1)/4) (size(GG,2))]);
set(handles.axes3,'ZTick',[0 round((size(GG,3)+1)/4) ((size(GG,3)+1)/2) round(3*(size(GG,3)+1)/4) (size(GG,3))]);

set(handles.axes3,'YTickLabel',[((size(GG,1)+1)/2) round((size(GG,1)+1)/4) 0 round((size(GG,1)+1)/4) ((size(GG,1)+1)/2)]);
set(handles.axes3,'XTickLabel',[((size(GG,2)+1)/2) round((size(GG,2)+1)/4) 0 round((size(GG,2)+1)/4) ((size(GG,2)+1)/2)]);
set(handles.axes3,'ZTickLabel',[((size(GG,3)+1)/2) round((size(GG,3)+1)/4) 0 round((size(GG,3)+1)/4) ((size(GG,3)+1)/2)]);


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global levellist;
Figure1 = figure;
copyobj(handles.axes3, Figure1);
for i=1:length(levellist)
    legstr{i}=num2str(levellist(i));
end
legend(legstr);
leg = legend;
axs = gca;
leg.Position(1) = axs.Position(1) + axs.Position(3) + 0.1; 

hgsave(Figure1, 'Figure.fig');


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4
global GG
vars = evalin('base','whos');
j = 2;
list{1} = 'Load (Workspace)';
for i = 1:length(vars)
   if  length(vars(i).size) == 3
       list{j} = vars(i).name;
       j = j+1;
   end
end
set(handles.popupmenu4,'String',list);
contents = cellstr(get(hObject,'String'));

if strcmp(contents{get(hObject,'Value')},'Load (Workspace)') ~= 1
    GG = evalin('base',contents{get(hObject,'Value')});
    
    set(handles.slider1,'Value',max(GG(:)));
    set(handles.slider1,'Max',max(GG(:)));
    set(handles.slider1,'Min',min(GG(:)));
    set(handles.slider1,'SliderStep', [ 0.0001 , 0.01 ] );
end



% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
