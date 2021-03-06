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

srcDir=uigetdir('Choose source directory.'); %获得选择的文件夹
cd(srcDir);
allnames=struct2cell(dir('*.jpg'));
[k,len]=size(allnames);
I = cell(1,len);
Trimap = cell(1,len);
EstimatedAlpha = cell(1,len);
name = cell(1,len);
for i=1:len  %逐次取出文件
    try
        name{1,i}=allnames{1,i};
        I{1,i}=imread(name{1,i});
        axes(handles.image);
        imshow(I{1,i});
    
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
        path = 'C:\output-trimap\';
        savename = strrep(name{1,i},'.jpg','-trimap.bmp');
        save = fullfile(path,savename);
        imwrite(Trimap{1,i},save);
    catch
        continue
    end
end 

for j=1:len
    try
        EstimatedAlpha{1,j} = WeightedColorTextureMatting(I{1,j},Trimap{1,j});
        axes(handles.alpha);
        imshow(EstimatedAlpha{1,i});
        path = 'C:\output\';
        savename = strrep(name{1,j},'.jpg','-mask.bmp');
        save = fullfile(path,savename);
        imwrite(EstimatedAlpha{1,j},save);
    catch
        continue
    end
end

% --- Executes on button press in algorithm2.
function algorithm2_Callback(hObject, eventdata, handles)
% hObject    handle to algorithm2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


srcDir=uigetdir('Choose source directory.'); %获得选择的文件夹
cd(srcDir);
allnames=struct2cell(dir('*.jpg'));
[k,len]=size(allnames);
I = cell(1,len);
Trimap = cell(1,len);
EstimatedAlpha = cell(1,len);
name = cell(1,len);
for i=1:len  %逐次取出文件
    try
        name{1,i}=allnames{1,i};
        I{1,i}=imread(name{1,i});
        axes(handles.image);
        imshow(I{1,i});

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
        path = 'C:\output-trimap\';
        savename = strrep(name{1,i},'.jpg','-trimap.bmp');
        save = fullfile(path,savename);
        imwrite(Trimap{1,i},save);
    catch
        continue
    end
end 

for j=1:len
    try
        EstimatedAlpha{1,j} = ComprehensiveSamplingMatting(I{1,j},Trimap{1,j});
        axes(handles.alpha);
        imshow(EstimatedAlpha{1,i});
        path = 'C:\output\';
        savename = strrep(name{1,j},'.jpg','-mask.bmp');
        save = fullfile(path,savename);
        imwrite(EstimatedAlpha{1,j},save);
    catch
        continue
    end
end
