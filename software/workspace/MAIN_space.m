% main test
% Note: Full rest length change use column 12
%       Half rest length change use column 13

clear; close all; clc; warning off;
%%
complexity = 1;
[N,C_b,C_s] = modular_box(complexity);

fig1 = tenseg_plot_3(N,C_b,C_s); hold on;
C=[C_b;C_s];
index_b=1:size(C_b,1);   % index of bars
index_s=(size(C_b,1)+1):(size(C_b,1)+size(C_s,1)); % index of strings

str_len = max(N(2,:)) - min(N(2,:));

input = zeros(2,1);
% single_length_vary = -1*linspace(0,0.431,10); % A: change range:0-0.421(0.521-0.09)
single_length_vary = -1*linspace(0,str_len/2,10); % B 0-0.2605(0.521/2)
space_A_point = [];
for i=1:500
    for j=1:2
        input(j) = single_length_vary(randi([1,10]));
    end
    [Node_coor] = rest_length_2_node_coor2(index_s([1,2])',input);
    if ~any(isnan(Node_coor(3,:)))
        space_A_point = [space_A_point,Node_coor(:,1:8)];
    end
    
end
fig1 = figure;
scatter3(space_A_point(1,1:end),space_A_point(2,1:end),space_A_point(3,1:end),'blue','Marker','.');hold on;


%%
[Node_coor_add1] = rest_length_2_node_coor2(index_s([1,2])',-[0,str_len/2]);

[Node_coor_add2] = rest_length_2_node_coor2(index_s([1,2])',-[str_len/8,str_len/8*2]);

tenseg_plot_process(Node_coor_add1,C_b,C_s,fig1); hold on;

tenseg_plot_process(Node_coor_add2,C_b,C_s,fig1); hold on;











