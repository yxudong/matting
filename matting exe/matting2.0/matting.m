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

% Last Modified by GUIDE v2.5 11-Apr-2017 20:47:41

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

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in algorithm1.
function algorithm1_Callback(hObject, eventdata, handles)
% hObject    handle to algorithm1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global picture1;

[filename1, pathname1] =uigetfile({'*.jpg';'*.tif';'*.png';'*.bmp';'*.gif'},'select the image');
picture1 = fullfile(pathname1,filename1);
axes(handles.image);
imshow(imread(picture1));  


I = imread(picture1);  

BWB=roipoly(I);
while isempty(BWB) 
    BWB = roipoly(I);
end
BWB_ = uint8(BWB);
BWB_(find(BWB_==0))=160;
BWB_(find(BWB_==1))=0;

BWF=roipoly(I);
while isempty(BWF) 
    BWF = roipoly(I);
end
BWF_ = uint8(BWF);
BWF_(find(BWF_==0))=160;
BWF_(find(BWF_==1))=255;

Trimap = BWF_-BWB_;
axes(handles.trimap);
imshow(Trimap);

EstimatedAlpha = WeightedColorTextureMatting(I,Trimap) ; 
axes(handles.alpha);
imshow(EstimatedAlpha);

%[savefilename,savepath]=uiputfile({'*.jpg';'*.tif';'*.png';'*.bmp';'*.gif'},'save the alpha image','-mask');
%str = [savepath savefilename];
%imwrite(EstimatedAlpha,str);

path = 'D:\output\'
savename = strrep(filename1,'.jpg','-mask.bmp')
save = fullfile(path,savename)
imwrite(EstimatedAlpha,save)

% --- Executes on button press in algorithm2.
function algorithm2_Callback(hObject, eventdata, handles)
% hObject    handle to algorithm2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global picture3;

[filename1, pathname1] =uigetfile({'*.jpg';'*.tif';'*.png';'*.bmp';'*.gif'},'select the image');
picture3 = fullfile(pathname1,filename1);
axes(handles.image);
imshow(imread(picture3));  



I = imread(picture3);  
%Trimap = rgb2gray(imread(picture4));

BWB=roipoly(I);
while isempty(BWB) 
    BWB = roipoly(I);
end
BWB_ = uint8(BWB);
BWB_(find(BWB_==0))=160;
BWB_(find(BWB_==1))=0;

BWF=roipoly(I);
while isempty(BWF) 
    BWF = roipoly(I);
end
BWF_ = uint8(BWF);
BWF_(find(BWF_==0))=160;
BWF_(find(BWF_==1))=255;

Trimap = BWF_-BWB_;
axes(handles.trimap);
imshow(Trimap);

EstimatedAlpha =  ComprehensiveSamplingMatting(I,Trimap) ; 
axes(handles.alpha);
imshow(EstimatedAlpha);

%[savefilename,savepath]=uiputfile({'*.jpg';'*.tif';'*.png';'*.bmp';'*.gif'},'save the alpha image','-mask');
%str = [savepath savefilename];
%imwrite(EstimatedAlpha,str);
path = 'D:\output\';
savename = strrep(filename1,'.jpg','-mask.bmp');
save = fullfile(path,savename);
imwrite(EstimatedAlpha,save)
