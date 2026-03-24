function IC = IC_work_history_based_sleep_method(start_day, end_day, onset_info, offset_info, work_series, work_history, light_intensity, model_name, IC_of_IC) %% Please enter the work series as vector of natural number whole length is day number


    if model_name=="simpler"
        model=@simpler;
    elseif model_name=="higher"
        model=@kronaurJewett;
    elseif model_name=="nonphotic"
        model=@nonphotic;
    end

    
    % convert sleep data to sleep vector
    sleep_vector = convert_sleep_vector(onset_info, offset_info, start_day, end_day);

    
    % Produce work_type_set
    work_tp = [];

    
    % matching the average sleep to work history
    estimated_sleep_work_cell = {};

    for W = 1:length(work_history)
        if isempty(work_tp) || (~ismember(work_history(W), work_tp))
            work_tp = [work_tp, work_history(W)];
        end
    end
    
    

    for t = 1:length(work_tp)
        sleep_collection = []; % sleep collection = 1440 by n matrix
        same_work_ind = find(work_series==work_tp(t));
        
        for L = 1:length(same_work_ind)
            same_ind = same_work_ind(L);
            sleep_collection = [sleep_collection, sleep_vector(1440*(same_ind-1)+1:1440*same_ind)];

        end


        estimated_sleep_work_cell{t}=best_sleep_estimated_with_plot(sleep_collection, 1);

        %figure(work_tp+1)
        %plot([1:1:1440], estimated_sleep_work_cell{work_tp+1})
        
    end
    
    % Estimate the sleep in the last week
    sleep_in_last_week = [];
    for wwi = 1:length(work_history)
        ww = work_history(wwi);
        sleep_in_last_week = [sleep_in_last_week; estimated_sleep_work_cell{find(work_tp==ww)}];
    
    end
    
    
    
    % Obtain the initial condition from the simulation
    repeat_unit = sleep_in_last_week;
    light_unit = light_intensity*(repeat_unit==0);
    
    
    repeat_times =  round(300/7)+1;
    light_repeat = repmat(light_unit, repeat_times, 1);

    %Simulation
    tspan = ([1:1:length(light_repeat)]-1)/60;
    [t0, y0] = ode15s(@(t,V) model(t, V, light_repeat, tspan, 24.2), tspan, IC_of_IC);

    % Find the appropriate initial condition
    IC = y0(end-1, :);

end




function Ans = sum_sleep(m) % each col = sleep in a day

    [~, a] = size(m);
    Ans = zeros(1440, 1);
        
    for col = 1:a

        Ans = Ans + m(:, col);
    end
end



function core_value = find_core_sleep_index(sleep_sum_matrix) %Please put 1440 by 1 vector
    max_sleep = max(sleep_sum_matrix);
    max_index = find(sleep_sum_matrix == max_sleep);

    if length(max_index)==1
        core_value = max_index;

    elseif mod(length(max_index), 2)==1
        core_value = max_index((length(max_index)-1)/2+1);

    else
        core_value =  max_index(length(max_index)/2);


    end
    
end



function thresh = find_sleep_approximate_threshold(sleep_sum, sleep_time) % put sleep sum as 1440 by 1 vector
        
    lower_bound = max(sleep_sum);
    
    while length(find(sleep_sum >= lower_bound))/length(sleep_sum) < sleep_time/24

        lower_bound = lower_bound-0.001;
    end

    thresh = lower_bound;
end




function ran_col = select_random_col(M)

    [~, c] =size(M);
    if c>0
        ran_col= M(:, randi([1 c], 1));

    else
        ran_col = [];

    end

end

function info = best_sleep_estimated_with_plot(sleep_info, plot_number)
    size(sleep_info);
    [~, b] = size(sleep_info);
    sleep_time_set = [];
    for col = 1:b
        sleep_time_set = [sleep_time_set, length(find(sleep_info(:, col)==1))/60];
    end
    
    sleep_time = mean(sleep_time_set);

    sum_sleep_info = sum_sleep(sleep_info);

    if length(sum_sleep_info)>0 && max(sum_sleep_info)>=-1
        sum_sleep_info = smooth(sum_sleep_info, 80);
        threshold_sleep_approx = find_sleep_approximate_threshold(sum_sleep_info, sleep_time);
        info = zeros(1440, 1);
        info(find(sum_sleep_info<=threshold_sleep_approx))=0;
        info(find(sum_sleep_info>threshold_sleep_approx))=1;

    elseif length(sum_sleep_info)>0 && max(sum_sleep_info)<-1
        info = select_random_col(sleep_info);

    else
        info = sum_sleep_info;

    end
    


end