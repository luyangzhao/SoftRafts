function plot_mode(Mode,value,N,Ia,C_b,C_s,l,title,xlb,ylb,num_plt,ampli,saveimg,view_vec)
% /* This Source Code Form is subject to the terms of the Mozilla Public
% * License, v. 2.0. If a copy of the MPL was not distributed with this
% * file, You can obtain one at http://mozilla.org/MPL/2.0/.
%
% This function plot the mode shape(eigenvalue) of tensegrity structure
% with eigenvalue
%
switch nargin
    case 13
        view_vec=2;
end

figure
plot(1:numel(value),value,'k-o','linewidth',1.5);
set(gca,'fontsize',18);
xlabel(xlb,'fontsize',18,'Interpreter','latex');
ylabel(ylb,'fontsize',18,'Interpreter','latex');
% grid on;
if saveimg==1
    saveas(gcf,[title,'.png']);
end

for i=1:numel(num_plt)
    f1=figure;
    title2=({['mode ',num2str(num_plt(i))];['eigenvalue=',num2str(value(num_plt(i)),'%.4f')]});
    %plot buckling mode
    tenseg_plot(N+ampli*max(l)*reshape(Ia*Mode(:,num_plt(i))/norm(Mode(:,num_plt(i))),3,[]),C_b,C_s,f1,[],[],title2);
    tenseg_plot_dash(N,C_b,C_s,f1,[],[],title2);
     axis off;
        view(view_vec);
    if saveimg==1
        saveas(gcf,[title,' of ',num2str(num_plt(i)),'.png']);
    end
end

end

