function [turn_on_range, turn_off_range] = Get_TurnonTurnoff_Range(Vin, time)
% 功能：根据电压信号自动检测开关区间
% 输入：Vin(电压向量), time(时间向量)
% 输出：turn_on_range(Nx2矩阵,开通时间区间), turn_off_range(Nx2矩阵,关断时间区间)

%% 输入验证
validateattributes(Vin, {'numeric'}, {'vector', 'nonempty'});
validateattributes(time, {'numeric'}, {'vector', 'numel', numel(Vin)});



% % 目标时间区间
%     target_start_time = center_time - 1e-6; % 中心点时间前1μs
%     target_end_time = center_time + 1e-6;   % 中心点时间后1μs
%     % 找到最接近目标起点和终点的索引 [^2]
%     [~, start_index] = min(abs(t - target_start_time));
%     [~, end_index] = min(abs(t - target_end_time));
%     % 确保区间内至少包括中心点 [^6]
%     start_index = max(start_index, 1);
%     end_index = min(end_index, length(t));


% 计算中间参考值
v_max = max(Vin);
v_min = min(Vin);
mid_ref = (v_max + v_min) / 2;

% 找到所有穿过参考值的事件（上升或下降）
cross_up = Vin > mid_ref;
cross_events = find(diff(cross_up) ~= 0); % 这里的索引对应diff后的，即原数组的i和i+1的交界

% 获取第二次和第三次事件的中心索引
if length(cross_events) < 3
    error('未找到足够的交叉事件');
end
second_event_center = cross_events(2) + 1;% 因为diff的结果是i对应原数组i和i+1之间的变化，实际事件位置可以用i+1？
second_time_center = time(second_event_center);
third_event_center = cross_events(3) + 1;
third_time_center = time(third_event_center);

%确定时间区间
    off_target_start_time = second_time_center - 5e-7; % 中心点时间前1μs
    off_target_end_time = second_time_center + 5e-7;   % 中心点时间后1μs
    [~, off_start_index] = min(abs(time - off_target_start_time));
    [~, off_end_index] = min(abs(time - off_target_end_time));
    turn_off_range = [time(off_start_index), time(off_end_index)];

    on_target_start_time = third_time_center - 5e-7; % 中心点时间前1μs
    on_target_end_time = third_time_center + 5e-7;   % 中心点时间后1μs
    [~, on_start_index] = min(abs(time - on_target_start_time));
    [~, on_end_index] = min(abs(time - on_target_end_time));
    turn_on_range = [time(on_start_index), time(on_end_index)];

% % 确定时间区间
% turn_off_start = max(1, second_event_center - index_span_L);
% turn_off_end = min(length(t), second_event_center + index_span_R);
% turn_off_range = [t(turn_off_start), t(turn_off_end)];
% 
% turn_on_start = max(1, third_event_center - index_span_L);
% turn_on_end = min(length(t), third_event_center + index_span_R);
% turn_on_range = [t(turn_on_start), t(turn_on_end)];

%% 创建基础波形图
% figure;
% hold on;
% plot(time, Vin, 'k', 'LineWidth', 1.2); % 绘制原始信号[^1]
% %% 绘制关断区间
% rectangle('Position', [turn_off_range(1), min(Vin),...
%                       turn_off_range(2)-turn_off_range(1),...
%                       max(Vin)-min(Vin)],...
%           'FaceColor', [1 0.8 0.8], 'EdgeColor', 'none'); % 淡红色背景标注
% %% 绘制开通区间
% rectangle('Position', [turn_on_range(1), min(Vin),...
%                       turn_on_range(2)-turn_on_range(1),...
%                       max(Vin)-min(Vin)],...
%           'FaceColor', [0.8 1 0.8], 'EdgeColor', 'none'); % 淡绿色背景标注
% %% 图形标注优化
% title('开关区间可视化'); 
% xlabel('时间 (秒) [^5]');
% ylabel('电压 (V)');
% legend('Vin信号', '关断区间', '开通区间', ... 
%        'Location', 'best');
% grid on;
% hold off;
end

