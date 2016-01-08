% Sweep Analysis Example Script

%% 1. Set parameters specifying which data to process:
setPath;
dataDir = 'exampleData/PowerDivaProProject_Exp_TEXT_HCN_128_Avg/'; % specify directory where RLS or DFT files are
channels = [71 76 70 75 83 74 82]; % this works well for hexagonal plots, but it could be anything, e.g.: [66 70 71 72 73 74 75 76 82 83 88];
sweepEstType = 'RLS'; % or 'DFT'
% 2 optional inputs to makeDataStructure:
exptName = 'DisparityExperiment'; 
condNames = {'HorSwp' 'VerSwp' 'HorCorr' 'VerCorr'}; 

%% 2. Read in PowerDiva data to [ NumConditions X length(channels) ] array of structs containing sweep data & info.:
pdData = makeDataStructure(dataDir,channels,sweepEstType,exptName,condNames);

%% 3. Set the desired colors used for plotting (if not provided to plotting routines, default colors used):
conditionColors = [1 0 0; 0 0 1; 0 1 0; 1 0 1; 0 1 1; 0 0 0]; % specify RGB triplets in rows as desired (1 row/condition)

%% Create sweep plots of amplitude as a function of bin value, with SEM error bars 
%% (OR change 'Ampl' -- the first input parameter -- to 'SNR' for SNR plots without error bars)

% Example) Plot Conditions 1 & 2 for electrode 76 & the 1st frequency component:
freqIxToPlot = 1;
chanIxToPlot = 2; % channels(2) = 76;
condsToPlot = 1:2;

figNum = [];
plotNum = nan(1,max(condsToPlot));
for freqNum = freqIxToPlot
    for chanNum = chanIxToPlot        
        for condNum = condsToPlot
            
            [figNum,plotNum(condNum)] = plotSweepPD( 'Ampl', pdData(condNum,chanNum).dataMatrix, pdData(condNum,chanNum).hdrFields, ...
                pdData(condNum,chanNum).binLevels, freqNum, 'SEM', conditionColors(condNum,:), figNum );
        end
    end
end

legend(plotNum(~isnan(plotNum)),condNames(condsToPlot),'Location','NorthWest')


%% Create panel of polar plots, one for each bin, showing the individual 2D data points as twigs, 
%% and the combined error ellipse as a transparent surface, to observe how data evolve
%% over the bin levels

% Example) Plot Conditions 1 & 2 for electrode 76 & the 1st frequency component:
freqIxToPlot = 1;
chanIxToPlot = 2; % channels(2) = 76;
condsToPlot = 1:2;

figNum = [];
for freqNum = freqIxToPlot
    for chanNum = chanIxToPlot        
        for condNum = condsToPlot
            
            figNum = plotPolarBins(pdData(condNum,chanNum).dataMatrix,pdData(condNum,chanNum).hdrFields,pdData(condNum,chanNum).binLevels,freqNum,conditionColors(condNum,:),figNum);

        end
    end
end

%% Create bar plots showing how many trials were accepted out of the total number run,
%% for each bin separately. This is mainly useful for checking how well an individual
%% participant did in the experiment. For example, try this for the provided individual 
%% participant data in exampleData/PowerDivaHostSingleSubject_Exp_TEXT_HCN_128_Avg/

freqIxToPlot = 1;
chanIxToPlot = 2; % channels(2) = 76;
condsToPlot = 1:2;

figNum = [];
for freqNum = freqIxToPlot
    for chanNum = chanIxToPlot        
        for condNum = condsToPlot
            plotNumberAcceptedTrials(pdData(condNum,chanNum).dataMatrix,pdData(condNum,chanNum).hdrFields,freqNum,conditionColors(condNum,:),figNum);
        end
    end
end

%% Create a panel of plots arranged hexagonally following the geodesic layout of the net
%% 
%% In this example, 'SNR' is requested, but that can be swapped out for 'Ampl'

subplotLocs = getHexagSubPlotLocations;

chanIxToPlot = 1:length(channels); 
condsToPlot = 1:2;
freqNum = 1;

figNum = 10;
figure(figNum);
clf;
for chanNum = chanIxToPlot
    for condNum = condsToPlot
        
        plotSweepPD( 'SNR', pdData(condNum,chanNum).dataMatrix, pdData(condNum,chanNum).hdrFields, ...
            pdData(condNum,chanNum).binLevels, freqNum, 'SEM', conditionColors(condNum,:), [figNum,subplotLocs(chanNum,:)] );
        set(gca,'YTick',[0 max(ylim)/4 max(ylim)/2 3*max(ylim)/4 max(ylim)])
        if condNum == condsToPlot(end)
            % add text to label channel numbers for each subplot
            text(1.2*pdData(condNum,chanNum).binLevels(1),max(ylim)-(max(ylim)/10),sprintf('%d',channels(chanNum)),'FontSize',14)
        end

    end
end

%% In this example, the number of trials bar plot is shown for each channel:

subplotLocs = getHexagSubPlotLocations;

freqIxToPlot = 1;
chanIxToPlot = 1:length(channels); 
condsToPlot = 2;
freqNum = 1;

figNum = 20;
figure(figNum);
clf;
for chanNum = chanIxToPlot
    for condNum = condsToPlot
        
        plotNumberAcceptedTrials(pdData(condNum,chanNum).dataMatrix,pdData(condNum,chanNum).hdrFields,freqNum,conditionColors(condNum,:),[figNum,subplotLocs(chanNum,:)]);
        if condNum == condsToPlot(end)
            % add text to label channel numbers for each subplot
            text(1.2*pdData(condNum,chanNum).binLevels(1),max(ylim)-(max(ylim)/10),sprintf('%d',channels(chanNum)),'FontSize',14)
        end

    end
end