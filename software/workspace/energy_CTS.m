function V=energy_CTS(x)
% calculate the total energy, x is the cofficient in line search
global   A E l0 Ia Ib C Xa Xb dXa  w S

X=Ia*(Xa+x*dXa)+Ib*Xb;
l=sqrt(sum((reshape(X,3,[])*C').^2))'; %bar length 
l_c=S*l;
V=0.5*(l_c-l0)'*diag(E.*A./l0)*(l_c-l0)-w'*X;  %结构总势能
