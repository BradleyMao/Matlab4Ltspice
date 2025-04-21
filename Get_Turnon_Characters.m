function turn_on = Get_Turnon_Characters(turn_on_range,DPT_data,DPT_settings)
%GET_TURNON_CHARACTERS 此处显示有关此函数的摘要
%   turn_on_range:turn_on_range[time(t_start,t_end];
%   DPT_data: a stuct data: including: 
%                   Vin,time,Vgs_H,Id_H,,Vds_L,Vgs_L,Id_L
%   DPT_Settings: a struct data, including:
%                   Von,Voff,ID,VD;
% Find indices corresponding to the turn-on range
    start_index = find(DPT_data.time >= turn_on_range(1), 1);
    end_index = find(DPT_data.time <= turn_on_range(2), 1, 'last');
    % Select the data within the turn-on range
    %Vin = DPT_data.Vin(start_index:end_index);
    time = DPT_data.time(start_index:end_index);
    %Vds_H = DPT_data.Vds_H(start_index:end_index);
    Vgs_H = DPT_data.Vgs_H(start_index:end_index);
    Id_H = DPT_data.Id_H(start_index:end_index);

    Vds_L = DPT_data.Vds_L(start_index:end_index);
    Vgs_L = DPT_data.Vgs_L(start_index:end_index);
    Id_L = DPT_data.Id_L(start_index:end_index);

    Von = DPT_settings.Von;
    Voff = DPT_settings.Voff;
    ID = DPT_settings.ID;
    VD = DPT_settings.VD;

    %% 1. 计算开通损耗（积分法）
    % 找到Id_L上升至10%的起始点
    id_target = 0.1 * max(ID);
    start_idx = find(Id_L >= id_target, 1, 'first'); % 首次达到10%的索引
    % 找到Vds_L下降至Vd的10%的结束点
    vds_target = 0.1 * VD;
    end_idx = find(Vds_L <= vds_target, 1, 'first'); % 首次下降到10%的索引
    % 积分计算开通损耗
    integrand = Id_L(start_idx:end_idx) .* Vds_L(start_idx:end_idx);
    Eon = trapz(time(start_idx:end_idx), integrand); % 梯形积分法

    %% 2. 计算开通时间
    vgs_threshold = 0.1 * (Von-Voff);
    start_on = find(Vgs_L >= vgs_threshold, 1, 'first');
    T_on = time(end_idx) - time(start_on); % [start_on, end_idx]时间差[^3]
    %% 3. 计算下降时间和slew rate（Vds电压斜率）
    vds_high = 0.9 * VD;
    vds_low = 0.1 * VD;
    % 找90%下降起点和10%终点
    t_high = interp1(Vds_L, time, vds_high, 'linear', 'extrap');
    t_low = interp1(Vds_L, time, vds_low, 'linear', 'extrap');
    T_fall = t_low - t_high; %
    dvdt_on = 0.8 * VD / T_fall;

    %% 4. 反向恢复特性分析
    I_peak = max(Id_H);
    % 找首次过零点后第二次衰减至10%峰值的时刻
    start_rr = find(diff(sign(Id_H)) > 0); % 正到负的过零点
    if ~isempty(start_rr)
    start_rr =  start_rr(1);
    end
    zero_crossings = find(diff(sign(Id_H)) < 0); % 正到负的过零点
    if ~isempty(zero_crossings)
    start_zero = zero_crossings(1);
    threshold = 0.1 * I_peak;
    
    % 找第一次低于阈值的时刻
    end_rr = find(Id_H(start_zero:end) <= threshold, 1, 'first') + start_zero;
    T_rr = time(end_rr) - time(start_rr);
    Q_rr = trapz(time(start_rr:end_rr), Id_H(start_rr:end_rr)); % 梯形积分法
    else
    T_rr = NaN;
    warning('未检测到有效的反向恢复波形');
    end
    %% 4.Crosstalk
    Vcrosstalk_max = max(Vgs_H);
    
    turn_on = struct();
    turn_on.Eon = Eon;
    turn_on.T_on = T_on;
    turn_on.dvdt_on = dvdt_on;
    turn_on.Vcrosstalk_max = Vcrosstalk_max;
    turn_on.I_peak = I_peak;
    turn_on.Trr = T_rr;
    turn_on.Qrr = Q_rr;


    % %% 创建基础波形图
    % figure;
    % hold on;
    % % 切换到左y轴
    % yyaxis left
    % plot(time, Vds_L, 'b-'); % 蓝色线
    % ylim([-200 1200]); % 设置左y轴范围
    % % 切换到右y轴
    % yyaxis right
    % plot(time, Id_H, 'r-'); % 红色虚线
    % 
    % line([time(start_rr) time(start_rr)], ylim, 'Color', 'r', 'LineWidth', 1);
    % line([time(end_rr) time(end_rr)], ylim, 'Color', 'g', 'LineWidth', 1);
    % grid on;
    % hold off;
end

