function varargout = generate_trimap(varargin)
% GENERATE_TRIMAP MATLAB code for generate_trimap.fig
%      GENERATE_TRIMAP, by itself, creates a new GENERATE_TRIMAP or raises the existing
%      singleton*.
%
%      H = GENERATE_TRIMAP returns the handle to a new GENERATE_TRIMAP or the handle to
%      the existing singleton*.
%
%      GENERATE_TRIMAP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GENERATE_TRIMAP.M with the given input arguments.
%
%      GENERATE_TRIMAP('Property','Value',...) creates a new GENERATE_TRIMAP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before generate_trimap_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to generate_trimap_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help generate_trimap

% Last Modified by GUIDE v2.5 18-Sep-2017 14:54:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @generate_trimap_OpeningFcn, ...
                   'gui_OutputFcn',  @generate_trimap_OutputFcn, ...
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


% --- Executes just before generate_trimap is made visible.
function generate_trimap_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to generate_trimap (see VARARGIN)

% Choose default command line output for generate_trimap
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes generate_trimap wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = generate_trimap_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


srcDir=uigetdir('Choose source directory.'); %获得选择的文件夹
cd(srcDir);
allnames=struct2cell(dir('*.jpg'));
len=size(allnames, 2);
I = cell(1,len);
Trimap = cell(1,len);
name = cell(1,len);

directoryname = uigetdir('', 'Pick Trimap Save Directory');   % 选择trimap结果保存目录

for i=1:len  %逐次取出文件
    name{1,i}=allnames{1,i};
    I{1,i}=imread(name{1,i});
    axes(handles.origin);
    imshow(I{1,i});
    try
        BWB=roipoly(I{1,i});
        while isempty(BWB) 
            BWB = roipoly(I{1,i});
        end
        BWB_ = uint8(BWB);
        BWB_(find(BWB_==0))=160;
        BWB_(find(BWB_==1))=0;

        BWF=roipoly(I{1,i});
        while isempty(BWF) 
            BWF = roipoly(I{1,i});
        end
        BWF_ = uint8(BWF);
        BWF_(find(BWF_==0))=160;
        BWF_(find(BWF_==1))=255;

        Trimap{1,i} = BWF_-BWB_;
        axes(handles.trimap);
        imshow(Trimap{1,i});
    catch
        continue
    end
    savename = strrep(name{1,i},'.jpg','-trimap.bmp');
    save = fullfile(directoryname,savename);
    imwrite(Trimap{1,i},save);
end
