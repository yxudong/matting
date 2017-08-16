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

%global picture1;
%global picture2;

%[filename1, pathname1] =uigetfile({'*.jpg';'*.tif';'*.png';'*.bmp';'*.gif'},'select the image');
%picture1 = fullfile(pathname1,filename1);
%axes(handles.image);
%imshow(imread(picture1));  

%[filename2, pathname2] =uigetfile({'*.jpg';'*.tif';'*.png';'*.bmp';'*.gif'},'select the trimap');
%picture2 = fullfile(pathname2,filename2);
%axes(handles.trimap);
%imshow(imread(picture2));

srcDir=uigetdir('Choose source directory.'); %获得选择的文件夹
cd(srcDir);
allnames=struct2cell(dir('*.jpg'));          %只处理jpg文件
[k,len]=size(allnames);                      %获得文件的个数
I = cell(1,len);                             %存储原始图像数据
R = cell(1,len);
R_ = cell(1,len);
Trimap = cell(1,len);
EstimatedAlpha = cell(1,len);
name = cell(1,len);
for i=1:len                                  %逐次取出文件
    name{1,i}=allnames{1,i};
    I{1,i}=imread(name{1,i});                %读取文件
    axes(handles.image);
    imshow(I{1,i});
    R{1,i}=roipoly(I{1,i});                  %标注返回二值图像  
    while isempty(R{1,i}) 
        R{1,i} = roipoly(I{1,i});
    end
end
for i=1:len 
    R_{1,i} = R{1,i}*255;       
    for m = 1:size(R_{1,i},2);
        d = diff(R_{1,i}(:,m));
        f = find(d==255|d==-255);
        for n = 1:size(f,1)
            if f(n,1)-15<1
                a = 1
            else
                a = f(n,1)-15
            end
            if f(n,1)+15>size(R_{1,i},1)
                b = size(R_{1,i},1)
            else
                b = f(n,1)+15
            end
            R_{1,i}(a:b,m)=160;
        end
    end
    for n = 1:size(R_{1,i},1)
        d = diff(R_{1,i}(n,:)');
        f = find(d==255|d==-255|d==160|d==-160|d==95|d==-95);
        for m = 1:size(f,1)
            if f(m,1)-15<1
                a = 1
            else
                a = f(m,1)-15
            end
            if f(m,1)+15>size(R_{1,i},2)
                b = size(R_{1,i},2)
            else
                b = f(m,1)+15
            end
            R_{1,i}(n,a:b)=160;
        end
    end
    Trimap{1,i} = uint8(R_{1,i});
    axes(handles.trimap);
    imshow(Trimap{1,i});
    %EstimatedAlpha{1,i} = WeightedColorTextureMatting(I{1,i},Trimap{1,i}) ; 
end 

for j=1:len
    try
        EstimatedAlpha{1,j} = WeightedColorTextureMatting(I{1,j},Trimap{1,j});
        axes(handles.alpha);
        imshow(EstimatedAlpha{1,i});
        path = 'D:\output\';
        savename = strrep(name{1,j},'.jpg','-mask.bmp');
        save = fullfile(path,savename);
        imwrite(EstimatedAlpha{1,j},save);
    catch
        continue;
    end
end

% --- Executes on button press in algorithm2.
function algorithm2_Callback(hObject, eventdata, handles)
% hObject    handle to algorithm2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%global picture3;
%global picture4;

%[filename1, pathname1] =uigetfile({'*.jpg';'*.tif';'*.png';'*.bmp';'*.gif'},'select the image');
%picture3 = fullfile(pathname1,filename1);
%axes(handles.image);
%imshow(imread(picture3));  

%[filename2, pathname2] =uigetfile({'*.jpg';'*.tif';'*.png';'*.bmp';'*.gif'},'select the trimap');
%picture4 = fullfile(pathname2,filename2);
%axes(handles.trimap);
%imshow(imread(picture4));

%I = imread(picture3);  
%Trimap = rgb2gray(imread(picture4));

% srcDir=uigetdir('Choose source directory.'); %获得选择的文件夹
% cd(srcDir);
% allnames=struct2cell(dir('*.jpg')); %只处理8位的bmp文件
% [k,len]=size(allnames); %获得bmp文件的个数
% I = cell(1,len);
% Trimap = cell(1,len);
% EstimatedAlpha = cell(1,len);
% name = cell(1,len);
% for i=1:len  %逐次取出文件
%     name{1,i}=allnames{1,i};
%     I{1,i}=imread(name{1,i}); %读取文件
%     axes(handles.image);
%     imshow(I{1,i});
%     
%     BWB=roipoly(I{1,i});
%     BWB_ = uint8(BWB);
%     BWB_(find(BWB_==0))=160;
%     BWB_(find(BWB_==1))=0;
%     
%     BWF=roipoly(I{1,i});
%     BWF_ = uint8(BWF);
%     BWF_(find(BWF_==0))=160;
%     BWF_(find(BWF_==1))=255;
%     
%     Trimap{1,i} = BWF_-BWB_;
%     axes(handles.trimap);
%     imshow(Trimap{1,i});
%     
%     %EstimatedAlpha{1,i} = WeightedColorTextureMatting(I{1,i},Trimap{1,i}) ; 
% end 
% 
% for j=1:len
%     EstimatedAlpha{1,j} = WeightedColorTextureMatting(I{1,j},Trimap{1,j});
%     axes(handles.alpha);
%     imshow(EstimatedAlpha{1,i});
%     path = 'D:\output\';
%     savename = strrep(name{1,j},'.jpg','-mask.bmp');
%     save = fullfile(path,savename);
%     imwrite(EstimatedAlpha{1,j},save) %然后在此处添加的图像处理程序即可
% end


srcDir=uigetdir('Choose source directory.'); %获得选择的文件夹
cd(srcDir);
allnames=struct2cell(dir('*.jpg'));          %只处理jpg文件
[k,len]=size(allnames);                      %获得文件的个数
I = cell(1,len);                             %存储原始图像数据
R = cell(1,len);
R_ = cell(1,len);
Trimap = cell(1,len);
EstimatedAlpha = cell(1,len);
name = cell(1,len);
for i=1:len                                  %逐次取出文件
    name{1,i}=allnames{1,i};
    I{1,i}=imread(name{1,i});                %读取文件
    axes(handles.image);
    imshow(I{1,i});
    
    R{1,i}=roipoly(I{1,i});                  %标注返回二值图像
    R_{1,i} = R{1,i}*255;       
    for j = 1:size(R_{1,i},2)
        d = diff(R_{1,i}(:,j));
        f = find(d==255|d==-255);
        for i = 1:size(f,1)
            if f(i,1)-15<1
                a = 1
            else
                a = f(i,1)-15
            end
            if f(i,1)+15>size(R_{1,i},1)
                b = size(R_{1,i},1)
            else
                b = f(i,1)+15
            end
            R_{1,i}(a:b,j)=160;
        end
    end
    for i = 1:size(R_{1,i},1)
        d = diff(R_{1,i}(i,:)');
        f = find(d==255|d==-255|d==160|d==-160|d==95|d==-95);
        for j = 1:size(f,1)
            if f(j,1)-15<1
                a = 1
            else
                a = f(j,1)-15
            end
            if f(j,1)+15>size(R_{1,i},2)
                b = size(R_{1,i},2)
            else
                b = f(j,1)+15
            end
            R_{1,i}(i,a:b)=160;
        end
    end
    Trimap = uint8(R_{1,i});
    axes(handles.trimap);
    imshow(Trimap{1,i});
    %EstimatedAlpha{1,i} = WeightedColorTextureMatting(I{1,i},Trimap{1,i}) ; 
end 

for j=1:len
    EstimatedAlpha{1,j} = ComprehensiveSamplingMatting(I{1,j},Trimap{1,j});
    axes(handles.alpha);
    imshow(EstimatedAlpha{1,i});
    path = 'D:\output\';
    savename = strrep(name{1,j},'.jpg','-mask.bmp');
    save = fullfile(path,savename);
    imwrite(EstimatedAlpha{1,j},save) %然后在此处添加的图像处理程序即可
end

%[savefilename,savepath]=uiputfile({'*.jpg';'*.tif';'*.png';'*.bmp';'*.gif'},'save the alpha image','-mask');
%str = [savepath savefilename];
%imwrite(EstimatedAlpha,str);
