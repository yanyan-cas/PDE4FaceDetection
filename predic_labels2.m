function [accuray] = predic_labels2( Z2,ts_label,W,labelsize)
%% predict
WW=W*Z2;
[~,C]=max(WW);

numclass=labelsize;
%% compute accuracy
acc = zeros(numclass, 1);
for jj = 1 : numclass,
        c = jj;
        idx = find(ts_label == c);
        curr_pred_label = C(idx);
        curr_gnd_label = ts_label(idx)';
        acc(jj) = length(find(curr_pred_label == curr_gnd_label'));%/length(idx);
end;
accuray = sum(acc);
end

