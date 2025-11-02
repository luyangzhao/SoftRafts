function [N,C_b,C_s] = lander_gen(L)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明

% L = 1;
th1 = -atan(1/2);
N = [L/4 0 0;L/4 0 L;-L/4 0 0;-L/4 0 L;
    0 -L/2 3*L/4;0 L/2 3*L/4;0 -L/2 L/4;0 L /2 L/4;
    L/2 -L/4 L/2;-L/2 -L/4 L/2;L/2 L/4 L/2;-L/2 L/4 L/2]';
N = [1 0 0;0 cos(th1) -sin(th1);0 sin(th1) cos(th1)]*N;
% N = [cos(th2) -sin(th2) 0;sin(th2) cos(th2) 0;0 0 1]*N;
C_b_in = [1 2;3 4;5 6;7 8;9 10;11 12];
C_s_in = [2 5;2 6;2 9;2 11;4 5;4 6;4 10;4 12;
    1 7;1 8;1 9;1 11;3 7;3 8;3 10;3 12;
    5 9;5 10;7 9;7 10;6 11;6 12;8 11;8 12];
% Convert the above matrices into full connectivity matrices.
C_b = tenseg_ind2C(C_b_in,N);%%
C_s = tenseg_ind2C(C_s_in,N);
end