function [ ] = getFig1( in, st, filename )
    load(in);
    Figure = figure('position',[100 0 16*60 8*60],...
        'paperpositionmode','auto',...
        'InvertHardcopy','off',...
        'Color',[1 1 1]);
    AX = axes('Parent',Figure, ... 
        'YMinorTick','on',...
        'YTick',2:3:20,...
        'XTick', 20:1:35,...
        'YMinorGrid','on',...
        'YGrid','on',...
        'XGrid','on',...
        'ZGrid','on',...
        'LineWidth',0.5,...
        'FontSize',24,...
        'FontName','Times');
    ylim(AX,[2 20]);
    xlim(AX,[20 33]);
    box(AX,'on');
    hold(AX,'all');
    
    CL = [0 0.498039215803146 0; 1.0000 0.4000 0; 1.0000 0.8000 0.4000; 1 0 0; 0 0.498039215803146 0; 0.313725501298904 0.313725501298904 0.313725501298904];
    MRK = {'o', 'o', 'square', 'square'};
    
    aa = plot([100 100], [100 100]);
    set(aa(1),'Color',CL(1,:), 'MarkerSize',8,'Marker',MRK{1},'LineStyle', '--','LineWidth',1.5);
    
    [C,h] = contour(P_Heur','ShowText','on','LevelStep',st);
    clabel(C,h,'FontSize',15)
    
    xlabel('$n$','FontSize',27,'FontName','Times','Interpreter','latex');
    ylabel('$m$','FontSize',27,'FontName','Times','Interpreter','latex');
    
    helpers.plotTickLatex2D();
    
    LG = legend(AX,'$\quad m^*$');
    set(LG,'LineWidth',1, 'Location', 'NorthWest','FontName','Times','FontSize',20,'Interpreter','latex');
    
    T = get(gca,'position');
    set(gca,'position',[0.0677083333333333 0.1125 0.919791666666666 0.864583333333333]);
    
    set(LG,'position',[0.859375 0.885416666666666 0.12083333333333 0.0727430979410801]);
    
    xlabh = get(gca,'XLabel');
    set(xlabh,'Position',get(xlabh,'Position') - [0 -0.04*7 0]);
    
    mStar = mOpt;
    aa = plot(20:60,mStar(20:60));
    set(aa(1),'Color',CL(1,:), 'MarkerSize',8,'Marker',MRK{1},'LineStyle', '--','LineWidth',1.5);

    name = strcat(filename{2});
    export_fig(name);
    name = strcat(filename{1});
    export_fig(name);
end
