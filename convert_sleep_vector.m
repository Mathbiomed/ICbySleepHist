function sleep_vector = convert_sleep_vector(onset_info, offset_info, start_day, end_day)
    
    
    
    sleep_length = minutes(datetime(end_day)-datetime(start_day))+1440;
    
    
    onset_ind = [];
    offset_ind = [];
    
    
    for i = 1:length(onset_info)
        
        onset_ind = [onset_ind, minutes(datetime(onset_info(i))-datetime(start_day))];
        
    end
    
    for i = 1:length(offset_info)
        
        offset_ind = [offset_ind, minutes(datetime(offset_info(i))-datetime(start_day))];
        
    end
    
    if min(onset_ind)>min(offset_ind)
        sleep_vector = ones(sleep_length, 1);
    else
        sleep_vector = zeros(sleep_length, 1);
    end
    
    
    while ~isempty(onset_ind) || ~isempty(offset_ind)
            
        if ~isempty(onset_ind) && ~isempty(offset_ind)  
            
            [on_min, on_min_ind] = min(onset_ind);
            [off_min, off_min_ind] = min(offset_ind);
            
            if on_min<off_min
                sleep_vector(on_min:end)=1;
                onset_ind = removing_entry_from_vector(onset_ind, on_min_ind);
            else
                sleep_vector(off_min:end)=0;
                offset_ind = removing_entry_from_vector(offset_ind, off_min_ind);
            end
            
        elseif ~isempty(onset_ind)
            
            [on_min, on_min_ind] = min(onset_ind);
            sleep_vector(on_min:end)=1;
            onset_ind = removing_entry_from_vector(onset_ind, on_min_ind);
            
        else
            
            [off_min, off_min_ind] = min(offset_ind);
            sleep_vector(off_min:end)=0;
            offset_ind = removing_entry_from_vector(offset_ind, off_min_ind);
    
        end
        
            
    end
end



function eliminated_vector = removing_entry_from_vector(original_vector, remove_ind)

    if 1<remove_ind && remove_ind<length(original_vector)
        eliminated_vector = [original_vector(1:remove_ind-1), original_vector(remove_ind+1:end)];

    elseif 1==remove_ind && length(original_vector)>=2
        eliminated_vector = original_vector(2:end);

    elseif 1==remove_ind && length(original_vector)==1
        eliminated_vector = [];

    elseif remove_ind == length(original_vector) && length(original_vector)>1
        eliminated_vector = original_vector(1:end-1);

    end

end

