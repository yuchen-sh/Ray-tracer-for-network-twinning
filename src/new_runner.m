function [] = new_runner(start_idx, end_idx)
dir = pwd;
idcs = strfind(dir,'/');
qd_directory = dir(1:idcs(end)-1);
AP_fileID = fopen('scenario_data_AP_info.csv');
obs_fileID = fopen('scenario_data_obs_info.csv');
room_fileID = fopen('scenario_data_room_info.csv');
ue_fileID = fopen('scenario_data_ue_info.csv');
AP_line = fgetl(AP_fileID);
obstacles = strcat(qd_directory,'/src/room.txt');
AP_node_dat_file = strcat(qd_directory,'/src/NewScenario/Input/NodePosition1.dat');
User_node_dat_file = strcat(qd_directory, '/src/NewScenario/Input/NodePosition0.dat');
AP_node_ID = fopen(AP_node_dat_file,'w');
User_node_ID = fopen(User_node_dat_file,'w');
temp_node_file = strcat(qd_directory, '/src/node_tmp.txt');
material_file = strcat(qd_directory, '/src/materials.csv');
mID = fopen(material_file,'w');
fclose(mID);
%for(scenario - 1:200)
%Get rid of file lines
%get number of runs that are passed here
%assign start index here
iter = 1;
for x = 1:start_idx - 1
    room = fgetl(room_fileID);
    num_obs = fgetl(obs_fileID);
    for i = 1:5
        line = fgetl(obs_fileID);
    end
    user_num = str2double(fgetl(ue_fileID));
    for i = 1:user_num
        user_position = sscanf(fgetl(ue_fileID),'%f,%f,%f');
        iter = iter + 1;
    end
    AP_line = fgetl(AP_fileID);
end
while (~feof(AP_fileID) && start_idx <= end_idx)
    room_file = fopen('room.txt','w');
    room = fgetl(room_fileID);
    fprintf(room_file,strcat(room,'\n'));
    num_obs = fgetl(obs_fileID);
    fprintf(room_file,strcat(num_obs,'\n'));
    for i = 1:5
        if i == 5
            line = fgetl(obs_fileID);
        else
            line = strcat(fgetl(obs_fileID),'\n');
        end
        fprintf(room_file,line);
    end
    fclose(room_file);
    obs_count = str2double(num_obs);
    [wall_mat, floor_mat, obstacles_mat] = materialwriter(obs_count);
    printstr = "%.4f,%.4f,";
    for i = 1:obs_count
        if i == obs_count
            printstr = strcat(printstr,"%.4f\n");
        else
            printstr = strcat(printstr,"%.4f,");
        end
    end
    mID = fopen(material_file,'a');
    fprintf(mID,printstr, wall_mat, floor_mat, obstacles_mat);
    fclose(mID);
    %Print materail info to file
    xmlwriter(obstacles);
    user_num = str2double(fgetl(ue_fileID));
    AP_node_ID = fopen(AP_node_dat_file,'w');
    AP_info = sscanf(AP_line,'%f,%f,%f');
    fprintf(AP_node_ID,'%.4f,%.4f,%.4f',AP_info);
    fclose(AP_node_ID);
    for i = 1:user_num
        user_position = sscanf(fgetl(ue_fileID),'%f,%f,%f');
        User_node_ID = fopen(User_node_dat_file,'w');
        fprintf(User_node_ID,'%.4f,%.4f,%.4f',user_position);
        fclose(User_node_ID);
        main;
        tx1 = strcat(qd_directory,sprintf('/out/%sTx0Rx1.txt',num2str(iter)));
        tx0 = strcat(qd_directory,sprintf('/out/%sTx1Rx0.txt',num2str(iter)));
        move_from1 = strcat(qd_directory,'/src/NewScenario/Output/Ns3/QdFiles/Tx0Rx1.txt');
        copyfile(move_from1,tx1);
        move_from2 = strcat(qd_directory,'/src/NewScenario/Output/Ns3/QdFiles/Tx1Rx0.txt');
        copyfile(move_from2,tx0);
        iter = iter + 1;
    end
    AP_line = fgetl(AP_fileID);
    start_idx = start_idx + 1;
end
end