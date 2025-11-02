function [Node_coor] = rest_length_2_node_coor2(ind_dl0_c,dl0_c)
% 
% input: ind_dl0_c: active member index    d_l0_c: active member rest length change    
%
%
% output: new_nodal_coordinates
%
% example : 
%           [Node_coor] = rest_length_2_node_coor([9:20]',-ones(12,1)*0.01)

substep = 30;
complexity = 1;
[N,C_b,C_s] = modular_box(complexity);
C=[C_b;C_s];
[ne,nn]=size(C);        % ne:No.of element;nn:No.of node
% tenseg_plot(N,C_b,C_s);
index_b=1:size(C_b,1);   % index of bars
index_s=(size(C_b,1)+1):(size(C_b,1)+size(C_s,1)); % index of strings
%% Boundary constraints
% pinned_X=[9]; pinned_Y=[9]; pinned_Z=[9];
pinned_X=[]; pinned_Y=[]; pinned_Z=[];
[Ia,Ib,a,b]=tenseg_boundary(pinned_X,pinned_Y,pinned_Z,nn);
%% divide elements into groups
% cl_gr = [];   % because 
cl_gr = {index_s(1):index_s(1)+2*complexity,index_s(1)+2*complexity+1:index_s(end)}; 
temp_Gr=tenseg_str_gp(cl_gr,C); 
S = temp_Gr';
%% Geometric parameters
E_b1 = 60e09; % Aluminum
rho_b1 = 2700;  %
sigma_b1 = 110e06; %

E_b2 = 2e06;  % Rubber
rho_b2 = 1700;
sigma_b2 = 1e07;

E_s = 200e09; % steel
rho_s = 8000; % 
sigma_s = 300e06;

n_b = size(C_b,1); n_s = size(C_s,1); n_rub = n_s;
E=[E_b1 * ones(n_b-n_rub,1);E_b2 * ones(n_rub,1);E_s * ones(n_s,1)];     
SUM_S = sum(S,2);
for k = 1:size(S,1)
    if 1 == SUM_S(k)
        SS(k,:) = S(k,:);
    else
        index = find(S(k,:)==1);
        SS(k,:) = zeros(1,size(S,2));
        SS(k,index(1)) = 1;
    end
end    
E_c=SS*E;
%% stress / mass density
sigma=[sigma_b1 * ones(n_b-n_rub,1);sigma_b2 * ones(n_rub,1);sigma_s * ones(n_s,1)];      
rho=[rho_b1 * ones(n_b-n_rub,1);rho_b2 * ones(n_rub,1);rho_s * ones(n_s,1)];        
rho_c = SS*rho;
%% cross sectional design
index_b1=(1:n_b-n_rub); index_b2=(n_b-n_rub+1:n_b);
% index_s=(7:19);
index_s=setdiff(1:size(S,1),index_b);	% index of strings
r_b1 = 0.002; r_b2 = 0.005;r_s = 0.001;
A = [pi*r_b1^2*ones(n_b-n_rub,1);pi*r_b2^2*ones(n_rub,1);pi*r_s^2 *ones(n_s,1)]; 
A_c = SS*A;
%% the rest length
[A_1a,A_1ag,A_2a,A_2ag,l,l_gp]=tenseg_equilibrium_matrix1(N,C,temp_Gr,Ia);
A_1ac=A_1a*diag(l.^-1)*S'*diag(l_gp);          %equilibrium matrix CTS
A_2ac=A_2a*S';          %equilibrium matrix CTS

[U1,U2,V1,V2,~]=tenseg_svd(A_1ac);
% this can be used to design l0 about design prestress 
l_c=S*l;                % length vector CTS


gr=[];                     % if no group is used
Gp=tenseg_str_gp(gr,C);    % generate group matrix

w0=zeros(numel(N),1); w0a=Ia'*w0;

% %prestress design
% index_gp=1:size(C_b,1);                   % number of groups with designed force
% fd=0;                        % force in bar is given as -1*1e-1
% [q_gp,t_gp,q,t]=tenseg_prestress_design(Gp,l,l_gp,A_1ag,V2,w0a,index_gp,fd);    
%prestress design
index_gp=[2];                 % number of groups with designed force
fd=0*ones(numel(index_gp));              % force in strings
[q_c,t_c,q,t]=tenseg_prestress_design_CTS(S,l,l_c,A_2ac,V2,w0a,index_gp,fd);
% l0=l;
l0=E.*A.*l./(t+E.*A);

l0_c=S*l0;
mass=rho.*A.*l0;% the length of original configuration
lumped=0;                               
M=tenseg_mass_matrix(mass,C,lumped);      % generate mass matrix

%% external force, forced motion of nodes, shrink of strings
gravity=0;                         % no consider 'gravity'
ind_w=[];w=[];
ind_dnb=[]; dnb0=[];               % displacement of pinned nodes
[w_t,dnb_t,l0_ct,Ia_new,Ib_new]=tenseg_load_prestress(substep,ind_w,w,ind_dnb,dnb0,ind_dl0_c,dl0_c,l0_c,b,gravity,[0;9.8;0],C,mass);

data.slack = 1;
data.N=N; data.C=C; data.ne=ne; data.nn=nn; data.Ia=Ia_new; data.Ib=Ib_new;data.S=S;data.E_b1 = E_b1;data.E_b2 = E_b2;data.E_s = E_s;
data.E=E_c; data.A=A_c; data.index_b1=index_b1; data.index_b2=index_b2;data.index_s=index_s;   data.material=material; %constitue info
data.w_t=w_t;  % external force
data.dnb_t=dnb_t;% forced movement of pinned nodes
data.l0_t=l0_ct;% forced movement of pinned nodes
data.substep=substep;    % substep
% % nonlinear analysis
% solve equilibrium using mNewton method
data_out=static_solver_CTS(data);
%% output results
% l_t_final=data_out.l_out;          % member length in every step
n_t_final=data_out.n_out;          % member node vector in every step
% l_final=l_t_final(:,end);                      % final length       
Node_coor = reshape(n_t_final(:,end),3,[]);  % final nodal coordinate
%% plot final structure
% fig1=tenseg_plot2(N,C_b,C_s);
% tenseg_plot(Node_coor,C_b,C_s);
end