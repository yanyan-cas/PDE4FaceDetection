function [ pde] = pde_ini( pde)
%rand('state',0)

for j = 1:pde.n-1
    if strcmp(pde.layers{j}.type, 'g')
        for i = 1:pde.equ
           
            pde.a{j}{i}=zeros(1,pde.a_num);
            
        end
    end
end
end
