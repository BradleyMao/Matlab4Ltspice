function turn_off = Get_Turnoff_Characters(turn_off_range,DPT_data,DPT_settings)
%GET_TURNON_CHARACTERS 此处显示有关此函数的摘要
%   turn_on_range:turn_on_range[time(t_start,t_end];
%   DPT_data: a stuct data: including: 
%                   Vin,time,Vgs_H,Id_H,,Vds_L,Vgs_L,Id_L
%   DPT_Settings: a struct data, including:
%                   Von,Voff,ID,VD;
% Find indices corresponding to the turn-on range
    start_index = find(DPT_data.time >= turn_off_range(1), 1);
    end_index = find(DPT_data.time <= turn_off_range(2), 1, 'last');
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

    idx_vds_10 = find(Vds_L >= 0.1 * VD, 1,"first"); % Vds达到10%Vd的起始点 
    idx_id_10 = find(Id_L <= 0.1 * ID, 1,"first"); % Id下降到10%的最大值点 
    idx_vgs_90von = find(Vgs_L <= 0.9 * Von, 1); % Vgs下降到90%Von的起始点 
    idx_vds_90vd = find(Vds_L >= 0.9 * VD, 1); % Vds上升到90%Vd的终点 
    idx_vds_90 = find(Vds_L >= 0.9 * VD, 1); 
    idx_vds_10_start = find(Vds_L >= 0.1 * VD, 1); 
    % 1. 关断损耗计算
    Eoff = trapz(time(idx_vds_10:idx_id_10), Id_L(idx_vds_10:idx_id_10) .* Vds_L(idx_vds_10:idx_id_10));
    % 2. 关断时间计算
    T_off = time(idx_vds_90vd) - time(idx_vgs_90von);
    % 3. 上升时间计算
    T_rise = time(idx_vds_90) - time(idx_vds_10_start);
    dvdt_off = 0.8 * VD /T_rise;
    % 4.crosstalk
    Vcrosstalk_min = min(Vgs_H);
    % 4.Vos
    Vos = max(Vds_L);

    turn_off = struct();
    turn_off.Eoff = Eoff;
    turn_off.T_off = T_off;
    turn_off.dvdt_off = dvdt_off;
    turn_off.Vcrosstalk_min = Vcrosstalk_min;
    turn_off.Vos = Vos;






    %     %% 创建基础波形图
    % figure;
    % hold on;
    % % 切换到左y轴
    % yyaxis left
    % plot(time, Vds_L, 'b-'); % 蓝色线
    % ylim([-200 1200]); % 设置左y轴范围
    % % 切换到右y轴
    % yyaxis right
    % plot(time, Vgs_L, 'r-'); % 红色虚线
    % 
    % line([time(idx_vds_90vd) time(idx_vds_90vd)], ylim, 'Color', 'r', 'LineWidth', 1);
    % line([time(idx_vgs_90von)  time(idx_vgs_90von)], ylim, 'Color', 'g', 'LineWidth', 1);
    % grid on;
    % hold off;
end

