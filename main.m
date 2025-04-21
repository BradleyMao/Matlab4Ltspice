clc;
clear;

%% 单个数据处理运行此段脚本
filename = 'CREE3Pin_Ron020_Roff020_Von150_Voff040_ID040_VD0800.raw';
DPT_data = LTspiceDataExtract(filename);
DPT_setting = parseFilename(filename);

[turn_on_range,turn_off_range] = Get_TurnonTurnoff_Range(DPT_data.Vin, DPT_data.time);
turn_off = Get_Turnoff_Characters(turn_off_range,DPT_data,DPT_setting);
turn_on = Get_Turnon_Characters(turn_on_range,DPT_data,DPT_setting);

%% 处理示例函数
data_summary = DPTBatchProcessing('');

%% 画图示例
% 定义原始文件目录

file_path = '';
chose_files = {'CREE3Pin_Ron020_Roff020_Von150_Voff040_ID040_VD0800.raw' };
variables = {'Ig_H', 'Ig_L'};
RAW_plot(file_path, chose_files, variables);
    

C:\Users\bradley\Desktop\Temp
C:\Users\bradley\Desktop\Temp\POST\Demo.xlsx




