clear
clc
%% 导入数据
% 计算带四个点的，忽略掉代码
[~, ~, raw] = xlsread('F_map.xlsx','Sheet3');
raw = raw(1:101,:);

%% 将非数值元胞替换为 0.0
R = cellfun(@(x) (~isnumeric(x) && ~islogical(x)) || isnan(x),raw); % 查找非数值元胞
raw(R) = {0.0}; % 替换非数值元胞
%% 创建输出变量
% XYGraph = reshape([raw{:}],size(raw));
len = 101*101;
XYGraph = reshape([raw{:}],[],len);
%% 清除临时变量
clearvars raw R;
S = std(XYGraph,0,2);
Mean =mean(XYGraph,2);
fprintf('S=%f  mean=%f\n',S,Mean)







%% 导入数据
[~, ~, raw] = xlsread('F_map.xlsx','Sheet1','A1:CW101');

%% 将非数值元胞替换为 0.0
R = cellfun(@(x) (~isnumeric(x) && ~islogical(x)) || isnan(x),raw); % 查找非数值元胞
raw(R) = {0.0}; % 替换非数值元胞

%% 创建输出变量
XYGraphRegretOutliers = reshape([raw{:}],size(raw));


%% 清除临时变量
clearvars raw R;

% pcolor(XYGraphRegretOutliers);


%% 创建 figure
figure1 = figure('NumberTitle', 'off', 'Name', 'All Team event statistics');
colormap(jet);

% 创建 axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% 创建 surface
surface(XYGraphRegretOutliers,'Parent',axes1,'AlignVertexCenters','on');

% 取消以下行的注释以保留坐标区的 X 范围
xlim(axes1,[1 101]);
% 取消以下行的注释以保留坐标区的 Y 范围
ylim(axes1,[1 101]);
box(axes1,'on');
% 创建 colorbar
colorbar('peer',axes1);
