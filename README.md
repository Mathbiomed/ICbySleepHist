# Computational Package for Sleep History Estimation and Initial Condition Setting

We developed **ICbySleepHist** (**I**nitial **C**ondition Setting by **Sleep Hist**ory Estimation), a user-friendly MATLAB package for estimating sleep history and incorporating it as the initial condition for ODE-based circadian phase estimation. The package was developed in **MATLAB R2023b** and is available on **GitHub***.

Using input sleep information, ICbySleepHist estimates sleep history and then uses that history to set the initial condition for circadian phase estimation models. An example script is provided in **`main_example.m`**. The implementation steps are described below.

## 1. Download the package

Download the package from the code repository.

## 2. Prepare the input file

Save the sleep pattern information as a CSV file named **`sleep_pattern_info.csv`** in the same folder as the main script **`main_example.m`**.

* The **first column** should contain sleep onset times.
* The **second column** should contain sleep offset times.

## 3. Run the example script

Open **`main_example.m`**, which includes example code for estimating the initial condition using four methods:

* **Regular sleep method** (line 3)
* **Mean midsleep method** (line 15)
* **Period-based sleep method** (line 18)
* **Work history-based method** (line 21)

Details for each method are provided below.

### 3.1 Regular sleep method

To estimate the initial condition using the regular sleep method, use the function **`IC_regular_sleep_method`** as shown on line 3 of **`main_example.m`**.

This function takes five inputs:

* **`sleep_start_time`**: sleep onset time under a constant sleep schedule
* **`sleep_end_time`**: sleep offset time under a constant sleep schedule
* **`light_intensity`**: positive numerical value representing light intensity during wakefulness
* **`model_name`**: type of mathematical model to use; must be one of:

  * `"simpler"`
  * `"higher"`
  * `"nonphotic"`
* **`IC_of_IC`**: initial condition used for simulating the mathematical model while estimating sleep history

For example, if the constant sleep schedule is **23:30–07:30**, the wake light intensity is **250 lux**, and the simulation uses the **simpler** model with initial condition **`[1 0.5 -0.3]`**, then the function call is:

`IC_regular_sleep_method("23:30", "7:30", 250, "simpler", [1 0.5 -0.3])`

### 3.2 Mean midsleep method

To estimate the initial condition using the mean midsleep method, use the function **`IC_mean_midsleep_method`** as shown in **`main_example.m`**.

This function takes nine inputs:

* **`start_day`**: starting date of the sleep data
* **`end_day`**: ending date of the sleep data
* **`onset_info`**: sleep onset times in the sleep data
* **`offset_info`**: sleep offset times in the sleep data
* **`work_series`**: vector of daily work schedules, where the first entry corresponds to `start_day` and the last entry corresponds to `end_day`
* **`work_type_for_midsleep`**: vector of work schedule types to include when calculating mean midsleep
* **`light_intensity`**: light intensity during wakefulness
* **`model_name`**: model type
* **`IC_of_IC`**: initial condition used during simulation

The meanings of **`light_intensity`**, **`model_name`**, and **`IC_of_IC`** are the same as in **`IC_regular_sleep_method`**.

### 3.3 Period-based sleep method

To estimate the initial condition using the period-based sleep method, use the function **`IC_period_based_sleep_method`** as shown in **`main_example.m`**.

This function takes nine inputs:

* **`start_day`**: starting date of the sleep data
* **`end_day`**: ending date of the sleep data
* **`onset_info`**: sleep onset times in the sleep data
* **`offset_info`**: sleep offset times in the sleep data
* **`work_series`**: vector of daily work schedules
* **`maximal_lasting_consecutive_days`**: maximum number of consecutive days for a sustained shift pattern
* **`light_intensity`**: light intensity during wakefulness
* **`model_name`**: model type
* **`IC_of_IC`**: initial condition used during simulation

The meanings of **`start_day`**, **`end_day`**, **`onset_info`**, **`offset_info`**, **`work_series`**, **`light_intensity`**, **`model_name`**, and **`IC_of_IC`** are the same as in **`IC_mean_midsleep_method`**.

### 3.4 Work history-based method

To estimate the initial condition using the work history-based method, use the function **`IC_work_history_based_sleep_method`**.

This function takes nine inputs:

* **`start_day`**: starting date of the sleep data
* **`end_day`**: ending date of the sleep data
* **`onset_info`**: sleep onset times in the sleep data
* **`offset_info`**: sleep offset times in the sleep data
* **`work_series`**: vector of daily work schedules
* **`work_history`**: historical work schedule information
* **`light_intensity`**: light intensity during wakefulness
* **`model_name`**: model type
* **`IC_of_IC`**: initial condition used during simulation

The variable **`work_history`** represents the historical work schedule. All other inputs are the same as those in **`IC_period_based_sleep_method`**.

---

원하시면 제가 이걸 이어서 **GitHub README 형식**에 맞게
`Overview / Requirements / Input format / Example / Functions / Notes` 구조로 더 깔끔하게 재정리해드릴게요.
