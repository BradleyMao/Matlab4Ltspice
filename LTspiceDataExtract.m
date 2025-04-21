function DPT_data = LTspiceDataExtract(raw_filename)
% DPT_data abstract
% Get DPT_data by ltspice2matlab.m
%The name of netlist must be strictly same as the sample spice_.asc
%   
    % Step 1: 读取原始数据(处理多步仿真数据)
    raw_data = LTspice2Matlab(raw_filename); % 加载全部变量 
    
    % 处理多个仿步数据 [^4][^6]
    if raw_data.num_steps > 1
        mat_size = size(raw_data.variable_mat);
        raw_data.variable_mat = reshape(raw_data.variable_mat, [mat_size(1), mat_size(2)/raw_data.num_steps, raw_data.num_steps]);
        raw_data.time_vect = reshape(raw_data.time_vect, [mat_size(2)/raw_data.num_steps, raw_data.num_steps]).';
    end
    raw_data.variable_name_list = lower(raw_data.variable_name_list);

    % Step 2: 建立原始变量映射（根据RAW文件实际变量名调整）
    var_map = {
        'v(vd_h)', 'Vd_H';  
        'v(vs_h)', 'Vs_H';
        'v(vg_h)', 'Vg_H'; 
        'v(vks_h)','Vks_H';
        'i(ig_h)','Ig_H';
        'i(id_h)','Id_H';

        'v(vd_l)', 'Vd_L'; 
        'v(vs_l)', 'Vs_L'; 
        'v(vg_l)', 'Vg_L';
        'v(vks_l)','Vks_L';
        'i(ig_l)','Ig_L';
        'i(id_l)','Id_L';

        'v(vin_p)','V_in_p';
        'v(vin_n)','V_in_n';
    };

    signal_data = struct();
    for i = 1:size(var_map,1)
        idx = find(strcmp(raw_data.variable_name_list, var_map{i,1}));
        signal_data.(var_map{i,2}) = squeeze(raw_data.variable_mat(idx,:,:)); % 兼容多步数据 [^2]
    end

    % Step 3: 计算派生参数
    dpt_vars = struct();
    dpt_vars.Vds_H = signal_data.Vd_H - signal_data.Vs_H; 
    dpt_vars.Vgs_H = signal_data.Vg_H - signal_data.Vks_H;
    dpt_vars.Id_H  = signal_data.Id_H; 
    dpt_vars.Ig_H  = signal_data.Ig_H;

    dpt_vars.Vds_L = signal_data.Vd_L - signal_data.Vs_L;
    dpt_vars.Vgs_L = signal_data.Vg_L - signal_data.Vks_L;
    dpt_vars.Id_L  = signal_data.Id_L;
    dpt_vars.Ig_L  = signal_data.Ig_L;

    dpt_vars.Vin   = signal_data.V_in_p - signal_data.V_in_n;
    %时间坐标
    dpt_vars.time      = raw_data.time_vect;
    DPT_data = dpt_vars;
%     %Step 4: 绘制波形(以单步仿真为例)
%     figure('Name','DPT Variables Analysis');
%     plot_signals(raw_data.time_vect, dpt_vars); % 时间向量取第一列 [^1]
% 
% function plot_signals(t, data)
%     fields = fieldnames(data);
%     for i = 1:numel(fields)
%         subplot(5,2,i);
%         plot(t, data.(fields{i}));
%         title(strrep(fields{i},'_','\_')); % 转义下划线
%         xlabel('Time (s)'); 
%         grid on;
%     end
% end

end

