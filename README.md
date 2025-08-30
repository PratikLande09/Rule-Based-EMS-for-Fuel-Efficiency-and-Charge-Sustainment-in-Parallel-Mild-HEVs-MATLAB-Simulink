# Parallel Mild HEV — Rule-Based EMS in MATLAB/Simulink (QSS)

This project implements a **rule-based Energy Management System (EMS)** for a **parallel mild hybrid electric vehicle (HEV) using MATLAB/Simulink with a Quasi-Static Simulation (QSS) approach. It includes the Simulink vehicle model, MATLAB code for the controller and a lightweight optimizer, run/plot scripts, and **PNG figures** (controller design + results)..


## 1) What this project does

- Goal: Minimize fuel consumption on standard cycles (NEDC, FTP-75) while **sustaining battery charge** and respecting component limits (motor/gearbox torque, battery bounds).
- Approach: A rule-based controller computes a torque-split command `u` that decides how the engine (ICE) and electric motor (EM) share drive/brake torque.
- **Validation:** Simulation on NEDC and FTP-75 with figures such as **battery charge vs. time** and mode timelines.


## 2) How it works (high-level)

Operating modes (selected by simple rules with thresholds/hysteresis):
- Regenerative braking: `T_MGB < 0` → EM generates (negative `u`) within capability.
- Electric drive (low load): EM alone if it can meet demand and SOC is healthy.
- Load-Point Shifting (LPS): EM assists ICE at higher torque to keep ICE near efficient regions (cap share with `u_LPS_max`).
- Generative LPS: Slight negative `u` at adequate speeds/loads to **charge** while ICE provides wheel torque.
- ICE-only fallback when constraints or SOC require it.

The controller uses inputs like gearbox speed `w_MGB`, acceleration `dw_MGB`, demanded torque `T_MGB`, and battery charge proxy `Q_BT`, plus an **EM map** (max torque vs. speed).


## 3) Repository layout

model/      qss_hybrid_electric_vehicle_example.mdl
controller/ controller1.m, 
optimizer/  optimalizer[1].m


## 4) Requirements

- MATLAB + Simulink (R2022b+ recommended)  
- QSS toolbox on the MATLAB path  
- (Optional) Optimization Toolbox if you extend the search strategy

Add paths once per session:
matlab
addpath('controller','optimalizer','scripts','model');


## 5) Quick start

1. Open the model:
   matlab
   open('model/qss_hybrid_electric_vehicle_example.mdl');
   
2. Run a cycle:
   matlab
   run('scripts/run_nedc.m');   % or: run('scripts/run_ftp75.m')
   
3. Plot (if signals are logged in `logsout` as expected):
   matlab
   plot_results(ans);   % 'ans' is SimulationOutput; or pass your variable
   

## 6) Controller & parameters

Primary entry point:
matlab
u = controller_logic(w_MGB, dw_MGB, T_MGB, Q_BT, params, maps);

- `controller_params.m` holds thresholds like `low_Q_BT`, `High_Q_BT`, `T_MGB_th`, `u_LPS_max`, `T_MGB_th_ge`, `w_MGB_de`, etc.  
- Tune these to your vehicle & EM map; add hysteresis where needed to avoid chattering.


## 7) Optimizer (simple sweep)

Use `opimalizer[1].m` to scan threshold ranges and pick the best set against a **fuel-equivalent cost** (you decide which signal represents cost—e.g., `V_CE_equiv(end)`).

matlab
p0 = controller_params();
ranges.T_MGB_th_ge = 30:1:40;
ranges.w_MGB_de    = 200:10:400;
ranges.s_f         = 2.0:0.1:2.5;

best = optimizer(p0, ranges, 'NEDC');   % or 'FTP75'
best.params;   % tuned parameters
best.score;    % lower is better
best.trace;    % table of tried combos & scores

## 8) #Results 

Fuel consumption comparison (lower is better):

| Driving Cycle | ICE [L/100 km] | HEV [L/100 km]  | Diff[%]|
|---------------|-----------------|----------------|--------|
| NEDC          | 4.929           | 3.716          | 24.6%  |
| FTP‑75        | 4.72            | 3.53           | 25.2%  |

These results illustrate the gains from hybridization with the rule‑based EMS on standardized cycles.

Author:
Erfan Mousavi, Pratik Lande

lil09heq@rhrk.uni-kl.de
