function varargout = guiSegment(varargin)
% GUISEGMENT MATLAB code for guiSegment.fig
%      GUISEGMENT, by itself, creates a new GUISEGMENT or raises the existing
%      singleton*.
%
%      H = GUISEGMENT returns the handle to a new GUISEGMENT or the handle to
%      the existing singleton*.
%
%      GUISEGMENT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUISEGMENT.M with the given input arguments.
%
%      GUISEGMENT('Property','Value',...) creates a new GUISEGMENT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiSegment_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiSegment_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiSegment

% Last Modified by GUIDE v2.5 20-Jun-2017 20:44:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @guiSegment_OpeningFcn, ...
    'gui_OutputFcn',  @guiSegment_OutputFcn, ...
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


% --- Executes just before guiSegment is made visible.
function guiSegment_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiSegment (see VARARGIN)
if numel(varargin)>0
    walk = varargin{1};
    
    %set the current_data
    handles.walk = walk;
    plot(walk.x,walk.y,'.-');
    % formatFigure()
    if isempty(walk.segment.cluster)
         disp('... calculando cúmulos')
        walk = walk.segmentCluster;
        handles.cluster = walk.segment.cluster;
       
    else
        handles.cluster = walk.segment.cluster;
    end
    if isempty(walk.segment.thread)
        disp('... calculando filamentos')
        walk =  walk.segmentThread;
        handles.thread = walk.segment.thread;
        
    else
        handles.thread = walk.segment.thread;
    end
    if isempty(walk.segment.byAnisotropy)
        disp('... calculando por anisotropía')
        walk = walk.segmentByAnisotropy;
        handles.byAnisotropy = walk.segment.byAnisotropy;
        
    else
        handles.byAnisotropy = walk.segment.byAnisotropy;
    end
    handles.current_data = walk.XY;
end
grid('on')


str = get(handles.text2,'String');

str{3} = sprintf(str{3},walk.name);
str{4} = sprintf(str{4},walk.stepsNumber);
str{5} = sprintf(str{5},walk.D('XY'),'nm^{2}/s');
str{6} = sprintf(str{6},walk.v('XY'),'nm/s');
str{7} = sprintf(str{7},walk.meanCosine);
str{8} = sprintf(str{8},walk.radius,'nm');
str{9} = sprintf(str{9},walk.duration('s'),'s');
str{10} = sprintf(str{10},walk.anisotropy);

set(handles.text2,'String',str);

% Choose default command line output for guiSegment
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Defino la caminata como el argumento


% UIWAIT makes guiSegment wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guiSegment_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
formatFig()

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Determine the selected data set.
str = get(hObject, 'String');
val = get(hObject,'Value');
% Set current data to the selected data set.
switch str{val};
    case 'Cluster' % User selects peaks.
        handles.segment = handles.cluster;
    case 'Thread' % User selects membrane.
        handles.segment = handles.thread;
    case 'byAnisotropy' % User selects sinc.
        handles.segment = handles.byAnisotropy;
end
% Save the handles structure.
guidata(hObject,handles)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if get(hObject,'Value') > length(handles.segment)
    set(hObject,'Value',1)
end

str = cell(length(handles.segment),1);
for i = 1:length(handles.segment)
    str{i} =  sprintf('%d',handles.segment{i,1});
end

set(hObject, 'String',str);
handles.segmentLength = get(hObject,'Value');

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
guidata(hObject,handles)

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


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

positions = handles.segment{handles.segmentLength,2};
str = cell(length(positions)+1,1);
str{1} = 'all';
for i = 1:length(positions)
    str{i+1} =  sprintf('%d',positions(i));
end

if isfield(handles,'ptSegStart')
    if ~isempty(handles.ptSegStart)
        delete([handles.ptSegStart,handles.ptSeg])
    end
end

if get(hObject,'Value') > length(positions)
    set(hObject,'Value',1)
end

walk = handles.walk.XY;
set(hObject, 'String',str);
handles.segmentPosition = get(hObject,'Value');

if get(hObject,'Value') > length(positions)
    set(hObject,'Value',1)
end

if handles.segmentPosition > 1
    sPos = positions(handles.segmentPosition-1);
    hold('on')
    handles.ptSegStart = plot(walk(sPos,1),walk(sPos,2),'*k');
    handles.ptSeg = plot(walk(sPos+(0:handles.segmentLength),1),...
        walk(sPos+(0:handles.segmentLength),2),'-r',...
        'LineWidth',1.5);
    hold('off')
    
    str = get(handles.text7,'String');
    walk = handles.walk(sPos+(0:handles.segmentLength),:);
        str{3} = sprintf('D = %.2f ( %s )',walk.D('XY'),'nm^{2}/s');
        str{4} = sprintf('v = %.2f ( %s )',walk.v('XY'),'nm/s');
        str{5} = sprintf('<cos> = %.2g',walk.meanCosine);
        str{6} = sprintf('Extension = %.2f ( %s )',walk.radius,'nm');
        str{7} = sprintf('Duration = %.2f ( %s )',walk.duration('s'),'s');
        str{8} = sprintf('Anisotropy = %.3g',walk.anisotropy);
    set(handles.text7,'String',str);
    
elseif handles.segmentPosition == 1
    hold('on')
    for i=1:length(positions)
        sPos = positions(i);
        handles.ptSegStart(i) = plot(walk(sPos,1),walk(sPos,2),'*k');
        handles.ptSeg(i) = plot(walk(sPos+(0:handles.segmentLength),1),...
            walk(sPos+(0:handles.segmentLength),2),'-r',...
            'LineWidth',1.5);
    end
    hold('off')
    
    try
        str = get(handles.text7,'String');
        walk = handles.walk(sPos+(0:handles.segmentLength),:);
        str{3} = sprintf('D = %.2f ( %s )',walk.D('XY'),'nm^{2}/s');
        str{4} = sprintf('v = %.2f ( %s )',walk.v('XY'),'nm/s');
        str{5} = sprintf('<cos> = %.2g',walk.meanCosine);
        str{6} = sprintf('Extension = %.2f ( %s )',walk.radius,'nm');
        str{7} = sprintf('Duration = %.2f ( %s )',walk.duration('s'),'s');
        str{8} = sprintf('Anisotropy = %.3g',walk.anisotropy);
        
        set(handles.text7,'String',str);
        
    end
    
end
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function formatFig()



% ax = get(gca);

hTitle = title('');
hXLabel = xlabel('x ( nm )');
hYLabel =  ylabel('y ( nm )');
hLegend = legend('off');

set([hTitle, hXLabel, hYLabel], ...
    'FontName'   , 'AvantGarde');
%
% set([hLegend, ax ]             , ...
%     'FontSize'   , 10         );

set([hXLabel, hYLabel]  , ...
    'FontSize'   , 12   , ...
    'FontWeight' , 'normal');
%
% set( hTitle                    , ...
%     'FontSize'   , 12          , ...
%     'FontWeight' , 'bold'      );
%
% set(ax, ...
%     'PlotBoxAspectRatio' , [1 1 1],...
%     'Box'         , 'on'     , ...
%     'TickDir'     , 'out'     , ...
%     'TickLength'  , [.02 .02] , ...
%     'LineWidth'   , 1         , ...
%     'FontWeight'  , 'normal'     ,...
%     'FontName'   , 'Helvetica' ,...
%     'FontSize'    , 12     ,... %%poner parentesis aca para polarplot
%     'XMinorTick'  , 'on'      , ...
%     'YMinorTick'  , 'on'      , ...
%     'XGrid'        , 'on'    , ...
%     'YGrid'        , 'on'    , ...
%     'XColor'      , 3*[.1 .1 .1], ...
%     'YColor'      , 3*[.1 .1 .1] );


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over popupmenu2.
function popupmenu2_ButtonDownFcn(hObject, eventdata, handles)
set(hObject, 'String','Segment length');
set(hObject,'Value',1);
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over popupmenu3.
function popupmenu3_ButtonDownFcn(hObject, eventdata, handles)
set(hObject, 'String','Segment position');
set(hObject,'Value',1);
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over popupmenu1.
function popupmenu1_ButtonDownFcn(hObject, eventdata, handles)
set(hObject, 'String','Segment type');
set(hObject,'Value',1);
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function text2_CreateFcn(hObject, eventdata, handles)
get(hObject,'String')
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
