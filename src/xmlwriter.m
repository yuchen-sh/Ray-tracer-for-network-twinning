function [] = xmlwriter(file)

fid = fopen(file,'r');
line = fgetl(fid);
room = strsplit(line,',');
room_length = str2double(room{1});
room_width = str2double(room{2});
room_height = str2double(room{3});
line = fgetl(fid);
numObs = str2double(line);
line = fgetl(fid);
row = zeros(1,numObs);
mat = zeros(6,numObs);
n = 1;
while line ~= -1
    num = strsplit(line, ',');
    for i = 1:numObs
        row(i) = str2double(num{i});
    end
    mat(n,:) = row;
    line = fgetl(fid); 
    n = n + 1;
end
fclose(fid);
% Create Document Node - xml file with AMF formatting
docNode = com.mathworks.xml.XMLUtils.createDocument('amf');
amf = docNode.getDocumentElement;
% Set meter as unit used
unit = 'meter';
amf.setAttribute('unit', unit);
% Add Outer wall object
getObj(docNode,amf,0,room_length,0,room_width,0,room_height,'1','Outside');
% Calculate minimum and maximum coordinates of obstacles
x = mat(4,:);
y = mat(5,:);
orient = zeros(1,numObs);
w = mat(2,:);
h = mat(3,:);
l = mat(1,:);
orientmask = orient == 90;%
minx = x - (orientmask .* (w/2) + ~orientmask .* (l/2));
maxx = x + (orientmask .* (w/2) + ~orientmask .* (l/2));
miny = y - (~orientmask .* (w/2) + orientmask .* (l/2));
maxy = y + (~orientmask .* (w/2) + orientmask .* (l/2));
wallNames = ["ceiling", "wall", "floor"];
materialID = [1,2,3];
for i = 1:numObs
    getObj(docNode,amf,minx(i),maxx(i), miny(i),maxy(i), 0, h(i), num2str(i + 1),strcat('obs-',num2str(i)));
    obs_name = sprintf("obstacle-%d",i);
    wallNames = [wallNames, obs_name];
    materialID = [materialID, i+3];
end

%Set Material aspects - Included in Material library
% Automatically uses default
for idx = 1:(numObs+3)
    material = docNode.createElement('material');
    material.setAttribute('id',num2str(materialID(idx)));
    metadata = docNode.createElement('metadata');
    metadata.setAttribute('type','name');
    metadata.appendChild(docNode.createTextNode(wallNames(idx)));
    material.appendChild(metadata);
    amf.appendChild(material);
    
end
dir = pwd;
idcs = strfind(dir,'/');
qd_directory = dir(1:idcs(end)-1);

xmlwrite(strcat(qd_directory,'/src/NewScenario/Input/Box.xml'),docNode);
end
%% Amf creator
function [amf] = getObj(docNode,amf,minx,maxx,miny,maxy,minz,maxz,id,name)

object = docNode.createElement('object');
object.setAttribute('id', id);
amf.appendChild(object);

metadata = docNode.createElement('metadata');
type = 'name';
metadata.setAttribute('type', type);
metadata.appendChild(docNode.createTextNode(name));
object.appendChild(metadata);

mesh = docNode.createElement('mesh');
object.appendChild(mesh);

vertices = addVertex(minx,maxx,miny,maxy,minz,maxz,docNode);
mesh.appendChild(vertices);
%if(strcmpi(name,'Outside')==1)
    %is_outdoor = 1;
%end
%if (is_outdoor == 0)

volume = addVolume(mesh,docNode,name,12,[0,0,4,5,6,6,2,1,0,1,4,3],...
        [1,2,0,0,5,4,6,6,5,0,3,2],[2,3,3,4,4,7,7,2,6,6,7,7]);
%else
    %%volume = addVolume(docNode,is_outdoor,12,[2,3,3,4,4,7,7,2,6,6,7,7],...
       % [1,2,0,0,5,4,6,6,5,0,3,2],[0,0,4,5,6,6,2,1,0,1,4,3]);
%end
mesh.appendChild(volume);


end
%% Add Vertices
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function creates the vertices of trangles to make up each box
% structure. Each vertex has an x y and z element to denote coordinates of
% the triangle vertices
function [vertices] = addVertex(minx,maxx,miny,maxy,minz,maxz,docNode)
vertices = docNode.createElement('vertices');
vertArr = [maxx maxy minz; minx maxy minz; minx maxy maxz; maxx maxy maxz; maxx miny maxz; maxx miny minz; minx miny minz; minx miny maxz];
for idx = 1:8
    vertex = docNode.createElement('vertex');
    coordinates = docNode.createElement('coordinates');
    
    xNode = docNode.createElement('x');
    xNode.appendChild(docNode.createTextNode(num2str(vertArr(idx,1))));
    
    yNode = docNode.createElement('y');
    yNode.appendChild(docNode.createTextNode(num2str(vertArr(idx,2))));
    
    zNode = docNode.createElement('z');
    zNode.appendChild(docNode.createTextNode(num2str(vertArr(idx,3))));
    
    coordinates.appendChild(xNode);
    coordinates.appendChild(yNode);
    coordinates.appendChild(zNode);
    
    vertex.appendChild(coordinates);
    vertices.appendChild(vertex);
end
end
%% Add volume
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function adds a volume attribute to each face of triangles. The
% materials of these volumes are specified by a material library in
% raytracer. This function specifies which numbered vectors are used in
% each face
function [volume] = addVolume(mesh,docNode,wall_type,numTriang,v1,v2,v3)
volume = docNode.createElement('volume');
if strcmpi(wall_type, 'Outside') == 1 %
    type = 0;
    %volume.setAttribute('materialid',"12");
else
    type = sscanf(wall_type, "obs-%d");
    %volume.setAttribute('materialid',"4");
end
if type ~= 0
    volume.setAttribute('materialid',num2str(type+3));
end
for idx = 1:numTriang
    if type == 0
        if idx == 1
            volume.setAttribute('materialid',"2")
        elseif idx == 9
            mesh.appendChild(volume);
            volume = docNode.createElement('volume');
            volume.setAttribute('materialid',"3");
        elseif idx == 11
            mesh.appendChild(volume);
            volume = docNode.createElement('volume');
            volume.setAttribute('materialid',"1");
        end
    end
    triangle = docNode.createElement('triangle');
    
    v1Node = docNode.createElement('v1');
    v1Node.appendChild(docNode.createTextNode(num2str(v1(idx))));

    v2Node = docNode.createElement('v2');
    v2Node.appendChild(docNode.createTextNode(num2str(v2(idx))));

    v3Node = docNode.createElement('v3');
    v3Node.appendChild(docNode.createTextNode(num2str(v3(idx))));

    triangle.appendChild(v1Node);
    triangle.appendChild(v2Node);
    triangle.appendChild(v3Node);
    
    volume.appendChild(triangle);

end
end