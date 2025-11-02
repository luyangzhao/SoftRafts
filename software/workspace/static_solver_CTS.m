function data_out=static_solver_CTS(data)
%solve nonlinear equilibrium equations using modified Newton method
%converge to stable equilibrium, considering substep, for CTS( including
%TTS)

global E A l0 Ia Ib C S w ne Xb Xa dXa f_int l_int 
% minimize total energy? (1: use, 0: not use) it's time consuming
use_energy=1;

%% input data
C=data.C;
ne=data.ne;
Ia=data.Ia;
Ib=data.Ib;
S=data.S;
index_b1=data.index_b1;
index_b2=data.index_b2;
index_s=data.index_s;
substep=data.substep;
slack = data.slack;
E0=data.E;
E_b1 = data.E_b1;E_b2 = data.E_b2;E_s = data.E_s;
% consti_data=data.consti_data;
% material=data.material;
A=data.A;
% w0=data.w;
if  isfield(data,'w_t')
    if size(data.w_t,2)==substep
        w_t=data.w_t;
    elseif size(data.w_t,2)==1
        w_t=data.w_t*linspace(0,1,substep);
    end
else
    w_t=linspace(0,0,substep);
end

% dXb=data.dXb;
if  isfield(data,'dnb_t')
    if size(data.dnb_t,2)==substep
        dXb_t=data.dnb_t;
    elseif size(data.dnb_t,2)==1
        dXb_t=data.dnb_t*linspace(0,1,substep);
    end
else
    dXb_t=linspace(0,0,substep);
end
% l0_0=data.l0;
if size(data.l0_t,2)==substep
    l0_t=data.l0_t;
elseif size(data.l0_t,2)==1
    l0_t=data.l0_t*linspace(1,1,substep);
end

if  isfield(data,'subsubstep')
    subsubstep=data.subsubstep;
else
    subsubstep=30;          %default ssubstep
end

X0=data.N(:);
data_out=data;     %initialize output data
data_out.E_out=E0*ones(1,substep);


%% calculate equilibrium
X=X0;               %initialize configuration
Xb0=Ib'*X;           %pinned node
E=E0;
% lamda=linspace(0,1,substep);    %coefficient for substep
num_slack=ne*zeros(substep+1,1);    %num of string slack
Xa=Ia'*X;
cont=2;
for k=1:substep
    w=w_t(:,k);               %external force
    Xb=Xb0+dXb_t(:,k);         %forced node displacement
    l0=l0_t(:,k);         %forced enlongation of string
%     disp(k);
    u=1e-3;
% u=1e-2;
    
    X=[Ia';Ib']\[Xa;Xb];
    l=sqrt(sum((reshape(X,3,[])*C').^2))'; %bar length
    l_c=S*l;
    strain=(l_c-l0)./l0;        %strain of member
%     [E,sigma]=stress_strain(consti_data,index_b,index_s,strain,material);
        E(index_b1)=E_b1;
        E(index_b2)=E_b2;
        E(index_s)=E_s;
        %interplot stress
        stress(index_b1)= strain(index_b1)*E_b1;
        stress(index_b2)= strain(index_b2)*E_b2;
        stress(index_s)= strain(index_s)*E_s;
 if slack==1     % 1 considering slack;0 not considering
    index_slack=find(strain(index_s)<0);
    index_string_slack=index_s(index_slack);       %slack stings'number
    % change youngs mudulus of slack string E_ss=0
    %         E(index_b)=Eb;
    %         E(index_s)=Es;
    E(index_string_slack)=0;
    stress(index_string_slack)=0;      %reculate stress    
end




    f_c=stress'.*A;         %member force
    f=S'*f_c;
    q_c=f_c./l_c;
    q=f./l;      %reculate force density
    
    l_int=l;   f_int=f;
    
    for i=1:1e4
        X=[Ia';Ib']\[Xa;Xb];
        l=sqrt(sum((reshape(X,3,[])*C').^2))'; %bar length
        l_c=S*l;
        %         q=E.*A.*(1./l0-1./l);      %force density
        strain=(l_c-l0)./l0;        %strain of member
%         [E,sigma]=stress_strain(consti_data,index_b,index_s,strain,material);
        E(index_b1)=E_b1; E(index_b2)=E_b2;
        E(index_s)=E_s;
        %interplot stress
        stress(index_b1)= strain(index_b1)*E_b1; stress(index_b2)= strain(index_b2)*E_b2;
        stress(index_s)= strain(index_s)*E_s;
 if slack==1     % 1 considering slack;0 not considering
    index_slack=find(strain(index_s)<0);
    index_string_slack=index_s(index_slack);       %slack stings'number
    % change youngs mudulus of slack string E_ss=0
    %         E(index_b)=Eb;
    %         E(index_s)=Es;
    E(index_string_slack)=0;
    stress(index_string_slack)=0;      %reculate stress
    
end




        f_c=stress'.*A;         %member force
        f=S'*f_c;
        q_c=f_c./l_c;
        q=f./l;      %reculate force density
        
        q_bar=diag(q);
        
        K=kron(C'*q_bar*C,eye(3));                      %stiffness matrix
        Fp=w-K*X;                                       %unbalanced force
        Fp_a=Ia'*Fp;                                 %see the norm of unbalanced force
        norm(Fp_a);
        if norm(Fp_a)<1e-5
            break
        end
        N=reshape(X,3,[]);
        H=N*C';
        Cell_H=mat2cell(H,3,ones(1,size(H,2)));          % transfer matrix H into a cell: Cell_H

        A_2c=kron(C',eye(3))*blkdiag(Cell_H{:})*diag(l.^-1)*S';     % equilibrium matrix
        K_t=K+A_2c*diag(E.*A.*(l0.^-1))*A_2c';
%         for j=1:ne
%             Ki{j,1}=q_bar(j,j)*eye(3)+E(j)*A(j)*l(j)^(-3)*B(:,j)*B(:,j)';
%         end
%         K_t=kron(C',eye(3))*blkdiag(Ki{:})*kron(C,eye(3));
        K_taa=Ia'*K_t*Ia;
        

%         N=reshape(X,3,[]);
%         B=N*C';
%         for j=1:ne
%             Ki{j,1}=q_bar(j,j)*eye(3)+E(j)*A(j)*l(j)^(-3)*B(:,j)*B(:,j)';
%         end
%         K_t=kron(C',eye(3))*blkdiag(Ki{:})*kron(C,eye(3));
%         K_taa=Ia'*K_t*Ia;

        %modify the stiffness matrix
        [V_mode,D]=eig(K_taa);                       %刚度矩阵特征根
        d=diag(D);                            %eigen value
        lmd=min(d);                     %刚度矩阵最小特征根
        if lmd>0
            Km=K_taa+u*eye(size(K_taa)); %修正的刚度矩阵
        else
            Km=K_taa+(abs(lmd)+u)*eye(size(K_taa));
        end
        dXa=Km\Fp_a;
        
        x=1;
        % line search
        if use_energy==1
            opt=optimset('TolX',1e-5);
            [x,V]=fminbnd(@energy_CTS,0,1,opt);
        end
        Xa=Xa+x*dXa;
    end
    %
    %     % change youngs mudulus if string slack
    %     strain=(l-l0)./l0;        %strain of member
    %     [E,stress]=stress_strain(consti_data,index_b,index_s,strain,material);
    % %     [E,sigma]=stress_strain(consti_data,index_b,index_s,strain,slack,plastic);
    %     f=stress.*A;         %member force
    %     q=f./l;      %reculate force density
    %     num_slack(k+1)=numel(find(E==0));
    %        % if string slack, recalculate with more steps
    %     if num_slack(k+1)>num_slack(k)
    %         p_s=k-1;
    %           p_e=k;
    %         [E,f,q] = nonlinear_solver(data,Xb0,w_t,dXb_t,l0_t,data_out.E_out(:,k-1),p_s,p_e,subsubstep,material);
    %     end
    %     num_slack(k+1)=numel(find(E==0));
    %
    %     if min(E)==0
    %         if cont<2
    %             [d_sort,idx]=sort(d);               %sorted eigenvalue
    %             D_sort=diag(d_sort);                  %sorted eigenvalue matrix
    %             V_mode_sort=V_mode(:,idx);              %sorted eigenvector
    %             index_bk=find(d_sort<1e-5);             %index for buckling mode
    %             cont=cont+1;
    %             Xa=Xa+0.0*min(l)*real(mean(V_mode_sort(:,index_bk),2));    %add unstable mode if needed
    %         end
    %     end
    
    
    %     if slack
    %         if sum(q_i(index_s)<1e-6)
    %             index_slack=find(q_i(index_s)<0);
    %             index_string_slack=index_s(index_slack);       %slack stings'number
    %             % change youngs mudulus of slack string E_ss=0
    %             E=E0;
    %             E(index_string_slack)=0;
    %             q=E.*A.*(1./l0-1./l);      %reculate force density
    %             q_bar=diag(q);
    %
    %             %give initial error in coordinate, prevent unstable solution
    %             if cont<3
    %             [d_sort,idx]=sort(d);               %sorted eigenvalue
    %             D_sort=diag(d_sort);                  %sorted eigenvalue matrix
    %             V_mode_sort=V_mode(:,idx);              %sorted eigenvector
    %             index_bk=find(d_sort<1e-5);             %index for buckling mode
    %             cont=cont+1;
    %             end
    %             Xa=Xa+0*min(l)*real(mean(V_mode_sort(:,index_bk),2));    %add unstable mode if needed
    %         else
    %             E=E0;              %use initial young's muldus
    %         end
    %     end
    
    
    %% output data
    
    data_out.N_out{k}=reshape(X,3,[]);
    data_out.n_out(:,k)=X;
        data_out.l_out(:,k)=l;
    %     data_out.q_out(:,k)=q;
    %     data_out.E_out(:,k)=E;
    data_out.t_out(:,k)=f;      %member force
    % data_out.V{k}=energy_cal(data_out);
    data_out.Fpn_out(k)=norm(Ia'*Fp);
end
data_out.E=E;
data_out.N=reshape(X,3,[]);
N=reshape(X,3,[]);
H=N*C';
Cell_H=mat2cell(H,3,ones(1,size(H,2)));          % transfer matrix H into a cell: Cell_H
A_2c=kron(C',eye(3))*blkdiag(Cell_H{:})*diag(l.^-1)*S';     % equilibrium matrix
K_t=K+A_2c*diag(E.*A.*(l0.^-1))*A_2c';
data_out.Kt = K_t;









