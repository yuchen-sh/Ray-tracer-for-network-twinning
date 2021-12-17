dir = pwd;
idcs = strfind(dir,'\');
qd_directory = dir(1:idcs(end)-1);
for file = 1:5
    if file == 1
        lambda = 1;
        AP = 2;
    elseif file == 2
        lambda = 2;
        AP = 1;
    elseif file == 3
        lambda = 2;
        AP = 2;
    elseif file == 4
        labmda = 2;
        AP = 3;
    elseif file ==5
        lambda = 3;
        AP = 2;
    end
    inpFile = sprintf('\\all_cases\\lamda0%s_%sAP\\AP_pos.txt',num2str(lambda),num2str(AP));
    APFileName = strcat(qd_directory,inpFile);
    FileName = fopen(APFileName,'r');
    APNodes = zeros(AP,3);
    for x = 1:AP
        line = fgetl(FileName);
        num = strsplit(line, ',');
        for i = 1:3
            APNodes(x,i) = str2double(num{i});
        end
    end
    fclose(FileName);
    for AP_iter = 1:AP
        fileID = fopen('node_tmp.txt','w');
        fprintf(fileID,'%.4f,%.4f,%.4f',APNodes(AP_iter,1),APNodes(AP_iter,2),APNodes(AP_iter,3));
        fclose all;
        move_from = strcat(qd_directory,'\src\node_tmp.txt');
        move_to = strcat(qd_directory,'\src\NewScenario\Input\NodePosition1.dat');
        movefile(move_from, move_to);
        for scene = 1:5
            timing = 0;
            obstacles = sprintf('\\all_cases\\lamda0%s_%sAP\\case_fixed_obs_%s.txt',num2str(lambda),num2str(AP),num2str(scene));
            xmlwriter(strcat(qd_directory,obstacles));
            nodeFile = sprintf('\\all_cases\\lamda0%s_%sAP\\case_UE_pos_%s.txt',num2str(lambda),num2str(AP),num2str(scene));
            fid = fopen(strcat(qd_directory,nodeFile),'r');
            line = fgetl(fid);
            numNodes = 20;
            numDim = 4;
            row = zeros(1,numDim);
            mat = zeros(numNodes,numDim-1);
            to_run = zeros(1,numNodes);
            n = 1;
            while line ~= -1
                num = strsplit(line, ' ');
                for node_num = 1:numDim
                    row(node_num) = str2double(num{node_num});
                end
                mat(n,:) = row(1:end-1);
                to_run(n) = row(end);
                line = fgetl(fid);
                n = n + 1;
            end
            fclose(fid);    
            for node_iter = 1:numNodes
                fileID = fopen('node_tmp.txt','w');
                fprintf(fileID,'%.4f,%.4f,%.4f',mat(node_iter,1),mat(node_iter,2),mat(node_iter,3));
                fclose all;
                move_from = strcat(qd_directory, '\src\node_tmp.txt');
                move_to = strcat(qd_directory, '\src\NewScenario\Input\NodePosition0.dat');
                movefile(move_from,move_to);
                tic;
                main;
                a = toc;
                timing = timing + a;
                fclose all;
                tx1 = sprintf('\\out\\Lambda0%s_0%sAP\\AP%s\\Scenario%s\\%sTx0Rx1.txt',num2str(lambda),num2str(AP),num2str(AP_iter),num2str(scene),num2str(node_iter));
                tx1 = strcat(qd_directory,tx1);
                tx0 = sprintf('\\out\\Lambda0%s_0%sAP\\AP%s\\Scenario%s\\%sTx1Rx0.txt',num2str(lambda),num2str(AP),num2str(AP_iter),num2str(scene),num2str(node_iter));
                tx0 = strcat(qd_directory, tx0);
                move_from1 = strcat(qd_directory,'\src\NewScenario\Output\Ns3\QdFiles\Tx0Rx1.txt');
                movefile(move_from1,tx1);
                move_from2 = strcat(qd_directory,'\src\NewScenario\Output\Ns3\QdFiles\Tx1Rx0.txt');
                movefile(move_from2,tx0);
            end
            
            file_name = sprintf('\\out\\Lambda0%s_0%sAP\\AP%s\\Scenario%s\\timing.txt',num2str(lambda),num2str(AP),num2str(AP_iter),num2str(scene));
            file_name = strcat(qd_directory,file_name);
            fileID= fopen(file_name,'w');
            fprintf(fileID,'This Scenario took: %s seconds',num2str(timing));
            fclose(fileID);
        end
    end
    
end


