function pde = pde_bp(pde,x,y)

    
    n = pde.n;
    equ = pde.equ;
    m=size(x,3);
    outputsize = size(pde.U{n}{1});
    temp = outputsize(1)*outputsize(2);
    fea = zeros(temp*equ,m);
    for j=1:equ
        fea(temp*(j-1)+1:temp*j,:)=reshape(pde.U{n}{j},temp,m);
    end
    fea=[ones(1,m);fea];
   pde.W=y*fea'*inv(fea*fea'+diag([1 pde.lambda*ones(1,temp*equ)]));

  
  
  
  
    pde.error = sum(sum((y-pde.W*fea).*(y-pde.W*fea)))/m; 

    dU=-pde.W'*(y-pde.W*fea)/m;
    dU=dU(2:end,:);
    ddU =cell(equ,1); 
    for j=1:equ
        ddU{j} = reshape(dU(temp*(j-1)+1:temp*j,:),outputsize(1),outputsize(2),outputsize(3));
    end
%%     %%%numerical derivative

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = (n - 1) : -1 : 1
       
        ddUlast = cell(equ,1);
        for j = 1 : equ
            if i>1 && strcmp(pde.layers{i}.type, 's')
                inputsize = size(pde.U{i}{j});
                if strcmp(pde.layers{i}.function, 'max')
                ex1 = expand(ddU{j},[pde.layers{i}.scale,pde.layers{i}.scale,1]);
                ex2 = expand(pde.U{i+1}{j},[pde.layers{i}.scale,pde.layers{i}.scale,1]);         
                ddUlast{j} =ex1(1:inputsize(1),1:inputsize(2),:).*(ex2(1:inputsize(1),1:inputsize(2),:)==pde.U{i}{j});
                else
                    ex1 = expand(ddU{j},[pde.layers{i}.scale,pde.layers{i}.scale,1])/(pde.layers{i}.scale.^2);
                     ddUlast{j} =ex1(1:inputsize(1),1:inputsize(2),:);
                end
                
                
            else
            pde.da{i}{j}=gradFa(ddU{j},pde.Inv_U{i}{j},pde.t,pde.a_num);
            
            
            if i>1
                ddUlast{j} = ddU{j};
                % generate map the map is cell with size 9 and from first
                % left to right  then up to down
                numderive = genenum(pde.U{i}{j},pde.U{i+1}{j},pde.t,pde.a_num, pde.a{i}{j},pde.complex,pde.Beta);
                for k= 1 : 9
                    numderive{k} = numderive{k}.* ddU{j};
                end
                %up
                ddUlast{j}(1:end-1,1:end-1,:)  =  ddUlast{j}(1:end-1,1:end-1,:) +  numderive{1}(2:end,2:end,:);
                ddUlast{j}(1:end-1,1:end,:)  =  ddUlast{j}(1:end-1,1:end,:) +  numderive{2}(2:end,1:end,:);
                ddUlast{j}(1:end-1,2:end,:)  =  ddUlast{j}(1:end-1,2:end,:) +  numderive{3}(2:end,1:end-1,:);
                %mid
                ddUlast{j}(1:end,1:end-1,:)  =  ddUlast{j}(1:end,1:end-1,:) +  numderive{4}(1:end,2:end,:);
                ddUlast{j}(1:end,1:end,:)  =  ddUlast{j}(1:end,1:end,:) +  numderive{5}(1:end,1:end,:);
                ddUlast{j}(1:end,2:end,:)  =  ddUlast{j}(1:end,2:end,:) +  numderive{6}(1:end,1:end-1,:);
                %down
                ddUlast{j}(2:end,1:end-1,:)  =  ddUlast{j}(2:end,1:end-1,:) +  numderive{7}(1:end-1,2:end,:);
                ddUlast{j}(2:end,1:end,:)  =  ddUlast{j}(2:end,1:end,:) +  numderive{8}(1:end-1,1:end,:);
                ddUlast{j}(2:end,2:end,:)  =  ddUlast{j}(2:end,2:end,:) +  numderive{9}(1:end-1,1:end-1,:);  
            end
            
               
            end
          
        end
          ddU =ddUlast;
    end
end

function da=gradFa(dU,Inv_U,dt,a_num)

for i=1:a_num
    da(i)=dt*sum(sum(sum(dU.*Inv_U{i})));
end

end
