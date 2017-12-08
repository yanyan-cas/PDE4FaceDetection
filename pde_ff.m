function pde = pde_ff(pde, x)

n = pde.n;
equ = pde.equ;
% the initialization is all x
for i = 1: equ
    pde.U{1}{i} = x;
end
%feedforward pass
    for i = 2 : n
        for j = 1: equ
           
            
            if strcmp(pde.layers{i-1}.type, 'g')
                Dif_v =  DifImage1(pde.U{i-1}{j});
                pde.Inv_U{i-1}{j}=geneInv_auto(Dif_v,pde.Beta);
                pde.U{i}{j}=pde.U{i-1}{j};
                %pde.U{i}{j}=zeros(pde.layers{i}.outputsize);
                for k=1:pde.a_num
                    pde.U{i}{j}=pde.U{i}{j}+pde.t*pde.a{i-1}{j}(k)*pde.Inv_U{i-1}{j}{k};
                end

            end
            
            
            if strcmp(pde.layers{i-1}.type, 's')
                [a,b,m] = size(pde.U{i-1}{j});
                c = ceil(a/pde.layers{i-1}.scale) * pde.layers{i-1}.scale;
                d = ceil(b/pde.layers{i-1}.scale) * pde.layers{i-1}.scale;
                uadd = padarray(pde.U{i-1}{j},[c-a,d-b,0],'replicate','post');
                    if strcmp(pde.layers{i-1}.function, 'max')
                        tt = strel('rectangle',[pde.layers{i-1}.scale,pde.layers{i-1}.scale]);
                        star =  ceil((pde.layers{i-1}.scale +1)/2);
                        z = imdilate(uadd,tt);
                        pde.U{i}{j} =z(star:pde.layers{i-1}.scale:end,star:pde.layers{i-1}.scale:end,:);
                    else
                        z = convn( uadd, ones(pde.layers{i-1}.scale) / (pde.layers{i-1}.scale ^ 2), 'valid');   %  !! replace with variable
                        pde.U{i}{j}= z(1 : pde.layers{i-1}.scale : end, 1 : pde.layers{i-1}.scale : end, :);
                    end
            end
            
            
        end
    end
    
    
    
end
