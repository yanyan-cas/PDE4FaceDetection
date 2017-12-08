function inv=geneInv_auto(Dif_v,Beta)
%%% generate invariant


[M,N,S]=size(Dif_v{1});

inv{1}=ones(M,N,S);
inv{2}=Dif_v{1};
inv{3}=Dif_v{2}.*Dif_v{2}+Dif_v{3}.*Dif_v{3};
inv{4}=Dif_v{4}+Dif_v{6};
% inv{5}=(Dif_v{2}.*Dif_v{4}+Dif_v{3}.*Dif_v{5}).*Dif_v{2}...
%     +(Dif_v{2}.*Dif_v{5}+Dif_v{3}.*Dif_v{6}).*Dif_v{3};
% inv{6}=Dif_v{4}.*Dif_v{4}+2*Dif_v{5}.*Dif_v{5}+Dif_v{6}.*Dif_v{6};
%% two  affine invariants
inv{5}=Dif_v{3}.*Dif_v{3}.*Dif_v{4}-2*Dif_v{2}.*Dif_v{3}.*Dif_v{5}+Dif_v{2}.*Dif_v{2}.*Dif_v{6};
inv{6}=Dif_v{4}.*Dif_v{6}-Dif_v{5}.*Dif_v{5};




for i = 2 : 4
 inv{i} = inv{i}./(abs(inv{i})+Beta);   
end