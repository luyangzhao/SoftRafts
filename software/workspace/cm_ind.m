function [added] = cm_ind(obj,inputArg1,inputArg2,lth)
added=zeros(1,lth);
added(inputArg1)=-1;
added(inputArg2)=1;
end

