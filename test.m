clear   
load('yaleB.mat')
 train_size = 10;
[x,y,val_x,val_y] = make_data(yaleB,train_size);


pde.lambda =10;
pde.learningRate =1;



opts.numepochs = 10;
opts.batchsize = 38*train_size;
pde.complex = 0;
pde.t = 0.5;
pde.a_num = 6;

pde.scaling_learningRate = 0.95;
pde.momentum = 0;
pde.weightPenaltyL2 =  0;
pde.layers = {
          struct('type', 'g');
         struct('type', 'g');
   % struct('type', 's', 'scale', 2,'function','mean') %sub sampling layer
         struct('type', 'g');
         struct('type', 'g');  
         struct('type', 'g');
};
pde.equ  = 1;
pde.Beta=1;%%regular terms for a_i
%% Step2 training and testing
        pde.n = numel(pde.layers)+1;
        [pde] = PDE_Network( pde, x, y,  val_x, val_y, opts);
