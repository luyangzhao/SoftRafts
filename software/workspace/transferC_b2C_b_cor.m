function [C_b_cor,C_s_cor] = transferC_b2C_b_cor(N,Cb,Cs)
%% This function is to transfer Cb in adjacent form to coordinates form
% Inputs:
%       N:n*3 matrix,indicates the node coordinate
%       Cb:alpha*n matrix,adjacent matrix
%       Cs:beta*n matrix,adjacent matrix
% Outputs:
%       C_b_cor:aplha*6 matrix
%       C_s_cor:beta*6 matrix

C_b_cor = [];
C_s_cor = [];
for i=1:length(Cb(:,1))
    C_b_cor = [C_b_cor;N(find(Cb(i,:)==-1),:) N(find(Cb(i,:)==1),:)];
end
for i=1:length(Cs(:,1))
    C_s_cor = [C_s_cor;N(find(Cs(i,:)==-1),:) N(find(Cs(i,:)==1),:)];
end
