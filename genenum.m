function numderive = genenum(last,next,dt,a_num,a,usecomplex,Beta)
        numderive = cell(9,1);

        [m,n,s] = size(last);
        F = zeros(m+4,n+4,s);
        F(3:m+2,3:n+2,:)=last;
        Fchange = cell(9,1);
        Fchange{1} = F(2:m+1,2:n+1,:);
        Fchange{2} = F(2:m+1,3:n+2,:);
        Fchange{3} = F(2:m+1,4:n+3,:);
        Fchange{4} = F(3:m+2,2:n+1,:);
        Fchange{5} = last;
        Fchange{6} = F(3:m+2,4:n+3,:);
        Fchange{7} = F(4:m+3,2:n+1,:);
        Fchange{8} = F(4:m+3,3:n+2,:);
        Fchange{9} = F(4:m+3,4:n+3,:);

        for i = 1 : 9
            
                if usecomplex
                    mu =  1e-150*1i;
                else
                    % mu = 2*sqrt(1e-12)*(1+norm(x))/norm(p);
                    mu =  2*sqrt(1e-12)* 5 /9;
                end
                %mu =0;

                Fchange{i} = Fchange{i}+mu;
                Dif{1}= Fchange{5};
                Dif{2}=(Fchange{6}-Fchange{4})/2;
                Dif{3}=(Fchange{8}-Fchange{2})/2;
                Dif{4}= Fchange{4}+Fchange{6}-2  *  Fchange{5};
                Dif{5}=( Fchange{1} + Fchange{9}-Fchange{3}-Fchange{7})/4;
                Dif{6}=Fchange{2}+ Fchange{8}-2* Fchange{5};
                inv=geneInv_auto(Dif,Beta);
                diff = last;
                for k = 1:a_num
                    diff = diff + dt * a(k) * inv{k};
                end

                if usecomplex
                    Fchange{i} =real(Fchange{i});
                    numderive{i} = imag(diff) * 1i /mu;
                else
                    Fchange{i} = Fchange{i} - mu;
                    numderive{i} =  (diff - next)/mu;
                end
            
        end
end

 

 