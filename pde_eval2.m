function [acc] = pde_eval2(pde,val_x, val_y)

n = pde.n;
equ = pde.equ;
[labelsize,m] = size(val_y);
%change val_x val_y
acc= 0;
for  i = 1 : ceil(m/2000)
    val_xtemp1 = val_x(:,:, (i-1)*2000+1:  min(i*2000,m));
    val_ytemp1   = val_y(:, (i-1)*2000+1:  min(i*2000,m));
    
    pde= pde_ff(pde, val_xtemp1);
    
    outputsize = size(pde.U{n}{1});
    temp = outputsize(1)*outputsize(2);
    mm = size(val_xtemp1,3);
    fea2 = zeros(temp*equ,mm);
    for j=1:equ
        fea2(temp*(j-1)+1:temp*j,:)=reshape(pde.U{n}{j},temp,mm);
    end
    fea2=[ones(1,mm);fea2];
    val_label=zeros(1,mm);
    for k=1:mm
        val_label(k)=find( val_ytemp1(:,k)~=0);
    end
    acc = acc + predic_labels2( fea2,val_label,pde.W,labelsize);
    %acc1 = predic_labels(fea2,val_label,pde.W)
end
acc = acc/m;



end
