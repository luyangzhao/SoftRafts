function [q_gp,t_gp,q,t]=tenseg_prestress_design(Gp,l,l_gp,A_1ag,V2,w0a,index_gp,fd)
% This function is written by Ma, S., Chen, M. and Skelton, R., 2022. TsgFEM: Tensegrity finite element method. Journal of Open Source Software, 7(75), p.3390. 
% The code license is Mozilla Public License, v. 2.0.
% The source code is here:
% https://github.com/Muhao-Chen/Tensegrity_Finite_Element_Method_TsgFEM/tree/main/Function_library/tenseg_prestress_design.m
%
% /* This Source Code Form is subject to the terms of the Mozilla Public
% * License, v. 2.0. If a copy of the MPL was not distributed with this
% * file, You can obtain one at http://mozilla.org/MPL/2.0/.
%
% This function gives the prestress design of tensegrity, consider boundary
% constraints and group constraints, given deisgned force( vector with
% number of prestress modes entries)
%
% Inputs:
%   Gp: group matrix of members
%   l: members' length vector
%   H: members' direction matrix
%	A_1ag: Equilirium matrix with boundary, group constraints, force density as variable.
%   V2: prestress mode
%   w0a: external force in free nodal coordinate
%   index_gp: number of groups with designed force
%   fd: force of designed groups
%
% Outputs:
%	q_gp: force desity vector in group
%	t_gp: force vector in group
%	q: force desity vector
%	t: force vector
%%
I=eye(size(Gp,2));
e_d=I(:,index_gp);        % e_d is the matrix to select group of member with designed force
l_d=e_d'*l_gp;            % length of top center circular strings
qd=fd./l_d;
z=(e_d'*V2)\(qd-e_d'*pinv(A_1ag)*w0a);   %self-stress coefficient
%%
q1_gp=pinv(A_1ag)*w0a;
q1=Gp*q1_gp;
q2_gp=V2*z;
q2=Gp*q2_gp;
q_gp=q1_gp+q2_gp;               % force density in group
q=q1+q2;                        % force density
t=diag(l)*q;                    % force vector
t_gp=pinv(Gp)*t;                % force in group
end