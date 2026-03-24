function IC = IC_regular_sleep_method(sleep_start_time, sleep_end_time, light_intensity, model_name, IC_of_IC)
    


    if model_name=="simpler"
        model=@simpler;
    elseif model_name=="higher"
        model=@kronaurJewett;
    elseif model_name=="nonphotic"
        model=@nonphotic;
    end
    
    %% Sleep start end index calculation
    
    sleep_start_duration = duration(sleep_start_time, "Format","hh:mm");
    sleep_start_ind = 60*hours(sleep_start_duration)+minutes((sleep_start_duration));
    
    
    sleep_end_duration = duration(sleep_end_time, "Format","hh:mm");
    sleep_end_ind = 60*hours(sleep_end_duration)+minutes((sleep_end_duration));
    
    
    if sleep_end_ind==0
        sleep_end_ind=1440;
    end
    
    
    if sleep_start_ind==0
        sleep_start_ind=1440;
    end
    
    
    %% Generate the unit of regular sleep
    if sleep_end_ind >= sleep_start_ind
        sleep_unit = zeros(1440, 1);
        sleep_unit(sleep_start_ind:sleep_end_ind)=1;
    
    else
        sleep_unit = zeros(1440, 1);
        sleep_unit(1:sleep_end_ind)=1;
        sleep_unit(sleep_start_ind:1440)=1;
    
    end
    
    
    % generate light for simulation
    repeat_unit = sleep_unit;
    light_unit = light_intensity*(repeat_unit==0);
    
    
    repeat_times = 30;
    light_repeat = repmat(light_unit, repeat_times, 1);

    %Simulation
    tspan = ([1:1:length(light_repeat)]-1)/60;
    [t0, y0] = ode15s(@(t,V) model(t, V, light_repeat, tspan, 24.2), tspan, IC_of_IC);

    % Find the appropriate initial condition
    IC = y0(end-1, :);
 
    
end
