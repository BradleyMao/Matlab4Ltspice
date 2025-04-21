function data_summary = DPTBatchProcessing(data_path)
% 初始化总表和元数据架构
data_summary = table();
file_counter = 1;

% 多步仿真参数转换[^3]
raw_files = dir(fullfile(data_path, '*.raw'));
for n = 1:length(raw_files)
    try
        % 核心参数提取 (处理多步仿真情形)[^4]
        DPT_data = LTspiceDataExtract(fullfile(data_path, raw_files(n).name));
        DPT_settings = parseFilename(fullfile(data_path, raw_files(n).name));
        [turn_on_range, turn_off_range] = Get_TurnonTurnoff_Range(DPT_data.Vin,DPT_data.time);
        turnon = Get_Turnon_Characters(turn_on_range,DPT_data,DPT_settings);
        turnoff = Get_Turnoff_Characters(turn_off_range,DPT_data,DPT_settings);
        
        % 创建当前文件的元数据行
        meta_row = table(...
            {raw_files(n).name},...
            'VariableNames', {'FileName'});
        
        % 转换仿真设置参数 (结构体展平)[^6]
        settings_cell = struct2cell(DPT_settings);
        settings_keys = fieldnames(DPT_settings);
        for k = 1:length(settings_keys)
            meta_row.(settings_keys{k}) = settings_cell(k);
        end
        
        % 合并动态参数 (支持多维时域数据)[^1]
        params_on = struct2table(turnon);

        params_off = struct2table(turnoff);
        
        % 构建完整数据行
        full_row = [meta_row params_on params_off];
        data_summary = [data_summary; full_row]; % 垂直合并
        
        file_counter = file_counter + 1;
    catch ME
        fprintf('文件 %s 处理失败: %s\n', raw_files(n).name, ME.message);
    end
end

% 数据存储 (支持大数据量分页写入)[^5]
end
