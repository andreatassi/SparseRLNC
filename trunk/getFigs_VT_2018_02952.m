%% Th -- [Figs. 0:1] q = 2, 2^4 - Intercept
clearAllMemoizedCaches;
clearvars;
close all;

Kset           = 20;
Nset           = 0:1:20;
Qset           = [2,2^4];
PEPbobSet      = [0.01, 0.05, 0.1];
PEPeveSet      = 0.25;
PEPackSet      = 0:0.05:1;
Pset{Qset(1)}  = 0.5:0.01:0.9;
Pset{Qset(2)}  = [2^(-4):0.02:0.9, 0.9];

CL = [0 0 0; 1.0000 0.4000 0; 1.0000 0.8000 0.4000; 1 0 0; 0 0.498039215803146 0; 0 0.600000023841858 1; 0.313725501298904 0.313725501298904 0.313725501298904];
MRK = {'square','+', 'v','o','^','diamond'};

for q = Qset
    mse = [];
    for k = Kset
        for pepEve = PEPeveSet
        nIdx = k + 1;
        Figure = figure('position',[100 0 8*60 5*60],...
            'paperpositionmode','auto',...
            'InvertHardcopy','off',...
            'Color',[1 1 1]);
        if q == 2
            xT_ = [0.5:0.1:0.9];
        elseif q == 16
            xT_ = [0.1:0.2:0.9];
        end
        zT_ = 0:0.2:1;
        AX = axes('Parent',Figure, ...
            'YMinorTick','on',...
            'XTick', xT_,...
            'YTick', PEPbobSet,...
            'ZTick', zT_,...
            'YMinorGrid','on',...
            'YGrid','on',...
            'XGrid','on',...
            'ZGrid','on',...
            'ZMinorGrid','on',...
            'LineWidth',0.5,...
            'FontSize',24,...
            'TickLabelInterpreter','latex');
        if q == 2
            xlim([0.5,0.9])
        else
            xlim([0.1,0.9])
        end
        ylim([0.01,0.105])
        zlim([0,1])
        box(AX,'on');
        hold(AX,'all');
        xlabel('$p$','FontSize',27,'FontName','Times','Interpreter','latex');
        ylabel('$\epsilon_\mathrm{B}$','FontSize',27,'FontName','Times','Interpreter','latex');
        zlabel('$\mathrm{I}_{\hat{N}}(p)$','FontSize',27,'FontName','Times','Interpreter','latex');
        aa = plot([10 10], [10 10]);
        set(aa(1),'Color',CL(7,:), 'MarkerSize',10,'Marker','none','LineStyle', '-','LineWidth',2.5);
        aa = plot([10 10], [10 10]);
        set(aa(1),'Color',CL(7,:), 'MarkerSize',10,'Marker','none','LineStyle', '-','LineWidth',0.9);
        aa = plot([10 10], [10 10]);
        set(aa(1),'Color',CL(7,:), 'MarkerSize',10,'Marker',MRK{1},'LineStyle', 'none','LineWidth',1.5);
        aa = plot([10 10], [10 10]);
        set(aa(1),'Color',CL(7,:), 'MarkerSize',10,'Marker',MRK{2},'LineStyle', 'none','LineWidth',1.5);
        aa = plot([10 10], [10 10]);
        set(aa(1),'Color',CL(7,:), 'MarkerSize',10,'Marker',MRK{3},'LineStyle', 'none','LineWidth',1.5);
        aa = plot([10 10], [10 10]);
        set(aa(1),'Color',CL(7,:), 'MarkerSize',10,'Marker',MRK{4},'LineStyle', 'none','LineWidth',1.5);
        aa = plot([10 10], [10 10]);
        set(aa(1),'Color',CL(7,:), 'MarkerSize',10,'Marker',MRK{5},'LineStyle', 'none','LineWidth',1.5);
        aa = plot([10 10], [10 10]);
        set(aa(1),'Color',CL(7,:), 'MarkerSize',10,'Marker',MRK{6},'LineStyle', 'none','LineWidth',1.5);
        
        PL = [];
        for pepBob = PEPbobSet
%             if pepBob ~= 0.1
%                 continue
%             end
                Nset_tmp = k + Nset;
                tmpLenN = length(Nset_tmp);
                tmpLenP = length(Pset{q});
                tmpLenAck = length(PEPackSet);
                interceptProb = NaN * ones(tmpLenP,tmpLenN,tmpLenAck);
                decProb = NaN * ones(tmpLenP,tmpLenN,tmpLenAck);
                
                sSet_ = [1, 11, 18:21];
                for pACK = sSet_
                    fileTag = 'data/SIM-';
                    fileTag = strcat( fileTag, num2str(q), '-', num2str(k), '-', num2str(pepBob), '-', num2str(pepBob + pepEve) );
                    load( strcat(fileTag, '.mat'));
                    
                    col = CL(find(sSet_ == pACK),:);
                    ln = '-';
                    
                    pIt = 1;
                    y_ = pepBob * ones(1,length(Pset{q}));
                    try
                    aa = plot3(Pset{q},y_,[nan;interceptProb_th(2:end,nIdx,pACK)]);
                    catch
                        aaaa = 1;
                    end
                    set(aa,'Color',col, 'MarkerSize',10,'Marker','none','LineStyle', ln,'LineWidth',2.5);
                    PL = [PL; aa];
                    aa = plot3(Pset{q},y_,[nan;interceptProb_sim(2:end,nIdx,pACK)]);
                    set(aa,'Color',col, 'MarkerSize',10,'Marker','none','LineStyle', '-','LineWidth',0.9);
                    PL = [PL; aa];
                    
                    if q == 2
                        mse = [mse; mean((interceptProb_th(6:end,nIdx,4) - interceptProb_sim(6:end,nIdx,4)).^2)];
                    end
                    
                end
        end
        helpers.plotsparsemarkers3D(PL,false,{MRK{1},MRK{1},MRK{2},MRK{2},MRK{3},MRK{3},MRK{4},MRK{4},MRK{5},MRK{5},MRK{6},MRK{6}, ...
                                              MRK{1},MRK{1},MRK{2},MRK{2},MRK{3},MRK{3},MRK{4},MRK{4},MRK{5},MRK{5},MRK{6},MRK{6}, ...
                                              MRK{1},MRK{1},MRK{2},MRK{2},MRK{3},MRK{3},MRK{4},MRK{4},MRK{5},MRK{5},MRK{6},MRK{6}},3,false,8*ones(1,3*12));
        %helpers.plotTickLatex2D('xposfix',0.035);
        
        set(gca,'position',[0.162660531843844 0.170256863365257 0.749631134822823 0.823079114824853]);
        view(AX,[-119.2 7.6]);
        xlabh = get(gca,'XLabel');
        set(xlabh,'Position',get(xlabh,'Position') - [0 0 -0.04]);
        ylabh = get(gca,'YLabel');
        set(ylabh,'Position',get(ylabh,'Position') - [0 0 -0.16]);
        if (q == 16)
            LG = legend(AX,'Theory','Simul.','$\epsilon_\mathrm{K} = 0$', '$\epsilon_\mathrm{K} = 0.5$', '$\epsilon_\mathrm{K} = 0.85$','$\epsilon_\mathrm{K} = 0.9$','$\epsilon_\mathrm{K} = 0.95$','$\epsilon_\mathrm{K} = 1$');
            set(LG,...
                'Position',[0.783218034217134 0.394508914848174 0.21389962832133 0.505],...
                'LineWidth',1,...
                'Interpreter','latex',...
                'FontSize',15);
        end
        fn = strcat('val-', num2str(k), '-', num2str(q), '-', num2str(100*pepEve))
        export_fig(strcat('./doc/img/eps/',fn,'.eps'));
        export_fig(strcat('./doc/img/pdf/',fn,'.pdf'));
        end
    end
end

%% Th -- [Figs. 2:end] q = 2, 2^4, PEPbob = 0.1, PEPeve = 0.15, 0.25
clearAllMemoizedCaches;
clearvars;
close all;

Kset           = [5, 20];
Nset           = 0:1:70;
Qset           = [2,2^4];
PEPbobSet      = 0.05;
PEPeveSet      = [0.15,0.25];
PEPackSet      = [0.85:0.05:1];
Pset{Qset(1)}  = 0.5:0.01:0.9;
Pset{Qset(2)}  = 2^(-4):0.02:0.9;
Rb             = 0.9;
profNo         = 1;

CL = [0 0.498039215803146 0; 1.0000 0.4000 0; 1.0000 0.8000 0.4000; 1 0 0; 0 0.498039215803146 0; 0.313725501298904 0.313725501298904 0.313725501298904];
MRK = {'square','+', 'v','o','^','diamond'};


for pepBob = PEPbobSet
    for pepEve = pepBob + PEPeveSet
        for k = Kset
            Nset_tmp = k + Nset;
            tmpLenN = length(Nset_tmp);
            
            if k == 5
                Figure = figure('position',[100 0 8*60 5*60],...
                    'paperpositionmode','auto',...
                    'InvertHardcopy','off',...
                    'Color',[1 1 1]);
                xT_ = unique([5:10:90, 90]);
                AX = axes('Parent',Figure, ...
                    'YMinorTick','on',...
                    'YTick',0.1:0.1:0.5,...
                    'XTick', xT_,...
                    'YMinorGrid','on',...
                    'YGrid','on',...
                    'XGrid','on',...
                    'ZGrid','on',...
                    'LineWidth',0.5,...
                    'FontSize',24,...
                    'FontName','Times');
                if k == 5
                    xlim([k,5*k])
                    ylim([0,0.401])
                elseif k == 20
                    xlim([k,90])
                    ylim([0,0.5])
                end
            end
            xlim([5,75])
            ylim([0,0.5])
            box(AX,'on');
            hold(AX,'all');
            xlabel('$\hat{N}$','FontSize',27,'FontName','Times','Interpreter','latex');
            ylabel('$\mathrm{I}_{\hat{N}}(1/q) - \mathrm{I}_{\hat{N}}(p^\star)$','FontSize',27,'FontName','Times','Interpreter','latex');
            aa = plot([10 10], [10 10]);
            set(aa(1),'Color',CL(1,:), 'MarkerSize',10,'Marker','none','LineStyle', '-','LineWidth',1.5);
            aa = plot([10 10], [10 10]);
            set(aa(1),'Color',CL(2,:), 'MarkerSize',10,'Marker','none','LineStyle', '-.','LineWidth',1.5);
            aa = plot([10 10], [10 10]);
            set(aa(1),'Color',CL(6,:), 'MarkerSize',10,'Marker',MRK{1},'LineStyle', 'none','LineWidth',1.5);
            aa = plot([10 10], [10 10]);
            set(aa(1),'Color',CL(6,:), 'MarkerSize',10,'Marker',MRK{2},'LineStyle', 'none','LineWidth',1.5);
            aa = plot([10 10], [10 10]);
            set(aa(1),'Color',CL(6,:), 'MarkerSize',10,'Marker',MRK{3},'LineStyle', 'none','LineWidth',1.5);
            aa = plot([10 10], [10 10]);
            set(aa(1),'Color',CL(6,:), 'MarkerSize',10,'Marker',MRK{4},'LineStyle', 'none','LineWidth',1.5);
            
            PL = [];
            for q = Qset
                tmpLenP = length(Pset{q});
                tmpLenAck = length(PEPackSet);
                interceptProb = NaN * ones(tmpLenP,tmpLenN,tmpLenAck);
                decProb = NaN * ones(tmpLenP,tmpLenN,tmpLenAck);
                sSet_ = 1:4;
                if q == 2
                    col = CL(1,:);
                    mkr = MRK{1};
                    ln = '-';
                else
                    col = CL(2,:);
                    mkr = MRK{4};
                    ln = '-.';
                end
                for pACK = sSet_
                    fileTag = 'data/TH-';
                    fileTag = strcat( fileTag, num2str(profNo), '-', num2str(q), '-', num2str(k), '-', num2str(pepBob), '-', num2str(pepEve), '-', num2str(Rb) );
                    load( strcat(fileTag, '.mat'));
                    
                    if q ~= 2
                        pOpt_th(:,pACK)
                    end
                    
                    pIt = 1;
                    tmp__ = interceptProbNOpt_Sim(:,pACK) - interceptProbOpt_Sim(:,pACK);
                    aa = plot(Nset_tmp, tmp__(1:(max(Nset)+1)));
                    if k == 5
                        lW = 0.8;
                    else
                        lW = 2;
                    end
                    set(aa,'Color',col, 'MarkerSize',10,'Marker','none','LineStyle', ln,'LineWidth',lW);
                    PL = [PL; aa];
                end
            end
            helpers.plotsparsemarkers(PL,false,{MRK{1},MRK{2},MRK{3},MRK{4},MRK{1},MRK{2},MRK{3},MRK{4}},15,false,8*ones(1,8));
            helpers.plotTickLatex2D();
            
            set(gca,'position',[0.145833333333333 0.14 0.83125 0.823333333333333]);
            xlabh = get(gca,'XLabel');
            if k == 5
                set(xlabh,'Position',get(xlabh,'Position') - [0 -0.01 0]);
            elseif k == 20
                set(xlabh,'Position',get(xlabh,'Position') - [0 -0.011 0]);
            end
            if (k == 20 && pepEve == 0.20)
                LG = legend(AX,'$q = 2$','$q = 2^4$','$\epsilon_\mathrm{K} = 0.85$','$\epsilon_\mathrm{K} = 0.9$','$\epsilon_\mathrm{K} = 0.95$','$\epsilon_\mathrm{K} = 1$');
                set(LG,...
                    'Position',[0.683333333333334 0.496805568159457 0.256727282206217 0.501666666666667],...
                    'LineWidth',1,...
                    'Interpreter','latex',...
                    'FontSize',20);
            end
        end
        fn = strcat('th-', num2str(k), '-', num2str(100*pepBob), '-', num2str(100*pepEve));
        export_fig(strcat('./doc/img/eps/',fn,'.eps'));
        export_fig(strcat('./doc/img/pdf/',fn,'.pdf'));
        %error('AA')
    end
end

%% Th -- [Figs. 2:end] q = 2, 2^4, PEPbob = 0.1, PEPeve = 0.15, 0.25
clearAllMemoizedCaches;
clearvars;
close all;

Kset           = [5, 20];
Nset           = 0:1:75;
Qset           = [2,2^4];
PEPbobSet      = 0.1;
PEPeveSet      = [0.15,0.25];
PEPackSet      = [0.5, 0.6:0.05:1];
Pset{Qset(1)}  = 0.5:0.01:0.9;
Pset{Qset(2)}  = 2^(-4):0.02:0.9;
Rb             = 0.9;
profNo         = 1;

CL = [0 0.498039215803146 0; 1.0000 0.4000 0; 1.0000 0.8000 0.4000; 1 0 0; 0 0.498039215803146 0; 0.313725501298904 0.313725501298904 0.313725501298904];
MRK = {'square','+', 'v','o','^','diamond'};


for pepBob = PEPbobSet
    for pepEve = pepBob + PEPeveSet
        for k = Kset
            Nset_tmp = k + Nset;
            tmpLenN = length(Nset_tmp);
            
            if k == 5
                Figure = figure('position',[100 0 8*60 5*60],...
                    'paperpositionmode','auto',...
                    'InvertHardcopy','off',...
                    'Color',[1 1 1]);
                xT_ = unique([5:10:90, 90]);
                AX = axes('Parent',Figure, ...
                    'YMinorTick','on',...
                    'YTick',0.1:0.1:0.5,...
                    'XTick', xT_,...
                    'YMinorGrid','on',...
                    'YGrid','on',...
                    'XGrid','on',...
                    'ZGrid','on',...
                    'LineWidth',0.5,...
                    'FontSize',24,...
                    'FontName','Times');
                if k == 5
                    xlim([k,5*k])
                    ylim([0,0.401])
                elseif k == 20
                    xlim([k,90])
                    ylim([0,0.5])
                end
            end
            xlim([5,75])
            ylim([0,0.5])
            box(AX,'on');
            hold(AX,'all');
            xlabel('$\hat{N}$','FontSize',27,'FontName','Times','Interpreter','latex');
            ylabel('$\mathrm{I}_{\hat{N}}(1/q) - \mathrm{I}_{\hat{N}}(p^\star)$','FontSize',27,'FontName','Times','Interpreter','latex');
            aa = plot([10 10], [10 10]);
            set(aa(1),'Color',CL(1,:), 'MarkerSize',10,'Marker','none','LineStyle', '-','LineWidth',1.5);
            aa = plot([10 10], [10 10]);
            set(aa(1),'Color',CL(2,:), 'MarkerSize',10,'Marker','none','LineStyle', '-.','LineWidth',1.5);
            aa = plot([10 10], [10 10]);
            set(aa(1),'Color',CL(6,:), 'MarkerSize',10,'Marker',MRK{1},'LineStyle', 'none','LineWidth',1.5);
            aa = plot([10 10], [10 10]);
            set(aa(1),'Color',CL(6,:), 'MarkerSize',10,'Marker',MRK{2},'LineStyle', 'none','LineWidth',1.5);
            aa = plot([10 10], [10 10]);
            set(aa(1),'Color',CL(6,:), 'MarkerSize',10,'Marker',MRK{3},'LineStyle', 'none','LineWidth',1.5);
            aa = plot([10 10], [10 10]);
            set(aa(1),'Color',CL(6,:), 'MarkerSize',10,'Marker',MRK{4},'LineStyle', 'none','LineWidth',1.5);
            
            PL = [];
            for q = Qset
                tmpLenP = length(Pset{q});
                tmpLenAck = length(PEPackSet);
                interceptProb = NaN * ones(tmpLenP,tmpLenN,tmpLenAck);
                decProb = NaN * ones(tmpLenP,tmpLenN,tmpLenAck);
                sSet_ = 7:10;
                if q == 2
                    col = CL(1,:);
                    mkr = MRK{1};
                    ln = '-';
                else
                    col = CL(2,:);
                    mkr = MRK{4};
                    ln = '-.';
                end
                for pACK = sSet_
                    fileTag = 'data/TH-';
                    fileTag = strcat( fileTag, num2str(profNo), '-', num2str(q), '-', num2str(k), '-', num2str(pepBob), '-', num2str(pepEve), '-', num2str(Rb) );
                    load( strcat(fileTag, '.mat'));
                    
                    if q ~= 2
                        pOpt_th(:,pACK)
                    end
                    
                    pIt = 1;
                    tmp__ = interceptProbNOpt_Sim(:,pACK) - interceptProbOpt_Sim(:,pACK);
                    aa = plot(Nset_tmp, tmp__(1:(max(Nset)+1)));
                    if k == 5
                        lW = 0.8;
                    else
                        lW = 2;
                    end
                    set(aa,'Color',col, 'MarkerSize',10,'Marker','none','LineStyle', ln,'LineWidth',lW);
                    PL = [PL; aa];
                end
            end
            helpers.plotsparsemarkers(PL,false,{MRK{1},MRK{2},MRK{3},MRK{4},MRK{1},MRK{2},MRK{3},MRK{4}},15,false,8*ones(1,8));
            helpers.plotTickLatex2D();
            
            set(gca,'position',[0.145833333333333 0.14 0.83125 0.823333333333333]);
            xlabh = get(gca,'XLabel');
            if k == 5
                set(xlabh,'Position',get(xlabh,'Position') - [0 -0.01 0]);
            elseif k == 20
                set(xlabh,'Position',get(xlabh,'Position') - [0 -0.011 0]);
            end
        end
        fn = strcat('th-', num2str(k), '-', num2str(100*pepBob), '-', num2str(100*pepEve));
        export_fig(strcat('./doc/img/eps/',fn,'.eps'));
        export_fig(strcat('./doc/img/pdf/',fn,'.pdf'));
        %error('AA')
    end
end

%% Th -- [Figs. 0:1] q = 2, 2^4 - Intercept Validation For R1 only.
clearAllMemoizedCaches;
clearvars;
close all;

Kset           = [15, 20];
Nset           = 0:1:20;
Qset           = [2,2^4];
PEPbobSet      = [0.01, 0.05, 0.1];
PEPeveSet      = [0.15, 0.25];
PEPackSet      = 0:0.05:1;
Pset{Qset(1)}  = 0.5:0.01:0.9;
Pset{Qset(2)}  = [2^(-4):0.02:0.9, 0.9];

CL = [0 0 0; 1.0000 0.4000 0; 1.0000 0.8000 0.4000; 1 0 0; 0 0.498039215803146 0; 0 0.600000023841858 1; 0.313725501298904 0.313725501298904 0.313725501298904];
MRK = {'square','+', 'v','o','^','diamond'};

for q = Qset
    for k = Kset
        for pepEve = PEPeveSet
        nIdx = k + 1;
        Figure = figure('position',[100 0 8*60 5*60],...
            'paperpositionmode','auto',...
            'InvertHardcopy','off',...
            'Color',[1 1 1]);
        if q == 2
            xT_ = [0.5:0.1:0.9];
        elseif q == 16
            xT_ = [0.1:0.2:0.9];
        end
        zT_ = 0:0.2:1;
        AX = axes('Parent',Figure, ...
            'YMinorTick','on',...
            'XTick', xT_,...
            'YTick', PEPbobSet,...
            'ZTick', zT_,...
            'YMinorGrid','on',...
            'YGrid','on',...
            'XGrid','on',...
            'ZGrid','on',...
            'ZMinorGrid','on',...
            'LineWidth',0.5,...
            'FontSize',24,...
            'TickLabelInterpreter','latex');
        if q == 2
            xlim([0.5,0.9])
        else
            xlim([0.1,0.9])
        end
        ylim([0.01,0.105])
        zlim([0,1])
        box(AX,'on');
        hold(AX,'all');
        xlabel('$p$','FontSize',27,'FontName','Times','Interpreter','latex');
        ylabel('$\epsilon_\mathrm{B}$','FontSize',27,'FontName','Times','Interpreter','latex');
        zlabel('$\mathrm{I}_{\hat{N}}(p)$','FontSize',27,'FontName','Times','Interpreter','latex');
        aa = plot([10 10], [10 10]);
        set(aa(1),'Color',CL(7,:), 'MarkerSize',10,'Marker','none','LineStyle', '-','LineWidth',2.5);
        aa = plot([10 10], [10 10]);
        set(aa(1),'Color',CL(7,:), 'MarkerSize',10,'Marker','none','LineStyle', '-','LineWidth',0.9);
        aa = plot([10 10], [10 10]);
        set(aa(1),'Color',CL(7,:), 'MarkerSize',10,'Marker',MRK{1},'LineStyle', 'none','LineWidth',1.5);
        aa = plot([10 10], [10 10]);
        set(aa(1),'Color',CL(7,:), 'MarkerSize',10,'Marker',MRK{2},'LineStyle', 'none','LineWidth',1.5);
        aa = plot([10 10], [10 10]);
        set(aa(1),'Color',CL(7,:), 'MarkerSize',10,'Marker',MRK{3},'LineStyle', 'none','LineWidth',1.5);
        aa = plot([10 10], [10 10]);
        set(aa(1),'Color',CL(7,:), 'MarkerSize',10,'Marker',MRK{4},'LineStyle', 'none','LineWidth',1.5);
        aa = plot([10 10], [10 10]);
        set(aa(1),'Color',CL(7,:), 'MarkerSize',10,'Marker',MRK{5},'LineStyle', 'none','LineWidth',1.5);
        aa = plot([10 10], [10 10]);
        set(aa(1),'Color',CL(7,:), 'MarkerSize',10,'Marker',MRK{6},'LineStyle', 'none','LineWidth',1.5);
        
        PL = [];
        for pepBob = PEPbobSet
%             if pepBob ~= 0.1
%                 continue
%             end
                Nset_tmp = k + Nset;
                tmpLenN = length(Nset_tmp);
                tmpLenP = length(Pset{q});
                tmpLenAck = length(PEPackSet);
                interceptProb = NaN * ones(tmpLenP,tmpLenN,tmpLenAck);
                decProb = NaN * ones(tmpLenP,tmpLenN,tmpLenAck);
                
                sSet_ = [1, 11, 18:21];
                for pACK = sSet_
                    fileTag = 'data/SIM-';
                    fileTag = strcat( fileTag, num2str(q), '-', num2str(k), '-', num2str(pepBob), '-', num2str(pepBob + pepEve) );
                    load( strcat(fileTag, '.mat'));
                    
                    col = CL(find(sSet_ == pACK),:);
                    ln = '-';
                    
                    pIt = 1;
                    y_ = pepBob * ones(1,length(Pset{q}));
                    aa = plot3(Pset{q},y_,[nan;interceptProb_th(2:end,nIdx,pACK)]);
                    set(aa,'Color',col, 'MarkerSize',10,'Marker','none','LineStyle', ln,'LineWidth',2.5);
                    PL = [PL; aa];
                    aa = plot3(Pset{q},y_,[nan;interceptProb_sim(2:end,nIdx,pACK)]);
                    set(aa,'Color',col, 'MarkerSize',10,'Marker','none','LineStyle', '-','LineWidth',0.9);
                    PL = [PL; aa];
                    
                    if q == 2
                        mean((interceptProb_th(6:end,nIdx,4) - interceptProb_sim(6:end,nIdx,4)).^2)
                    end
                    
                end
        end
        helpers.plotsparsemarkers3D(PL,false,{MRK{1},MRK{1},MRK{2},MRK{2},MRK{3},MRK{3},MRK{4},MRK{4},MRK{5},MRK{5},MRK{6},MRK{6}, ...
                                              MRK{1},MRK{1},MRK{2},MRK{2},MRK{3},MRK{3},MRK{4},MRK{4},MRK{5},MRK{5},MRK{6},MRK{6}, ...
                                              MRK{1},MRK{1},MRK{2},MRK{2},MRK{3},MRK{3},MRK{4},MRK{4},MRK{5},MRK{5},MRK{6},MRK{6}},3,false,8*ones(1,3*12));
        %helpers.plotTickLatex2D('xposfix',0.035);
        
        set(gca,'position',[0.162660531843844 0.170256863365257 0.749631134822823 0.823079114824853]);
        view(AX,[-119.2 7.6]);
        xlabh = get(gca,'XLabel');
        set(xlabh,'Position',get(xlabh,'Position') - [0 0 -0.04]);
        ylabh = get(gca,'YLabel');
        set(ylabh,'Position',get(ylabh,'Position') - [0 0 -0.16]);
        if (q == 16 && k == 20 && pepEve == 0.25)
            LG = legend(AX,'Theory','Simul.','$\epsilon_\mathrm{K} = 0$', '$\epsilon_\mathrm{K} = 0.5$', '$\epsilon_\mathrm{K} = 0.85$','$\epsilon_\mathrm{K} = 0.9$','$\epsilon_\mathrm{K} = 0.95$','$\epsilon_\mathrm{K} = 1$');
            set(LG,...
                'Position',[0.783218034217134 0.394508914848174 0.21389962832133 0.505],...
                'LineWidth',1,...
                'Interpreter','latex',...
                'FontSize',15);
        end
        fn = strcat('val-', num2str(k), '-', num2str(q), '-', num2str(100*pepEve))
        export_fig(strcat('./doc/img/eps/',fn,'.eps'));
        export_fig(strcat('./doc/img/pdf/',fn,'.pdf'));
        end
    end
end

%%
close all
