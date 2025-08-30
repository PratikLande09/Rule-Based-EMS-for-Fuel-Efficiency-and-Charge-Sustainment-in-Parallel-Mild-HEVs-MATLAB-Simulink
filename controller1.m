function u = controller1(input)
w_MGB = input(1);
dw_MGB = input(2); 
T_MGB = input(3); % get inputs
Q_BT = input(4);
%v = input(5);
%ddv = input(6);
global w_EM_max;
global T_EM_max; % define global variables
global T_MGB_th_ge_op;
global s_f;
global Q_BT_op;
global w_MGB_de_op
low_Q_BT = 5000;
High_Q_BT = 18800;
theta_EM = 0.1; % define motor inertia
T_MGB_th = 60; % define torque threshold for NEDC (cf. 3-8)
%T_MGB_th = 39.5; % define torque threshold for FTP-75 (cf. 3-8)
epsilon = 0.01; % define epsilon (cf. 3-8/3-10)
u_LPS_max = 0.3; % define max. torque-split factor for LPS (3-8)
T_MGB_th_ge = 38;
w_MGB_de= 300;


if T_MGB < 0 % regeneration 
    u = min((interp1(w_EM_max,-T_EM_max,w_MGB)+abs(theta_EM*dw_MGB)+epsilon)/T_MGB,1);
elseif T_MGB == 0
    u = 0;
elseif T_MGB >= T_MGB_th && Q_BT > low_Q_BT % load point shifting 
    u = min((interp1(w_EM_max,T_EM_max,w_MGB)-abs(theta_EM*dw_MGB)-epsilon)/T_MGB,u_LPS_max);
elseif  T_MGB > T_MGB_th_ge && Q_BT < High_Q_BT % load point shifting (generator)
    u = -min((interp1(w_EM_max,T_EM_max,w_MGB)-abs(theta_EM*dw_MGB)-epsilon)/T_MGB,u_LPS_max);
elseif (interp1(w_EM_max,T_EM_max,w_MGB)-abs(theta_EM*dw_MGB)-epsilon) >= (2.1*T_MGB) && Q_BT > 4200 && w_MGB < w_MGB_de % the motor tourqe is able to move the car
    u = 1;
                     
else                 % engine only
    u = 0;
end