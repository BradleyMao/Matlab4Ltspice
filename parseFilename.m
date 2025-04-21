function settings = parseFilename(filename)
    % Define the pattern for the filename using regular expressions
    pattern = '(\w+)_Ron(\d{3})_Roff(\d{3})_Von(\d{3})_Voff(\d{3})_ID(\d{3})_VD(\d{4})\.raw';
    
    % Use the regexp function to match the pattern
    tokens = regexp(filename, pattern, 'tokens');
    
    % Check if the pattern matched
    if isempty(tokens)
    error('文件名格式错误：%s\n需要的格式示例：QingChun4pin_Ron100_Roff100_Von150_Voff040_ID040_VD0750.raw', filename);
    end
    
    % Extract the information from the tokens
    tokens = tokens{1}; % Get the first (and only) match

    setting_info = struct();
    setting_info.project_name = tokens{1};
    setting_info.Ron = str2double(tokens{2}) / 10;   % Convert to double and divide by 10
    setting_info.Roff = str2double(tokens{3}) / 10;  % Convert to double and divide by 10
    setting_info.Von = str2double(tokens{4}) / 10;   % Convert to double and divide by 10
    setting_info.Voff = str2double(tokens{5}) / 10;  % Convert to double and divide by 10
    setting_info.ID = str2double(tokens{6});
    setting_info.VD = str2double(tokens{7});

    settings = setting_info;
    
    %% Print the extracted information
    % fprintf('Project Name: %s\n', setting_info.project_name);
    % fprintf('Ron: %.1f ohm\n', setting_info.Ron);
    % fprintf('Roff: %.1f ohm\n', setting_info.Roff);
    % fprintf('Von: %.1f V\n', setting_info.Von);
    % fprintf('Voff: %.1f V\n', setting_info.Voff);
    % fprintf('ID: %.0f A\n', setting_info.ID);
    % fprintf('VD: %.0f V\n', setting_info.VD);
end


