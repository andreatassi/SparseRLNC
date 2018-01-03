function [ ] = getFig5( in, Xlim, Ylim, Xtick, Ytick, Off, hasLegend, filename, isA )
    load(in);
    len = size(avgRXSim);
    len = len(4);
    
    Y(1:len,1) = squeeze(avgRXSim(2,Off(1),1,:)) - Off(1);
    Y(1:len,2) = squeeze(avgRXTh(2,Off(1),1,:)) - Off(1);
    Y(1:len,3) = squeeze(avgRXSim(2,Off(1),2,:)) - Off(1);
    Y(1:len,4) = squeeze(avgRXTh(2,Off(1),2,:)) - Off(1);
        
    Y(1:len,5) = squeeze(avgRXSim(2,Off(2),1,:)) - Off(2);
    Y(1:len,6) = squeeze(avgRXTh(2,Off(2),1,:)) - Off(2);
    Y(1:len,7) = squeeze(avgRXSim(2,Off(2),2,:)) - Off(2);
    Y(1:len,8) = squeeze(avgRXTh(2,Off(2),2,:)) - Off(2);
    
    Y(1:len,9) = squeeze(avgRXSim(2,Off(3),1,:)) - Off(3);
    Y(1:len,10) = squeeze(avgRXTh(2,Off(3),1,:)) - Off(3);
    Y(1:len,11) = squeeze(avgRXSim(2,Off(3),2,:)) - Off(3);
    Y(1:len,12) = squeeze(avgRXTh(2,Off(3),2,:)) - Off(3);
         
    Xval = [0.01, 0.05:0.05:0.25];
    X = [];
    for x = 1:6
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
    
    Figure = figure('position',[100 0 6.5*60 8*60],...
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
    set(aa(1),'Color',CL(1,:), 'MarkerSize',10,'Marker',MRK{1},'LineStyle', 'none','LineWidth',1.5); % Sim
    aa = plot([10 10], [10 10]);
    set(aa(1),'Color',CL(3,:), 'MarkerSize',10,'Marker',MRK{3},'LineStyle', 'none','LineWidth',1.5);  % Heur
    
    if isA
        PL = plot(X,Y(:,[1,2,5,6,9,10]),...
            'MarkerSize',15,...
            'LineWidth',1);
    else
        PL = plot(X,Y(:,[3,4,7,8,11,12]),...
            'MarkerSize',15,...
            'LineWidth',1);
    end

    xlabel('$\epsilon$','FontSize',27,'FontName','Times','Interpreter','latex');
    ylabel('Avg. Trans. Overhead','FontSize',27,'FontName','Times','Interpreter','latex');
    
    set(PL(1),'Color',CL(1,:), 'MarkerSize',10,'Marker',MRK{1},'LineStyle', '-','LineWidth',1.5); % Sim
    set(PL(2),'Color',CL(3,:), 'MarkerSize',10,'Marker',MRK{3},'LineStyle', '-','LineWidth',1.5);  % Heur
    
    set(PL(3),'Color',CL(1,:), 'MarkerSize',10,'Marker',MRK{1},'LineStyle', '--','LineWidth',1.5); % Sim 
    set(PL(4),'Color',CL(3,:), 'MarkerSize',10,'Marker',MRK{3},'LineStyle', '--','LineWidth',1.5);  % Heur
    
    set(PL(5),'Color',CL(1,:), 'MarkerSize',10,'Marker',MRK{1},'LineStyle', '-.','LineWidth',1.5); % Sim 
    set(PL(6),'Color',CL(3,:), 'MarkerSize',10,'Marker',MRK{3},'LineStyle', '-.','LineWidth',1.5);  % Heur
   
    
    helpers.plotTickLatex2D();

    if hasLegend
        LG = legend(AX,'Simulations', ...
                       '$\mathrm{R}_{K,n}$ approx. as in Theorem 3.1');
        set(LG,'LineWidth',1, 'Location', 'NorthWest','FontName','Times','FontSize',20,'Interpreter','latex');
    end
    
    set(gca,'position',[0.158974358974359 0.0979166666666667 0.787179487179487 0.88125]);
    
    if hasLegend
        set(LG,'position',[0.167515459602131 0.862222018499377 0.821127710586939 0.109375]);
    end

    xlabh = get(gca,'XLabel');
    set(xlabh,'Position',get(xlabh,'Position') - [0 -0.94 0]);

    ylabh = get(gca,'YLabel');
    %set(ylabh,'Position',get(ylabh,'Position') - [-0.04 0 0]);

    name = strcat(filename{1});
    export_fig(name);
    name = strcat(filename{2});
    export_fig(name);
end

