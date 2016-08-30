%%VER COEFICIENTES%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PAINEL FORNTAL%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
h66=figure('units','normalized',...
    'position',[0.2,0.2,0.5,0.7],...
    'menubar','none',...
    'numbertitle','off',...
    'color','white',...
    'deletefcn','set(h6verescala,''enable'',''on'');clear h66* f66* v66*');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%AXES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

h66axescwtint=axes('units','normalized',...
    'position',[0.1,0.1,0.85,0.85],...
    'fontsize',8,...
    'fontname','arial');
    axis([0 1 0 1]);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%FUNCTION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

v66t=0:1/fs:(length(v6signal)-1)/fs;
v66escmin=str2double(get(h6escalamin,'string'));
v66escint=str2double(get(h6escalaint,'string'));
v66escmax=str2double(get(h6escalamax,'string'));
switch get(h6verescalaradio,'value')
    case 1
        set(h66,'name','Coeficientes da escala')
        v66escala=str2double(get(h6verescalavalue,'string'));
        v66escalaind=round((v66escala-v66escmin)/v66escint)+1;
        axes(h66axescwtint);
        v66escplot=plot(v66t,v6cwt(v66escalaind,:));
        axis tight
        grid on
        xlabel('Tempo [s]')
        ylabel('Coeficientes')
        title(strcat('Coeficientes na escala', sprintf('\t %5.2f',v66escala)));
    case 0
        set(h66,'name','Coeficientes no tempo')
        v66tempo=str2double(get(h6vertempovalue,'string'));
        v66tempoind=round(v66tempo*fs)+1;
        axes(h66axescwtint);
        v66escplot=plot(v66escmin:v66escint:v66escmax,v6cwt(:,v66tempoind));
        axis tight
        grid on
        xlabel('Escalas')
        ylabel('Coeficientes')
        title(strcat('Coeficientes no tempo:',num2str(v66tempo)))
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%FUNCTION%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

