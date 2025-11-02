function [N,C_b,C_s] = prism_unit_gen(R,h,p)
%UNTITLED2 此处提供此函数的摘要
%   此处提供详细说明

% R=0.25; h=0.5; p=3;     % radius; height; number of edge
beta=180*(0.5-1/p); 	% rotation angle
for i=1:p               % nodal coordinate matrix N
    N(:,i)=R*[cos(2*pi*(i-1)/p),sin(2*pi*(i-1)/p),0];
end
for i=p+1:2*p
    N(:,i)=[R*cos(2*pi*(i-1)/p+beta*pi/180),R*sin(2*pi*(i-1)/p+beta*pi/180),h];
end

% Manually specify connectivity indices.
C_s_in = [1 2;2 3;3 1;4 5;5 6;6 4;1 4;2 5;3 6];  % This is indicating that string connection
C_b_in = [1 5;2 6;3 4];  % Similarly, this is saying bar 1 connects node 1 to node 2
% Convert the above matrices into full connectivity matrices.
C_b = tenseg_ind2C(C_b_in,N);%%
C_s = tenseg_ind2C(C_s_in,N);

end