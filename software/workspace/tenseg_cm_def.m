function [C] = tenseg_cm_def(c_index,ne)
%tenseg_cm_deff def
%  c_index: ne × 2 or a cell
%%
C=[];
if  ismatrix (c_index)
    if size(c_index,2)~=2
        c_index=c_index';
    end
    for i=1:size(c_index,1)
        C=[C;tenseg_cm_ind(c_index(i,1),c_index(i,2),ne)];
    end
end
if iscellstr(c_index)
    
end
end

