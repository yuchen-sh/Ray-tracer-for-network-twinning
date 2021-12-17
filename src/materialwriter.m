function [wall, floor, obstacles] = materialwriter(numobs)
dir = pwd;
idcs = strfind(dir,'/');
qd_directory = dir(1:idcs(end)-1);
file_name = qd_directory + "/src/material_libraries/matLib.csv";
wall_floor_option = [5 , 15, 25];
wall = wall_floor_option(randi(3));
floor = wall_floor_option(randi(3));
obs_mat = rand(numobs);
obstacles = 29.5 * obs_mat(1,:) + .5;
line1 = "Reflector,n_Precursor,n_Postcursor,s_K_Precursor,sigma_K_Precursor,s_K_Postcursor,sigma_K_Postcursor,s_gamma_Precursor,sigma_gamma_Precursor,s_gamma_Postcursor,sigma_gamma_Postcursor,s_sigmaS_Precursor,sigma_sigmaS_Precursor,s_sigmaS_Postcursor,sigma_sigmaS_Postcursor,s_lambda_Precursor,sigma_lambda_Precursor,s_lambda_Postcursor,sigma_lambda_Postcursor,s_sigmaAlphaAz,sigma_sigmaAlphaAz,s_sigmaAlphaEl,sigma_sigmaAlphaEl,s_RL,sigma_RL,mu_RL\n";
fID = fopen(file_name,'w');
fprintf(fID,line1);
ceiling_line = "ceiling,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15.29\n";
fprintf(fID,ceiling_line);
wall_line = "wall,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,%d\n";
fprintf(fID,wall_line,wall);
floor_line = "floor,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,%d\n";
fprintf(fID,floor_line,floor);
for iter = 1:numobs
    obs_string = sprintf("obstacle-%d",iter);
    obs_line = "%s,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,%f\n";
    fprintf(fID,obs_line,obs_string,obstacles(iter));
end

