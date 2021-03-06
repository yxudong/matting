function varargout = matting(varargin)
% MATTING MATLAB code for matting.fig
%      MATTING, by itself, creates a new MATTING or raises the existing
%      singleton*.
%
%      H = MATTING returns the handle to a new MATTING or the handle to
%      the existing singleton*.
%
%      MATTING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MATTING.M with the given input arguments.
%
%      MATTING('Property','Value',...) creates a new MATTING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before matting_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to matting_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help matting

% Last Modified by GUIDE v2.5 17-Sep-2017 20:30:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @matting_OpeningFcn, ...
                   'gui_OutputFcn',  @matting_OutputFcn, ...
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


% --- Executes just before matting is made visible.
function matting_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to matting (see VARARGIN)

% Choose default command line output for matting
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes matting wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = matting_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%弹出窗口时就最大化  
 javaFrame = get(gcf,'JavaFrame');  
 set(javaFrame,'Maximized',1);  

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[filename1, pathname1] =uigetfile({'*.jpg';'*.tif';'*.png';'*.bmp';'*.gif'},'select the image');
pic_origin = fullfile(pathname1,filename1);
axes(handles.origin);
imshow(imread(pic_origin),'InitialMagnification','fit');  

[filename2, pathname2] =uigetfile({'*.jpg';'*.tif';'*.png';'*.bmp';'*.gif'},'select the trimap');
pic_trimap = fullfile(pathname2,filename2);
axes(handles.trimap);
imshow(imread(pic_trimap),'InitialMagnification','fit');

I = imread(pic_origin); 
Trimap = imread(pic_trimap);
l=size(Trimap, 3);
if l==3
     Trimap=rgb2gray(Trimap);
end

% EstimatedAlpha =  ComprehensiveSamplingMatting(I,Trimap); 
EstimatedAlpha =  WeightedColorTextureMatting(I,Trimap); 

axes(handles.alpha);
imshow(EstimatedAlpha);

[savefilename,savepath]=uiputfile({'*.jpg';'*.tif';'*.png';'*.bmp';'*.gif'},'save the alpha image','-mask');
str = [savepath savefilename];
imwrite(EstimatedAlpha,str);