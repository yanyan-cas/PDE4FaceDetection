function [x,y,val_x,val_y] = make_data(xall,train_size)
   x =[];
   y = [];
   val_x = [];
   val_y = [];
   a = 48;
   b = 42;
   for i = 1 : length(xall)
       rand('state',0)
       [qq,m] = size(xall{i});
        kk = randperm(m);
        m = length(kk);
         xtemp  = xall{i}(:,kk(1:train_size));
         ytemp  = zeros(length(xall), train_size);
         ytemp(i,:) = 1;
         val_xtemp = xall{i}(:,kk(train_size+1:end));
         val_ytemp = zeros(length(xall),m - train_size);
         val_ytemp(i,:) = 1;
         x = [x ,  xtemp];
          y = [y ,  ytemp];
           val_x = [val_x ,  val_xtemp];
           val_y = [val_y ,  val_ytemp ];
            
   end
    [~,l] = size(x);
   x = reshape(x,a,b,l);
       [~,l] = size(val_x);
   val_x = reshape(val_x,a,b,l);
end