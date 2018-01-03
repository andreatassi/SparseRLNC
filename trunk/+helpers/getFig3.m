function [ ] = getFig3( inSim1, inSim2, inSim3, inSim4, inTh1, inTh2, inTh3, inTh4, inIA1, inIA2, inIA3, inIA4, Xlim, Ylim, Xtick, Ytick, Off, hasLegend, filename, isLB )
    Y = ones(500,6);
    
    load(inSim1);
    Y(1:length(pFullRank_Sim),1) = pFullRank_Sim;
    load(inTh1);
    Y(1:length(pFullRank_Th),4) = pFullRank_Th;
    load(inIA1);
    Y(1:length(pFullRank_soa_UB),2) = pFullRank_soa_LB;
    Y(1:length(pFullRank_soa_UB),3) = pFullRank_soa_UB;
    
    load(inSim2);
    Y(1:length(pFullRank_Sim),5) = pFullRank_Sim;
    load(inTh2);
    Y(1:length(pFullRank_Th),8) = pFullRank_Th;
    load(inIA2);
    Y(1:length(pFullRank_soa_UB),6) = pFullRank_soa_LB;
    Y(1:length(pFullRank_soa_UB),7) = pFullRank_soa_UB;
    
    load(inSim3);
    Y(1:length(pFullRank_Sim),9) = pFullRank_Sim;
    load(inTh3);
    Y(1:length(pFullRank_Th),12) = pFullRank_Th;
    load(inIA3);
    Y(1:length(pFullRank_soa_UB),10) = pFullRank_soa_LB;
    Y(1:length(pFullRank_soa_UB),11) = pFullRank_soa_UB;
    
    load(inSim4);
    Y(1:length(pFullRank_Sim),13) = pFullRank_Sim;
    load(inTh4);
    Y(1:length(pFullRank_Th),16) = pFullRank_Th;
    load(inIA4);
    Y(1:length(pFullRank_soa_UB),14) = pFullRank_soa_LB;
    Y(1:length(pFullRank_soa_UB),15) = pFullRank_soa_UB;
    
    Xval = 1:length(pFullRank_Sim);
    X = [];
    for x = 1:16
        if x <= 4
            X = [ X, Xval' - Off(1) ];
        elseif x >= 5 && x <= 8
            X = [ X, Xval' - Off(2) ];
        elseif x >= 9 && x <= 12
            X = [ X, Xval' - Off(1) ];
        elseif x >= 13 && x <= 16
            X = [ X, Xval' - Off(2) ];
        end
    end
    
    strIdx = Off(1);
    End_ = Off(1) + Xlim(2);
    MSE(1,1) = sum((Y(strIdx:End_,4) - Y(strIdx:End_,1)).^2) / length(Y(strIdx:End_,4)); % TH
    MSE(1,2) = sum((Y(strIdx:End_,2) - Y(strIdx:End_,1)).^2) / length(Y(strIdx:End_,2)); % LB
    MSE(1,3) = sum((Y(strIdx:End_,3) - Y(strIdx:End_,1)).^2) / length(Y(strIdx:End_,3)); % UB
    
    strIdx = Off(2);
    End_ = Off(2) + Xlim(2);
    MSE(2,1) = sum((Y(strIdx:End_,8) - Y(strIdx:End_,5)).^2) / length(Y(strIdx:End_,8)); % TH
    MSE(2,2) = sum((Y(strIdx:End_,6) - Y(strIdx:End_,5)).^2) / length(Y(strIdx:End_,6)); % LB
    MSE(2,3) = sum((Y(strIdx:End_,7) - Y(strIdx:End_,5)).^2) / length(Y(strIdx:End_,7)); % UB
    
    strIdx = Off(1);
    End_ = Off(1) + Xlim(2);
    MSE(3,1) = sum((Y(strIdx:End_,12) - Y(strIdx:End_,9)).^2) / length(Y(strIdx:End_,12)); % TH
    MSE(3,2) = sum((Y(strIdx:End_,10) - Y(strIdx:End_,9)).^2) / length(Y(strIdx:End_,10)); % LB
    MSE(3,3) = sum((Y(strIdx:End_,11) - Y(strIdx:End_,9)).^2) / length(Y(strIdx:End_,11)); % UB
    
    strIdx = Off(2);
    End_ = Off(2) + Xlim(2);
    MSE(4,1) = sum((Y(strIdx:End_,16) - Y(strIdx:End_,13)).^2) / length(Y(strIdx:End_,16)); % TH
    MSE(4,2) = sum((Y(strIdx:End_,14) - Y(strIdx:End_,13)).^2) / length(Y(strIdx:End_,14)); % LB
    MSE(4,3) = sum((Y(strIdx:End_,15) - Y(strIdx:End_,13)).^2) / length(Y(strIdx:End_,15)); % UB
    MSE
    
    Figure = figure('position',[100 0 16*60 6*60],...
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
    set(aa(1),'Color',CL(4,:), 'MarkerSize',10,'Marker','none','LineStyle', '--','LineWidth',1.5); % SotA
    aa = plot([10 10], [10 10]);
    set(aa(1),'Color',CL(4,:), 'MarkerSize',10,'Marker','none','LineStyle', '-.','LineWidth',1.5);  % Heur
    
    aa = plot([10 10], [10 10]);
    set(aa(1),'Color',CL(1,:), 'MarkerSize',10,'Marker',MRK{1},'LineStyle', 'none','LineWidth',1.5); % Sim
    aa = plot([10 10], [10 10]);
    set(aa(1),'Color',CL(2,:), 'MarkerSize',10,'Marker',MRK{2},'LineStyle', 'none','LineWidth',1.5); % SotA
    aa = plot([10 10], [10 10]);
    set(aa(1),'Color',CL(2,:), 'MarkerSize',10,'Marker',MRK{4},'LineStyle', 'none','LineWidth',1.5); % SotA
    aa = plot([10 10], [10 10]);
    set(aa(1),'Color',CL(3,:), 'MarkerSize',10,'Marker',MRK{3},'LineStyle', 'none','LineWidth',1.5);  % Heur

    PL = plot(X,Y,...
        'MarkerSize',15,...
        'LineWidth',1);

    xlabel('$N - K$','FontSize',27,'FontName','Times','Interpreter','latex');
    ylabel('$\mathrm{R}(\epsilon)$','FontSize',27,'FontName','Times','Interpreter','latex');
    
    set(PL(1),'Color',CL(1,:), 'MarkerSize',10,'Marker',MRK{1},'LineStyle', '-.','LineWidth',1.5); % Sim
    set(PL(2),'Color',CL(2,:), 'MarkerSize',10,'Marker',MRK{2},'LineStyle', '-.','LineWidth',1.5); % SotA
    set(PL(3),'Color',CL(2,:), 'MarkerSize',10,'Marker',MRK{4},'LineStyle', '-.','LineWidth',1.5); % SotA
    set(PL(4),'Color',CL(3,:), 'MarkerSize',10,'Marker',MRK{3},'LineStyle', '-.','LineWidth',1.5);  % Heur
    
    set(PL(5),'Color',CL(1,:), 'MarkerSize',10,'Marker',MRK{1},'LineStyle', '--','LineWidth',1.5); % Sim 
    set(PL(6),'Color',CL(2,:), 'MarkerSize',10,'Marker',MRK{2},'LineStyle', '--','LineWidth',1.5); % SotA
    set(PL(7),'Color',CL(2,:), 'MarkerSize',10,'Marker',MRK{4},'LineStyle', '--','LineWidth',1.5); % SotA
    set(PL(8),'Color',CL(3,:), 'MarkerSize',10,'Marker',MRK{3},'LineStyle', '--','LineWidth',1.5);  % Heur
    
    set(PL(9),'Color',CL(1,:), 'MarkerSize',10,'Marker',MRK{1},'LineStyle', '-.','LineWidth',1.5); % Sim
    set(PL(10),'Color',CL(2,:), 'MarkerSize',10,'Marker',MRK{2},'LineStyle', '-.','LineWidth',1.5); % SotA
    set(PL(11),'Color',CL(2,:), 'MarkerSize',10,'Marker',MRK{4},'LineStyle', '-.','LineWidth',1.5); % SotA
    set(PL(12),'Color',CL(3,:), 'MarkerSize',10,'Marker',MRK{3},'LineStyle', '-.','LineWidth',1.5);  % Heur
    
    set(PL(13),'Color',CL(1,:), 'MarkerSize',10,'Marker',MRK{1},'LineStyle', '--','LineWidth',1.5); % Sim 
    set(PL(14),'Color',CL(2,:), 'MarkerSize',10,'Marker',MRK{2},'LineStyle', '--','LineWidth',1.5); % SotA
    set(PL(15),'Color',CL(2,:), 'MarkerSize',10,'Marker',MRK{4},'LineStyle', '--','LineWidth',1.5); % SotA
    set(PL(16),'Color',CL(3,:), 'MarkerSize',10,'Marker',MRK{3},'LineStyle', '--','LineWidth',1.5);  % Heur
    
    helpers.plotTickLatex2D();

    if hasLegend
        LG = legend(AX,'$K = 20$', '$K = 50$','$\quad$Simulations', ...
                       '$\quad\mathrm{R}_{K,n}$ approximated as in (3)', ...
                       '$\quad\mathrm{R}_{K,n}$ approximated as in (4)', ...
                       '$\quad\mathrm{R}_{K,n}$ approximated as in Theorem 3.1');
        set(LG,'LineWidth',1, 'Location', 'NorthWest','FontName','Times','FontSize',20,'Interpreter','latex');
    end
    
    set(gca,'position',[0.08125 0.122916666666667 0.90625 0.846527777777778]);
    
    if hasLegend
        set(LG,'position',[0.573958333333333 0.134458685914676 0.408720920733519 0.418055555555556]);
    end

    xlabh = get(gca,'XLabel');
    set(xlabh,'Position',get(xlabh,'Position') - [0 -0.02 0]);

    ylabh = get(gca,'YLabel');
    set(ylabh,'Position',get(ylabh,'Position') - [-0.04 0 0]);

    name = strcat(filename{1});
    export_fig(name);
    name = strcat(filename{2});
    export_fig(name);
end

