function [N,C_b,C_s] = box_rob(L,q)
%UNTITLED 此处提供此函数的摘要
%   此处提供详细说明
off_length = L*2/sqrt(3);
nz = L*cos(atan(sqrt(2))); nx = L*sin(atan(sqrt(2)))*sin(pi/4); ny = L*sin(atan(sqrt(2)))*cos(pi/4);
N1 = zeros(3,9);
N1(:,1) = [-nx;-ny;nz];N1(:,2) = [-nx;-ny;-nz];N1(:,3) = [-nx;ny;-nz];N1(:,4) = [-nx;ny;nz];
N1(:,5) = [nx;-ny;nz];N1(:,6) = [nx;-ny;-nz];N1(:,7) = [nx;ny;-nz];N1(:,8) = [nx;ny;nz];
C_b_in = [9 1;9 2;9 3;9 4;9 5;9 6;9 7;9 8];
C_s_in = [1 2;2 3;3 4;4 1;5 6;6 7;7 8;8 5;1 5;2 6;3 7;4 8];
C_b = tenseg_ind2C(C_b_in,N1);%%
C_s= tenseg_ind2C(C_s_in,N1);
N = zeros(3,9*q);
for i = 0 : q-1
    N(1,9*i+1:9*(i+1)) = N1(1,:) + off_length * i;
    N(2,9*i+1:9*(i+1)) = N1(2,:);
    N(3,9*i+1:9*(i+1)) = N1(3,:);
end
%% Aggregate nodes in all intervals and corresponding connectivity matrix
C_b_ori = C_b;
C_s_ori = C_s;

for i =1:q-1
    C_b = blkdiag(C_b,C_b_ori);
    C_s = blkdiag(C_s,C_s_ori);
end
% [N,C_b,C_s] = tenseg_unique(N,C_b,C_s);
[C_b_cor,C_s_cor] = transferC_b2C_b_cor(double(N'),C_b,C_s);
N_unique = setoff_dup_new(double(N')); % unique the nodes
C_b_in = transfer_C_b(N_unique,C_b_cor); 
C_s_in = transfer_C_b(N_unique,C_s_cor); 
C_b_in = setoff_C(C_b_in); % unique the C_b_in
C_s_in = setoff_C(C_s_in); % unique the C_s_in
C_b = tenseg_ind2C(C_b_in,N_unique');
C_s= tenseg_ind2C(C_s_in,N_unique');
N= N_unique';
% tenseg_plot(N,C_b,C_s);
end