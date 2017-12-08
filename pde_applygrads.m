    function pde = pde_applygrads(pde)
    
    
    momentum = pde.momentum;
    weightPenaltyL2 = pde.weightPenaltyL2;
    
        for i = 1 : (pde.n - 1)
            if   strcmp(pde.layers{i}.type, 'g')           
                
                for j = 1:pde.equ
                    
                    if(momentum>0)                        
                        pde.a_old{i}{j}= (1 - momentum) * pde.da{i}{j} + momentum * pde.a_old{i}{j};
                        pde.da{i}{j} =   pde.a_old{i}{j};
                    end

                    if(weightPenaltyL2>0)                   
                        pde.da{i}{j}  =     pde.da{i}{j}  + weightPenaltyL2 *  pde.da{i}{j} ;
                    end

                    pde.a{i}{j}  =  pde.a{i}{j}  - pde.learningRate *  pde.da{i}{j} ;

                end
                
                
            end
        end
        
          
        
    end
