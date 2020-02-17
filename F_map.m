clear
clc
%% ��������
% ������ĸ���ģ����Ե�����
[~, ~, raw] = xlsread('F_map.xlsx','Sheet3');
raw = raw(1:101,:);

%% ������ֵԪ���滻Ϊ 0.0
R = cellfun(@(x) (~isnumeric(x) && ~islogical(x)) || isnan(x),raw); % ���ҷ���ֵԪ��
raw(R) = {0.0}; % �滻����ֵԪ��
%% �����������
% XYGraph = reshape([raw{:}],size(raw));
len = 101*101;
XYGraph = reshape([raw{:}],[],len);
%% �����ʱ����
clearvars raw R;
S = std(XYGraph,0,2);
Mean =mean(XYGraph,2);
fprintf('S=%f  mean=%f\n',S,Mean)







%% ��������
[~, ~, raw] = xlsread('F_map.xlsx','Sheet1','A1:CW101');

%% ������ֵԪ���滻Ϊ 0.0
R = cellfun(@(x) (~isnumeric(x) && ~islogical(x)) || isnan(x),raw); % ���ҷ���ֵԪ��
raw(R) = {0.0}; % �滻����ֵԪ��

%% �����������
XYGraphRegretOutliers = reshape([raw{:}],size(raw));


%% �����ʱ����
clearvars raw R;

% pcolor(XYGraphRegretOutliers);


%% ���� figure
figure1 = figure('NumberTitle', 'off', 'Name', 'All Team event statistics');
colormap(jet);

% ���� axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% ���� surface
surface(XYGraphRegretOutliers,'Parent',axes1,'AlignVertexCenters','on');

% ȡ�������е�ע���Ա����������� X ��Χ
xlim(axes1,[1 101]);
% ȡ�������е�ע���Ա����������� Y ��Χ
ylim(axes1,[1 101]);
box(axes1,'on');
% ���� colorbar
colorbar('peer',axes1);
