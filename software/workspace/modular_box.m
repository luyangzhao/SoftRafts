function [N,C_b,C_s] = modular_box(complexity)
%

y_nn=complexity*3+1;
yn=3*complexity:-2:-3*complexity;
xn=[-1,1]*2;

lx=diff(xn);
ly=abs(mean(diff(yn)));
lb_hypo=sqrt(lx^2+ly^2);
lb_vert=ly;
% 
if ~exist('N','var')
    N=zeros(3,numel(yn)*2);
    N(2,:)=kron(yn,[1,1]);
    N(1,:)=kron(ones(1,y_nn),xn);
end
% connectivity matrix
cb_index1=[[1:2:numel(yn)*2-1]',[2:2:numel(yn)*2]'];
[C_b] = tenseg_cm_def(cb_index1,numel(yn)*2);
cb_index2=[[1:2:numel(yn)*2-3]',[1:2:numel(yn)*2-3]'+3];
cb_index2=[cb_index2;[[2:2:numel(yn)*2-2]',[2:2:numel(yn)*2-2]'+1]];
C_b=[C_b;tenseg_cm_def(cb_index2,numel(yn)*2)];

css_u=[1 3;3 5;5 7;2 4;4 6;6 8];
css_index=css_u;
for iss=2:complexity
    css_index=[css_index;css_u+6*(iss-1)];
end
[C_s_psm] = tenseg_cm_def(css_index,numel(yn)*2);
C_b=[C_b;C_s_psm];
C_s=C_s_psm;



end