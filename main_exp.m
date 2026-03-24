%% Test matlab code time

IC1 = IC_regular_sleep_method("23:30", "7:30", 250, "simpler", [1 0.5 -0.3]); % IC calculation with the regular sleep method


I = readtable("sleep_pattern_info.xlsx");


onset = datetime(I.sleep_onset);
offset = datetime(I.sleep_offset);

work_pattern = ["Off" "Off" "first Night" "non first Night" "non first Night" "Off after night" "Off" "Off" "Day" "Day"];


IC2 = IC_mean_midsleep_method("2024-03-04", "2024-03-13", onset, offset, work_pattern, ["Off" "Day" "Evening" "first Night"], 250, "simpler", [1 0.5 -0.3]); % IC calculation with the mean midsleep sleep method


IC3 = IC_period_based_sleep_method("2024-03-04", "2024-03-13", onset, offset, work_pattern, 3, 250, "simpler", [1 0.5 -0.3]); % IC calculation with the period-based sleep sleep method


IC4 = IC_work_history_based_sleep_method("2024-03-04", "2024-03-13", onset, offset, work_pattern, ["Night" "non first Night" "non first Night" "Off" "Off" "Day" "Day"], 250, "simpler", [1 0.5 -0.3]); % IC calculation with the work history-based sleep method
