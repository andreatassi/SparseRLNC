function [ ] = getFig4( inData, Xlim, Ylim, Xtick, Ytick, filename )

load(inData);
Y(1:6,1) = squeeze(pRXSim(2,20,1:6))';
Y(1:6,2) = squeeze(pRXsoa_LB(2,20,1:6))';
Y(1:6,3) = squeeze(pRXsoa_UB(2,20,1:6))';
Y(1:6,4) = squeeze(pRXTh(2,20,1:6))';
Y(1:6,5) = squeeze(pRXSim(2,50,1:6))';
Y(1:6,6) = squeeze(pRXsoa_LB(2,50,1:6))';
Y(1:6,7) = squeeze(pRXsoa_UB(2,50,1:6))';
Y(1:6,8) = squeeze(pRXTh(2,50,1:6))';

Y(1:6,9) = squeeze(pRXSim(16,20,1:6))';
Y(1:6,10) = squeeze(pRXsoa_LB(16,20,1:6))';
Y(1:6,11) = squeeze(pRXsoa_UB(16,20,1:6))';
Y(1:6,12) = squeeze(pRXTh(16,20,1:6))';
Y(1:6,13) = squeeze(pRXSim(16,50,1:6))';
Y(1:6,14) = squeeze(pRXsoa_LB(16,50,1:6))';
Y(1:6,15) = squeeze(pRXsoa_UB(16,50,1:6))';
Y(1:6,16) = squeeze(pRXTh(16,50,1:6))';


Xval = 0.6:0.05:0.85;
X = [];
for x = 1:16
    X = [ X, Xval' ];
end

strIdx = sum(isnan(Y(:,3))) + 1;
MSE(1) = sum((Y(strIdx:end,3) - Y(strIdx:end,1)).^2) / length(Y(strIdx:end,3));
strIdx = sum(isnan(Y(:,6))) + 1;
MSE(2) = sum((Y(strIdx:end,6) - Y(strIdx:end,4)).^2) / length(Y(strIdx:end,6));

strIdx = sum(isnan(Y(:,2))) + 1;
MSE(3) = sum((Y(strIdx:end,2) - Y(strIdx:end,1)).^2) / length(Y(strIdx:end,2));
strIdx = sum(isnan(Y(:,5))) + 1;
MSE(4) = sum((Y(strIdx:end,5) - Y(strIdx:end,4)).^2) / length(Y(strIdx:end,5));
MSE

Figure = figure('position',[100 0 16*60 7.5*60],...
    'paperpositionmode','auto',...
    'InvertHardcopy','off',...
    'Color',[1 1 1]);
AX = axes('Parent',Figure, ...
    'YMinorTick','on',...
    'XTick', Xtick,...
    'YTick', Ytick,...
    'YMinorGrid','on',...
    'YGrid','on',...
    'XGrid','on',...
    'LineWidth',0.5,...
    'FontSize',24,...
    'FontName','Times');
xlim(AX,Xlim);
ylim(AX,Ylim);
box(AX,'on');
hold(AX,'all');

CL = [0 0.498039215803146 0; 1.0000 0.4000 0; 1.0000 0.8000 0.4000; 1 0 0; 0 0.498039215803146 0; 0.313725501298904 0.313725501298904 0.313725501298904];
MRK = {'square','+', 'v','o'};
aa = plot([10 10], [10 10]);
set(aa(1),'Color',CL(1,:), 'MarkerSize',10,'Marker',MRK{1},'LineStyle', '--','LineWidth',1.5); % Sim
aa = plot([10 10], [10 10]);
set(aa(1),'Color',CL(2,:), 'MarkerSize',10,'Marker',MRK{2},'LineStyle', '-.','LineWidth',1.5); % SotA
aa = plot([10 10], [10 10]);
set(aa(1),'Color',CL(4,:), 'MarkerSize',10,'Marker',MRK{4},'LineStyle', '-.','LineWidth',1.5); % SotA
aa = plot([10 10], [10 10]);
set(aa(1),'Color',CL(3,:), 'MarkerSize',10,'Marker',MRK{3},'LineStyle', '-','LineWidth',1.5);  % Heur

PL = plot(X,Y,...
    'MarkerSize',15,...
    'LineWidth',1);

xlabel('$p$','FontSize',27,'FontName','Times','Interpreter','latex');
ylabel('$\mathrm{R}(\epsilon)$','FontSize',27,'FontName','Times','Interpreter','latex');

set(PL(1),'Color',CL(1,:), 'MarkerSize',10,'Marker',MRK{1},'LineStyle', '--','LineWidth',1.5); % Sim
set(PL(2),'Color',CL(2,:), 'MarkerSize',10,'Marker',MRK{2},'LineStyle', '-.','LineWidth',1.5); % SotA
set(PL(3),'Color',CL(4,:), 'MarkerSize',10,'Marker',MRK{4},'LineStyle', '-.','LineWidth',1.5); % SotA
set(PL(4),'Color',CL(3,:), 'MarkerSize',10,'Marker',MRK{3},'LineStyle', '-','LineWidth',1.5);  % Heur

set(PL(5),'Color',CL(1,:), 'MarkerSize',10,'Marker',MRK{1},'LineStyle', '--','LineWidth',1.5); % Sim
set(PL(6),'Color',CL(2,:), 'MarkerSize',10,'Marker',MRK{2},'LineStyle', '-.','LineWidth',1.5); % SotA
set(PL(7),'Color',CL(4,:), 'MarkerSize',10,'Marker',MRK{4},'LineStyle', '-.','LineWidth',1.5); % SotA
set(PL(8),'Color',CL(3,:), 'MarkerSize',10,'Marker',MRK{3},'LineStyle', '-','LineWidth',1.5);  % Heur

set(PL(9),'Color',CL(1,:), 'MarkerSize',10,'Marker',MRK{1},'LineStyle', '--','LineWidth',1.5); % Sim
set(PL(10),'Color',CL(2,:), 'MarkerSize',10,'Marker',MRK{2},'LineStyle', '-.','LineWidth',1.5); % SotA
set(PL(11),'Color',CL(4,:), 'MarkerSize',10,'Marker',MRK{4},'LineStyle', '-.','LineWidth',1.5); % SotA
set(PL(12),'Color',CL(3,:), 'MarkerSize',10,'Marker',MRK{3},'LineStyle', '-','LineWidth',1.5);  % Heur

set(PL(13),'Color',CL(1,:), 'MarkerSize',10,'Marker',MRK{1},'LineStyle', '--','LineWidth',1.5); % Sim
set(PL(14),'Color',CL(2,:), 'MarkerSize',10,'Marker',MRK{2},'LineStyle', '-.','LineWidth',1.5); % SotA
set(PL(15),'Color',CL(4,:), 'MarkerSize',10,'Marker',MRK{4},'LineStyle', '-.','LineWidth',1.5); % SotA
set(PL(16),'Color',CL(3,:), 'MarkerSize',10,'Marker',MRK{3},'LineStyle', '-','LineWidth',1.5);  % Heur

helpers.plotTickLatex2D();

LG = legend(AX,'$\quad$Simulations', ...
    '$\quad\mathrm{R}_{K,n}$ approximated as in (3)', ...
    '$\quad\mathrm{R}_{K,n}$ approximated as in (4)', ...
    '$\quad\mathrm{R}_{K,n}$ approximated as in Theorem 3.1');
set(LG,'LineWidth',1, 'Location', 'NorthWest','FontName','Times','FontSize',20,'Interpreter','latex');

set(gca,'position',[0.08125 0.122916666666667 0.896875 0.667516135155656]);
set(LG,'position',[0.5625 0.764106366924623 0.40874380955174 0.231207289293849]);

xlabh = get(gca,'XLabel');
set(xlabh,'Position',get(xlabh,'Position') - [0 -0.04 0]);

ylabh = get(gca,'YLabel');
set(ylabh,'Position',get(ylabh,'Position') - [-0.001 0 0]);

name = strcat(filename{1});
export_fig(name);
name = strcat(filename{2});
export_fig(name);
end

