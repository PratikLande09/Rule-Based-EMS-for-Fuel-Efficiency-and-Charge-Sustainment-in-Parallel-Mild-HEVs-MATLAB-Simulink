global T_MGB_th_ge_op;
global Q_BT_op;
global s_f;
global w_MGB_de_op
%T_MGB_th_ge_op_founded = inf;
v_min = inf;
%for T_MGB_th_ge_op =30:1:40
    for w_MGB_de_op = 200:10:400
        for s_f= 2:0.1:2.5
            sim('qss_hybrid_electric_vehicle_example')
            if V_CE_equiv(end) < v_min
                %T_MGB_th_ge_op_found = T_MGB_th_ge_op;
                w_MGB_de_op_foud = w_MGB_de_op;
                %Q_BT_op_found = Q_BT_op;
                %s_f_found=s_f;
                v_min = V_CE_equiv(end);
            end    
        end
       
    end
   
%end
v_min
%T_MGB_th_ge_op_found
%Q_BT_op_found
%s_f_found
w_MGB_de_op_foud