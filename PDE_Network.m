function [pde] = PDE_Network( pde, train_x, train_y, val_x,val_y, opts )


m = size(train_x, 3);

pde.batchsize = opts.batchsize;


%% Step1 initial
[pde] = pde_ini(pde);

[pde.val_acc]=pde_eval(pde, train_x, train_y, val_x, val_y,pde.lambda);
disp([' Original Val accurate is ' num2str(pde.val_acc)]);



%% Step2 start training
numepochs = opts.numepochs;
numbatches = m / pde.batchsize;
pde.testval_acc = [];

n = 1;
for i = 1 : numepochs
    tic;
    kk = randperm(m);
    for l = 1 : numbatches
        batch_x = train_x(:,:,kk((l - 1) * pde.batchsize + 1 : l * pde.batchsize));        
        batch_y = train_y(:,kk((l - 1) * pde.batchsize + 1 : l * pde.batchsize));
        pde=pde_ff(pde,batch_x);
        pde=pde_bp(pde,batch_x, batch_y);
        pde = pde_applygrads(pde);
        n = n + 1;
    end 
    t = toc;
    pde.val_acc=[pde.val_acc,pde_eval(pde, train_x, train_y, val_x, val_y,pde.lambda)];
   pde.trainval_acc = pde_eval2(pde,  train_x, train_y);
   pde.testval_acc= [pde.testval_acc;pde_eval2(pde,  val_x, val_y)];
    if mod(i,1)==0
        disp(['epoch ' num2str(i) '/' num2str(opts.numepochs) '. Took ' num2str(t) ' seconds'...
            '.Train Error is ' num2str(pde.error)  '. Val accurate is ' num2str(pde.testval_acc(i))]);
    end

    pde.learningRate = pde.learningRate * pde.scaling_learningRate;
end
end

