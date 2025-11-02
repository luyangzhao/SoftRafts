function C = setoff_C(C)
% delete duplicated C_in_b or C_s_in
C_wait = [C(1,1) C(1,2);C(1,2) C(1,1)];
%unique C_b_in currently
need_delete = [];
for i =2:length(C(:,1))
    if ~ismember(C(i,:),C_wait,'rows')
        C_wait = [C_wait;C(i,1) C(i,2);C(i,2) C(i,1)];
    else
        need_delete = [need_delete i];
    end
end
C(need_delete,:)=[];
