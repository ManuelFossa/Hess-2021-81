%% Plot cwtm
function plot_cwtm(x,ts,type)
% Plots the results of cwtm (see cwtm.m) 
% INPUT: 
% x: a cwtm structure (output of cwtm.m)
% ts: date vector (string)
% type: a character string with the type of cwt plot:
% '1': meer singularity
% '2': meer smooth oscillations
% '3': meer optimized
% '4': morlet
% '5': bicoherence

%% Variables
cwtmr = x;
[d,dt] = formatts(cwtmr.x);
t = d(:,1);

%fig = figure('units','normalized','outerposition',[0 0 1 1]);
%fig.Color = 'white';
%fig.GraphicsSmoothing = 'on';
%fig.Renderer = 'zbuffer';
%title('cwtmr all')

%% Switch
switch type
%% GMW (1)
    case '1'
    title('GMW 1')
    period = seconds(cwtmr.wt1_period)';
    power = cwtmr.wt1_pow;
    sigma2 = cwtmr.sigma2;
    coi = seconds(cwtmr.wt1_coi)';
    Yticks = 2.^(fix(log2(min(period))):fix(log2(max(period))));
    H=imagesc(t,log2(period),log2(abs(power/sigma2)));%#ok,log2(levels));  %*** or use 'contourfill'
    clim=get(gca,'clim'); %center color limits around log2(1)=0
    clim=[-1 1]*max(clim(2),3);
    set(gca,'clim',clim)
    HCB=colorbar;
    set(HCB,'ytick',-7:7);
    barylbls=rats(2.^(get(HCB,'ytick')'));
    barylbls([1 end],:)=' ';
    barylbls(:,all(barylbls==' ',1))=[];
    set(HCB,'yticklabel',barylbls);
    set(gca,'YLim',log2([min(period),max(period)]), ...
        'YDir','reverse', ...
        'YTick',log2(Yticks(:)), ...
        'YTickLabel',num2str(Yticks'), ...
        'layer','top')
    xlabel('Time')
    ylabel('Period')
    hold on
    tt=[t([1 1])-dt*.5;t;t([end end])+dt*.5];
    hcoi=fill(tt,log2([period([end 1]) coi period([1 end])]),'w');
    set(hcoi,'alphadatamapping','direct','facealpha',.5)
    hold off
    set(gca,'box','on','layer','top');

%% GMW (2)
    case '2'
    title('GMW 2');
    period = seconds(cwtmr.wt2_period)';
    power = cwtmr.wt2_pow;
    sigma2 = cwtmr.sigma2;
    coi = seconds(cwtmr.wt1_coi)';
    Yticks = 2.^(fix(log2(min(period))):fix(log2(max(period))));
    H=imagesc(t,log2(period),log2(abs(power/sigma2)));%#ok,log2(levels));  %*** or use 'contourfill'
    clim=get(gca,'clim'); %center color limits around log2(1)=0
    clim=[-1 1]*max(clim(2),3);
    set(gca,'clim',clim)
    HCB=colorbar;
    set(HCB,'ytick',-7:7);
    barylbls=rats(2.^(get(HCB,'ytick')'));
    barylbls([1 end],:)=' ';
    barylbls(:,all(barylbls==' ',1))=[];
    set(HCB,'yticklabel',barylbls);
    set(gca,'YLim',log2([min(period),max(period)]), ...
        'YDir','reverse', ...
        'YTick',log2(Yticks(:)), ...
        'YTickLabel',num2str(Yticks'), ...
        'layer','top')
    xlabel('Time')
    ylabel('Period')
    hold on
    tt=[t([1 1])-dt*.5;t;t([end end])+dt*.5];
    hcoi=fill(tt,log2([period([end 1]) coi period([1 end])]),'w');
    set(hcoi,'alphadatamapping','direct','facealpha',.5)
    hold off
    set(gca,'box','on','layer','top');
%% GMW (3)
    case '3'
    title('GMW 3');
    period = seconds(cwtmr.wt3_period)';
    power = cwtmr.wt3_pow;
    sigma2 = cwtmr.sigma2;
    coi = seconds(cwtmr.wt1_coi)';
    Yticks = 2.^(fix(log2(min(period))):fix(log2(max(period))));
    H=imagesc(t,log2(period),log2(abs(power/sigma2)));%#ok,log2(levels));  %*** or use 'contourfill'
    clim=get(gca,'clim'); %center color limits around log2(1)=0
    clim=[-1 1]*max(clim(2),3);
    set(gca,'clim',clim)
    HCB=colorbar;
    set(HCB,'ytick',-7:7);
    barylbls=rats(2.^(get(HCB,'ytick')'));
    barylbls([1 end],:)=' ';
    barylbls(:,all(barylbls==' ',1))=[];
    set(HCB,'yticklabel',barylbls);
    set(gca,'YLim',log2([min(period),max(period)]), ...
        'YDir','reverse', ...
        'YTick',log2(Yticks(:)), ...
        'YTickLabel',num2str(Yticks'), ...
        'layer','top')
    xlabel('Time')
    ylabel('Period')
    hold on
    tt=[t([1 1])-dt*.5;t;t([end end])+dt*.5];
    hcoi=fill(tt,log2([period([end 1]) coi period([1 end])]),'w');
    set(hcoi,'alphadatamapping','direct','facealpha',.5)
    hold off
    set(gca,'box','on','layer','top');
%% MW (4)
    case '4'
    title('MW 4');
    period = cwtmr.wt4_period;
    power = cwtmr.wt4_pow;
    sigma2 = cwtmr.sigma2;
    sig95 = cwtmr.wt4_signif;
    coi = cwtmr.wt4_coi;
    Yticks = 2.^(fix(log2(min(period))):fix(log2(max(period))));
    H=imagesc(t,log2(period),log2(abs(power/sigma2)));%#ok,log2(levels));  %*** or use 'contourfill'
    clim=get(gca,'clim'); %center color limits around log2(1)=0
    clim=[-1 1]*max(clim(2),3);
	indtick = floor(linspace(1,size(t,1),floor(size(t,1)/10)));
    set(gca,'clim',clim)
    HCB=colorbar;
    set(HCB,'ytick',-7:7);
    barylbls=rats(2.^(get(HCB,'ytick')'));
    barylbls([1 end],:)=' ';
    barylbls(:,all(barylbls==' ',1))=[];
    set(HCB,'yticklabel',barylbls);
    set(gca,'YLim',log2([min(period),max(period)]), ...
        'YDir','reverse', ...
        'YTick',log2(Yticks(:)), ...
        'YTickLabel',num2str(Yticks'), ...
        'layer','top','XTick',indtick,'XTickLabel',ts(indtick,:))
    xlabel('Time')
    ylabel('Period')
    hold on
    [c,h] = contour(t,log2(period),sig95,[1 1],'k'); %#ok
    set(h,'linewidth',2)
    %plot(t,log2(coi),'k','linewidth',3)
    tt=[t([1 1])-dt*.5;t;t([end end])+dt*.5];
    hcoi=fill(tt,log2([period([end 1]) coi period([1 end])]),'w');
    set(hcoi,'alphadatamapping','direct','facealpha',.5)
    hold off
    set(gca,'box','on','layer','top');

%% GMW (5)
    case '5'
    title('GMW 5');
    scale = cwtmr.wt4_period;
    wbi = cwtmr.wt5_wbi;
    sig = cwtmr.wt5_signif;
    imagesc(log2(scale), log2(scale), wbi);
    hold on
    [c h] = contour(log2(scale),log2(scale),flipud(flipud(sig)),[1 1],'k','linewidth',5);

    ct(1,:) = [max(log2(scale)) max(log2(scale))];
    ct(2,:) = [max(log2(scale)) log2(2)];
    ct(3,:) = [1 1];
    ct(4,:) = [max(log2(scale)) max(log2(scale))];
    fill(ct(:,1), ct(:,2),'w');

    colorbar;
    caxis([0 1]);
    ylabel('s_2 ','Fontsize',20);
    xlabel('s_1 ','Fontsize',20);

    Yticks = 2.^(fix(log2(min(scale))):fix(log2(max(scale))));

    set(gca,'YLim',log2([min(scale),max(scale)]), ...
        'XLim',log2([min(scale),max(scale)]), ...
        'YDir','reverse', ...
        'YTick',log2(Yticks(:)), ...
        'YTickLabel',num2str(Yticks'), ...
        'XTick',log2(Yticks(:)), ...
        'XTickLabel',num2str(Yticks'), ...
        'Ydir', 'reverse', ...
        'Xdir', 'reverse', ...
        'layer','top');    %...'PlotBoxAspectRatio',[ 1 1 1]);
%% End Switch
end
 
end       
    
