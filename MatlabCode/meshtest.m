<<<<<<< HEAD
% meshing testing

%% making the model

[xg, yg] = meshgrid(0:0.25:17, 0:0.25:5);
xg = xg(:);
yg = yg(:);

zg = ones(numel(xg),1);
xg = repmat(xg,5,1);
yg = repmat(yg,5,1);
zg = zg*(0:.25:1);
zg = zg(:);
shp = alphaShape(xg,yg,zg,0.5);

[elements,nodes] = boundaryFacets(shp);

nodes = nodes';
elements = elements';

model = createpde();
geometryFromMesh(model,nodes,elements);

pdegplot(model,'FaceLabels','on')


%% generate new mesh

generateMesh(model,'Hmax',0.2,'Hmin',0.05)
=======
% meshing testing

%% making the model

[xg, yg] = meshgrid(0:0.25:17, 0:0.25:5);
xg = xg(:);
yg = yg(:);

zg = ones(numel(xg),1);
xg = repmat(xg,5,1);
yg = repmat(yg,5,1);
zg = zg*(0:.25:1);
zg = zg(:);
shp = alphaShape(xg,yg,zg,0.5);

[elements,nodes] = boundaryFacets(shp);

nodes = nodes';
elements = elements';

model = createpde();
geometryFromMesh(model,nodes,elements);

pdegplot(model,'FaceLabels','on')


%% generate new mesh

generateMesh(model,'Hmax',0.2,'Hmin',0.05)
>>>>>>> 7db81067ecd006c7ae6c9254d146c487e5e406f5
pdeplot3D(model)