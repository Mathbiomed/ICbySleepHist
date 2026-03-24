function IC = IC_period_based_sleep_method(start_day, end_day, onset_info, offset_info, work_series, maximal_lasting_consecutive_days, light_intensity, model_name, IC_of_IC) %% Please enter the work series as vector of natural number whole length is day number
    


    if model_name=="simpler"
        model=@simpler;
    elseif model_name=="higher"
        model=@kronaurJewett;
    elseif model_name=="nonphotic"
        model=@nonphotic;
    end



    sleep_vector = convert_sleep_vector(onset_info, offset_info, start_day, end_day);

    % Determine the day for repetition
    
    first_work = work_series(1);
    first_sleep = sleep_vector(1:1440);
    day = round(length(sleep_vector)/1440);

    candidate_day_same_day = []; % 1st coulmn day & 2nd column = sleep error

    non_equal_work = []; % 1st coulmn day & 2nd column = sleep error
    
    if day>maximal_lasting_consecutive_days
        start=maximal_lasting_consecutive_days;
        
    else
        start=2;
    
    end
    
    
    for dd=start:day

    
        sleep_day = sleep_vector((1440*(dd-1))+1:1440*dd);
    
        if work_series(dd)==first_work
            candidate_day_same_day = [candidate_day_same_day; [dd, sum(abs(first_sleep-sleep_day))]];
    
        else
            non_equal_work = [non_equal_work; [dd, sum(abs(first_sleep-sleep_day))]];
        end
    
    
    end
    



    if ~isempty(candidate_day_same_day)
        
        [~, min_ind] = min(candidate_day_same_day(:, 2));
        candidate_d = candidate_day_same_day(:, 1);
        ans_d = candidate_d(min_ind)-1;
    else


        [~, min_ind] = min(non_equal_work(:, 2));
        candidate_d = non_equal_work(:, 1);
        ans_d = candidate_d(min_ind)-1;
    
    end

    % generate light for simulation
    repeat_unit = sleep_vector(1:1440*ans_d);
    light_unit = light_intensity*(repeat_unit==0);
    
    
    repeat_times =  round(300/ans_d)+1;
    light_repeat = repmat(light_unit, repeat_times, 1);
    %Simulation
    tspan = ([1:1:length(light_repeat)]-1)/60;
    [t0, y0] = ode15s(@(t,V) model(t, V, light_repeat, tspan, 24.2), tspan, IC_of_IC);

    % Find the appropriate initial condition
    IC = y0(end-1, :);
 
    
end





