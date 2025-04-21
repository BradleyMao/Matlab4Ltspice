function RAW_plot(file_path, chose_files, variables_to_plot)
% 颜色配置（最大支持7个文件）
color_set = lines(7); 

% 预初始化存储完整路径的元胞数组
raw_files = cell(size(chose_files)); 

% 遍历文件名，构建完整路径
for i = 1:length(chose_files)
    raw_files{i} = fullfile(file_path, chose_files{i});
end




% 每个变量独立生成开关区间对比图
for var_idx = 1:length(variables_to_plot)
    var_name = variables_to_plot{var_idx};
    
    % 创建新画布并分割区域
    fig = figure('Name', [var_name ' 开关区间分析'], 'NumberTitle','off');
    set(fig, 'Position', [200 200 800 600]);
    
    % 生成开通区间子图
    ax1 = subplot(2,1,1);
    hold(ax1, 'on');
    title([var_name '开通区间波形']);
    ylabel(var_name);
    grid on;
    
    % 生成关断区间子图
    ax2 = subplot(2,1,2);
    hold(ax2, 'on');
    title([var_name '关断区间波形']);
    xlabel('时间 (秒)[^5]');
    ylabel(var_name);
    grid on;
    
    % 遍历文件读取数据
    for file_idx = 1:length(raw_files)
        % 读取LTspice数据
        DPT_data = LTspiceDataExtract(raw_files{file_idx});
        t = DPT_data.time; 
        y_data = DPT_data.(var_name);
        
        % 提取开关时间点
        [ton_range, toff_range] = Plot_TurnonTurnoff_Range(DPT_data.Vin,t); 
        
        % 选择当前文件颜色
        line_color = color_set(mod(file_idx-1,7)+1,:);
        
        % 简化的图例名称处理
        [~,name_part] = fileparts(raw_files{file_idx});
        legend_name = name_part(1:min(end,end)); % 截取前8字符
        
        % 开通区间绘图
        mask_ton = (t >= ton_range(1)) & (t <= ton_range(2));
        plot(ax1, t(mask_ton), y_data(mask_ton),...
            'Color', line_color, 'LineWidth', 1.6,...
            'DisplayName', legend_name); 
        
        % 关断区间绘图
        mask_toff = (t >= toff_range(1)) & (t <= toff_range(2));
        plot(ax2, t(mask_toff), y_data(mask_toff),...
            'Color', line_color, 'LineWidth', 1.6,...
            'DisplayName', legend_name);
    end
    

    legend(ax1, 'box','off', 'Location','northeastoutside');
    legend(ax2, 'box','off', 'Location','northeastoutside');
end
end
