% This function retrieves the weighted regression values and plots them in
% the compass plot. This is a training plot which means we don't have any
% targets appearing at all.

function classificationTraining(handles, m1)


    load('baseline.mat');
    load('MdlLinear.mat');
    load('ExtensionRegression.mat');
    load('FlexionRegression.mat');
    load('RadialRegression.mat');
    load('UlnarRegression.mat');
    load('FistRegression.mat');
    load('StretchRegression.mat');
    
    pause(0.1);

    plothandle = handles;

    if ~isempty(plothandle)
        cla(plothandle);        
        axes(plothandle)
        whyTho = [1 1 1 1 1 1 1];
        someBars = bar(plothandle, whyTho, 'b');
        ylim([0 1]);
        str = {' ',' ',' ',' ',' ',' ',' '};
        %str = {'Extension','Flexion','Radial','Ulnar','Fist','Stretch','Rest'};
        set(gca, 'XTickLabel',str, 'XTick',1:numel(str));
        hold on;
        
        
        
        %Setup for later use. Do NOT change it unless you want to fix it
        %after you screw it up.
        
        classVal = [0 0 0 0 0 0 0 ; 0 0 0 0 0 0 0];
        buffer1 = 0;
        buffer2 = 0;
        RV = [0 0 0 0 0 0 0; 0 0 0 0 0 0 0; 0 0 0 0 0 0 0];
        time = 0;
        windowSize = 40;
        lim4Green = 0.75
        
        %Makes sure we'll record for the stated 'recordingTime'
        while time <= 60
            
            %This has been stolen from MyoMex to retrieve data:
            timeEMG = m1.timeEMG_log;
            if ~isempty(timeEMG)
                iiEMG = find(timeEMG>=(timeEMG(end)-2));
                tEMG = timeEMG(iiEMG);
                EmgMatrix(iiEMG,:) = m1.emg_log(iiEMG,:);
                lastSample = max(iiEMG);
                timeIMU = m1.timeIMU_log;
                iiIMU = find(timeIMU>=(timeIMU(end)-2));
                %First window:
                if lastSample >= windowSize && buffer1 >= windowSize
                    
                    %Gets the time we've recorded EMG in this function
                    time = m1.timeEMG;
                    
                    %Finds and filters the window we've selected
                    toBeFiltered = EmgMatrix(lastSample-(windowSize-1):...
                        lastSample,1:8);
                    toBeFiltered = toBeFiltered - baseline;
                    filterEmg = butterFilter(toBeFiltered);
                    
                    %This is also ok featz cause we so streetz:
                    featMAV = featureExtractionLiveMAV(filterEmg);
                    featWL = featureExtractionLiveWL(filterEmg);
                    featMMAV = featureExtractionLiveMMAV(featMAV);
                    featSMAV = featureExtractionLiveSMAV(featMAV,featMMAV);
                    featMADN = featureExtractionLiveMADN(filterEmg);
                    featMADR = featureExtractionLiveMADR(filterEmg);
                    featSMADR = featureExtractionLiveSMADR(featMADR,featMMAV);
                    featCC = featureExtractionLiveCC(filterEmg);
                    
                    feat = [featMAV, featWL, featSMAV, featMADN, featMADR, featSMADR, featCC];
                    
                    %%Gets the classifier values with a single model:
                    classVal = [classVal;getClassificationValue(feat,MdlLinear)];
                    
                    len = size(classVal,1);
                    classToPlot = mean(classVal(len-2:len,:));   
                    
                    RV = [RV;getSingleTrainingRegression(featMAV,...
                        ExtensionRegression,FlexionRegression,RadialRegression,UlnarRegression, ...
                        FistRegression,StretchRegression,classToPlot)]; 
                    
                    RVTP = mean(RV(len-2:len,:));
                    
                    str = {num2str(RVTP(1)),num2str(RVTP(2)),num2str(RVTP(3)), ...
                        num2str(RVTP(4)),num2str(RVTP(5)),num2str(RVTP(6)), ...
                        num2str(RVTP(7))};
                    
                    axes(plothandle);
                    set(someBars,'XData',[1 2 3 4 5 6 7],'Ydata',classToPlot);
                    set(gca, 'XTickLabel',str, 'XTick',1:numel(str));
                    drawnow;

                    buffer1 = 0;
                else 
                    buffer1 = buffer1 + 1;
                end
                
                %%Second window:
                if lastSample >= windowSize+20 && buffer2 >= windowSize
                    
                    %Gets the time we've recorded EMG in this function
                    time = m1.timeEMG;
                    
                    %Finds and filters the window we've selected
                    toBeFiltered = EmgMatrix(lastSample-(windowSize-1):...
                        lastSample,1:8);
                    toBeFiltered = toBeFiltered - baseline;
                    filterEmg = butterFilter(toBeFiltered);
                    
                    %This is also ok featz cause we so streetz:
                    featMAV = featureExtractionLiveMAV(filterEmg);
                    featWL = featureExtractionLiveWL(filterEmg);
                    featMMAV = featureExtractionLiveMMAV(featMAV);
                    featSMAV = featureExtractionLiveSMAV(featMAV,featMMAV);
                    featMADN = featureExtractionLiveMADN(filterEmg);
                    featMADR = featureExtractionLiveMADR(filterEmg);
                    featSMADR = featureExtractionLiveSMADR(featMADR,featMMAV);
                    featCC = featureExtractionLiveCC(filterEmg);
                    
                    feat = [featMAV, featWL, featSMAV, featMADN, featMADR, featSMADR, featCC];
                   
                    %%Gets the classifier values:
                    classVal = [classVal;getClassificationValue(feat,MdlLinear)];
                    
                    len = size(classVal,1);
                    classToPlot = mean(classVal(len-2:len,:));
                    
                    RV = [RV;getSingleTrainingRegression(featMAV,...
                        ExtensionRegression,FlexionRegression,RadialRegression,UlnarRegression, ...
                        FistRegression,StretchRegression,classToPlot)]; 
                    
                    RVTP = mean(RV(len-2:len,:));
                    
                    str = {num2str(RVTP(1)),num2str(RVTP(2)),num2str(RVTP(3)), ...
                        num2str(RVTP(4)),num2str(RVTP(5)),num2str(RVTP(6)), ...
                        num2str(RVTP(7))};
                    
                    axes(plothandle);
                    set(someBars,'XData',[1 2 3 4 5 6 7],'Ydata',classToPlot);
                    set(gca, 'XTickLabel',str, 'XTick',1:numel(str));
                    drawnow;


                    %Colorful barplot: 
%                     if classToPlot(1) >= lim4Green
%                         set(barplot1,'FaceColor','Green');
%                     else
%                         set(barplot1,'FaceColor','Green');
%                     end
%                     if classToPlot(2) >= lim4Green
%                         set(barplot2,'FaceColor','Green');
%                     else
%                         set(barplot2,'FaceColor','Green');
%                     end
%                     if classToPlot(3) >= lim4Green
%                         set(barplot3,'FaceColor','Green');
%                     else
%                         set(barplot3,'FaceColor','Green');
%                     end
%                     if classToPlot(4) >= lim4Green
%                         set(barplot4,'FaceColor','Green');
%                     else
%                         set(barplot4,'FaceColor','Green');
%                     end
%                     if classToPlot(5) >= lim4Green
%                         set(barplot5,'FaceColor','Green');
%                     else
%                         set(barplot5,'FaceColor','Green');
%                     end
%                     if classToPlot(6) >= lim4Green
%                         set(barplot6,'FaceColor','Green');
%                     else
%                         set(barplot6,'FaceColor','Green');
%                     end
%                     if classToPlot(7) >= lim4Green
%                         set(barplot7,'FaceColor','Green');
%                     else
%                         set(barplot7,'FaceColor','Green');
%                     end
%                     set(barplot1,'XData',1,'YData',classToPlot(1));
%                     set(barplot2,'XData',2,'YData',classToPlot(2));
%                     set(barplot3,'XData',3,'YData',classToPlot(3));
%                     set(barplot4,'XData',4,'YData',classToPlot(4));
%                     set(barplot5,'XData',5,'YData',classToPlot(5));
%                     set(barplot6,'XData',6,'YData',classToPlot(6));
%                     set(barplot7,'XData',7,'YData',classToPlot(7));

                    buffer2 = 0;
                else
                    buffer2 = buffer2 + 1;
                end
            end
        end
    end
end
