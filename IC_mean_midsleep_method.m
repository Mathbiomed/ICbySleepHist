function IC = IC_mean_midsleep_method(start_day, end_day, onset_info, offset_info, work_series, work_type_for_midsleep, light_intensity, model_name, IC_of_IC) %% Please enter the work series as vector of natural number whole length is day number
    
    
    if model_name=="simpler"
        model=@simpler;
    elseif model_name=="higher"
        model=@kronaurJewett;
    elseif model_name=="nonphotic"
        model=@nonphotic;
    end

    sleep_vector = convert_sleep_vector(onset_info, offset_info, start_day, end_day);
    

    % Find the minimal point in the regular condition
    regular_unit = repmat(0, 1440, 1);
    regular_unit(1:361)=1;
    regular_unit(1321:1440)=1;
    sleep_regular = repmat(regular_unit, 50, 1);
    light_regular = light_intensity*(sleep_regular==0);
    tspan = ([1:1:length(light_regular)]-1)/60;
    [t0, y0] = ode15s(@(t,V) model(t, V, light_regular, tspan, 24.2), tspan, IC_of_IC);
    
    
    % Find the mean midsleep
    midsleep_series = find_midsleep(sleep_vector, work_series, work_type_for_midsleep);
    mean_mid_sleep = mean(midsleep_series(1:min(7, length(midsleep_series))));
    
    % Find initial condition
    one_period = y0(end-1439:end, :);
    [~, CBTmin] = min(one_period(:, 1));
    
    
    
    % Find initial condition
    if CBTmin-round(60*mean_mid_sleep+1)>0
        IC = one_period(CBTmin-round(60*mean_mid_sleep+1), :);
    else
        IC = one_period(CBTmin-round(60*mean_mid_sleep+1)+1440, :);
    end

    
    
end






function midsleep_vector = find_midsleep(sleep_series, work_series, work_type_for_midsleep)
    
    midsleep_cell = {};
    num_day = round(length(sleep_series)/1440);
    
    if num_day~=length(work_series)
        error('the length of work series and sleep data is different!')
    end

    sleep_info_mat = []; %1st_col = sleep in index, 2nd_col = wake ind, 3rd col = sleep time
    midsleep_vector = [];

    sleep_ind = find(diff(sleep_series)==1);
    wake_ind = find(diff(sleep_series)==-1);




    if sleep_series(1)==1
        wake_ind = wake_ind(2:end);
    end


    if sleep_series(end)==1
        sleep_ind = sleep_ind(1:end-1);
    end
    



    sleep_info_mat = [sleep_ind, wake_ind, wake_ind-sleep_ind];
    [col_num, ~] = size(sleep_info_mat);

    
    midsleep_cell{num_day}=[];


    for dd = 1:col_num
        
        dd_th_row = sleep_info_mat(dd, :);
        sleep_day = floor((dd_th_row(1)-1)/1440)+1;
        wake_day = floor((dd_th_row(2)-1)/1440)+1;

        midsleep_cell{sleep_day} = [midsleep_cell{sleep_day}; dd_th_row];

        if sleep_day ~= wake_day
            midsleep_cell{wake_day} = [midsleep_cell{wake_day}; dd_th_row];
        end
        
    end

    %% Find the day with maximal sleep length for each day

    for d = 1:num_day
        
       sleep_info_day = midsleep_cell{d};

       mod(sleep_info_day/60, 24);

       if ~isempty(midsleep_cell{d}) && ismember(work_series(d), work_type_for_midsleep)
       
           [~, max_ind] = max(sleep_info_day(:, 3));

           midsleep_vector = [midsleep_vector, (mod(sleep_info_day(max_ind, 1)+round(sleep_info_day(max_ind, 3)/2), 1440)-1)/60];

           if sleep_info_day(max_ind, 2)>1440*(d)
                [len_next_cell, ~] = size(midsleep_cell{d+1});
                if d>=1
                    midsleep_cell{d+1} = midsleep_cell{d+1}(2:end, :);
                %else
                    %midsleep_cell{d+1} = [];
                end
           end

       end
        

    end



end