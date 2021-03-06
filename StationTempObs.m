%% Sarah Ashebir and Gaby Reiter 
% Instructions: Follow through this code step by step, while also referring
% to the overall instructions and questions from the lab assignment sheet.
% Everywhere you see "% -->" is a place where you will need to write in
% your own line of code to accomplish the next task.

%% 1a. Read in the file for your station as a data table
filename = '859340.csv'; %change this to select a different station
stationdata = readtable(filename);
%% 1b-c. Investigate the data you are working with
%Click in the workspace to open up the new table named stationdata. You
%should be able to see headers for each column in the table.

%Open up the original csv file (Excel is a good way to do this) to see how
%the imported headers match those in the original file.

%You should also be able to see the latitude and longitude of the original
%station in the csv file. Add these below:

stationlat = -53 %S
stationlon = -70.85 %W

%% 2. Plot the data from a single month
% Make a plot for all data from January with year on the x-axis and
% temperature on the y-axis. You will want this plot to have individual
% point markers rather than a line connecting each data point.
figure(20); clf
plot(stationdata.Year,stationdata.Jan, "ro")
ylabel("Average Temperature (�C)")
xlabel("Year")
title("Average January Temperature from 1888 to 1991 ")
% Calculate the monthly mean, minimum, maximum, and standard deviation
% note: some of these values will come out as NaN is you use the regular
% mean and std functions --> can you tell why? use the functions nanmean
% and nanstd to avoid this issue.

monthMean = nanmean(stationdata.Jan)
monthStd = nanstd(stationdata.Jan)
monthMin = min(stationdata.Jan)
monthMax = max(stationdata.Jan)

%% 3. Calculate the annual climatology
% Extract the monthly temperature data from the table and store it in an
% array, using the function table2array

tempData = table2array(stationdata(:,4:15));


%Calculate the mean, standard deviation, minimum, and maximum temperature
%for every month. This will be similar to what you did above for a single
%month, but now applied over all months simultaneously.
tempMean = nanmean(tempData)
tempStd = nanstd(tempData)
tempMin = min(tempData)
tempMax = max(tempData)

%Use the plotting function "errorbar" to plot the monthly climatology with
%error bars representing the standard deviation. Add a title and axis
%labels. Use the commands "axis", "xlim", and/or "ylim" if you want to
%change from the automatic x or y axis limits.
% --> (note that this may take multiple lines of code)
    figure(1); clf
    plot(tempMean)
    errorbar(tempMean,tempStd)
    title("Average Temperature per Month from 1888 to 1991 ")
    ylabel("Average Temperature (�C)")
    xlabel("Month")
%% 4. Fill missing values with the monthly climatological value
% Find all values of NaN in tempData and replace them with the
% corresponding climatological mean value calculated above.
% We can do this by looping over each month in the year:
for i=(1:12)
    indnan = find(isnan(tempData(:,i)) == 1)
    tempData(indnan,i)= tempMean(i)
end 
   
    %use the find and isnan functions to find the index location in the
    %array of data points with NaN values
    %check to make sure you understand what is happening in this line
    %now fill the corresponding values with the climatological mean


%% 5a. Calculate the annual mean temperature for each year
annualmean=mean(tempData,2) % mean temperature for each year ,, annually 


%% 5b-c. Calculate the temperature anomaly for each year, compared to the 1981-2000 mean
% The anomaly is the difference from the mean over some baseline period. In
% this case, we will pick the baseline period as 1981-2000 for consistency
% across each station (though note that this is a choice we are making, and
% that different temperature analyses often pick different baselines!)

Year = stationdata.Year;
baselineYear =find((Year>=1981)&(Year<= 2000));
baselineMean = mean(annualmean(baselineYear)) 

%Calculate the annual mean temperature over the period from 1981-2000
  %Use the find function to find rows contain data where stationdata.Year is between 1981 and 2000
% -->
  %Now calculate the mean over the full time period from 1981-2000
% -->

%Calculate the annual mean temperature anomaly as the annual mean
%temperature for each year minus the baseline mean temperature
TempAnnMeanAnomaly = annualmean - baselineMean



%% 6a. Plot the annual temperature anomaly over the full observational record
figure(2); clf
%Make a scatter plot with year on the x axis and the annual mean
%temperature anomaly on the y axis
scat = scatter(Year,TempAnnMeanAnomaly)
hold on
    title("Annual Temperature Anomaly from 1888-1991")
    ylabel("Temperture Annual Anomaly (�C)")
    xlabel("Year")
%% 6b. Smooth the data by taking a 5-year running mean of the data to plot
%This will even out some of the variability you observe in the scatter
%plot. There are many methods for filtering data, but this is one of the
%most straightforward - use the function movmean for this. For information
%about how to use this function, type "help movmean" in the command window.
movmeanavg = movmean(TempAnnMeanAnomaly, 5)
plot(Year,movmeanavg, "r-")
    title("Smoothed Temperature Mean Anomaly from 1888 to 1991 ")
    ylabel("Average Temperature (�C)")
    xlabel("Year")
%Now add a line with this smoothed data to the scatter plot



%% 7. Add and plot linear trends for whole time period, and for 1960 to today
%Here we will use the function polyfit to calculate a linear fit to the data
%For more information, type "help polyfit" in the command window and/or
%read the documentation at https://www.mathworks.com/help/matlab/data_analysis/linear-regression.html
    %use polyfit to calculate the slope and intercept of a best fit line
    %over the entire observational period
P_all = polyfit (Year, TempAnnMeanAnomaly, 1)


    %also calculate the slope and intercept of a best fit line just from
    %1960 to the end of the observational period
    % Hint: start by finding the index for where 1960 is in the list of
    % years
RecentYear = 1960;
indrecent = find(Year == RecentYear);
P_recent = polyfit (Year(indrecent:end), TempAnnMeanAnomaly(indrecent:end),1)


%Add lines for each of these linear trends on the annual temperature
%anomaly plot (you can do this either directly using the slope and intercept
%values calculated with polyfit, or using the polyval function).
%Plot each new line in a different color.
x = Year
y = P_all(1)*x +P_all(2)
plot(x,y)

x = Year
y = P_recent(1)*x +P_recent(2)
plot(x,y)
    title("Temperature Anomaly from 1888 to 1991 (�C)")
    ylabel("Temperature (�C)")
    xlabel("Year")
    legend('Annual Anomaly', '5 Year Smoothed Anomaly', 'Anomaly Trend Over All Years', 'Anomaly Trend Over Recent Years (1960 to 1991)')
hold off
% Add a legend, axis labels, and a title to your temperature anomaly plot
% winter = dec, jan, feb // summer = jun, july, aug
 

%%Extension: annuanl mean summer and winter, summer and winter anomaly, and trend
% lines for summer and winter

%summer=NaN(length(tempData),3);
summer=[tempData(:,1),tempData(:,2),tempData(:,12)];
yearlysummer_mean= mean(summer(1:104,:),2)
TempSummerMeanAnomaly = yearlysummer_mean - baselineMean
P_summer = polyfit (Year, TempSummerMeanAnomaly, 1)
RecentYear = 1960
indrecent = find(Year == RecentYear);
P_recentsummer = polyfit (Year(indrecent:end), TempSummerMeanAnomaly(indrecent:end),1)

%winter=NaN(length(tempData),3);
winter=[tempData(:,6),tempData(:,7),tempData(:,8)];
yearlywinter_mean= mean(winter(1:104,:),2)
TempWinterMeanAnomaly = yearlywinter_mean - baselineMean
P_winter = polyfit (Year, TempWinterMeanAnomaly, 1)
P_recentwinter = polyfit (Year(indrecent:end), TempWinterMeanAnomaly(indrecent:end),1)

figure(747474); clf
scat = scatter(Year,TempSummerMeanAnomaly)
hold on
    title("Summer Temperature Anomaly from 1888-1991")
    ylabel("Temperture Anomaly (�C)")
    xlabel("Year")

    movmeansummer = movmean(TempSummerMeanAnomaly, 5)
plot(Year,movmeansummer, "r-")
    title("Smoothed Seasonal Temperature Mean Anomaly from 1888 to 1991 ")
    ylabel("Average Temperature (�C)")
    xlabel("Year")

x = Year
y = P_summer(1)*x +P_summer(2)
plot(x,y)

    title("Annual Summer Temperature Anomaly from 1888 to 1991 (�C)")
    ylabel("Temperature (�C)")
    xlabel("Year")
   
x = Year
y = P_recentsummer(1)*x +P_recentsummer(2)
    plot(x,y)
title("Temperature Anomaly from 1888 to 1991 (�C)")
    ylabel("Temperature (�C)")
    xlabel("Year")
    legend('Summer Temperature Anomaly', '5 Year Smoothed Anomaly', 'Summer Anomaly Trend Over All Years (1888 to 1991)', 'Summer Anomaly Trend Over Recent Years (1981 to 1991)' )

   hold off



figure(747475); clf
scat = scatter(Year,TempWinterMeanAnomaly)
hold on
    title("Winter Temperature Anomaly from 1888-1991")
    ylabel("Temperture Anomaly (�C)")
    xlabel("Year")

    movmeanwinter = movmean(TempWinterMeanAnomaly, 5)
plot(Year,movmeanwinter, "r-")
    title("Smoothed Seasonal Temperature Mean Anomaly from 1888 to 1991 ")
    ylabel("Average Temperature (�C)")
    xlabel("Year")

x = Year
y = P_winter(1)*x +P_winter(2)
plot(x,y)
    title("Annual Winter Temperature Anomaly from 1888 to 1991 (�C)")
    ylabel("Temperature (�C)")
    xlabel("Year")
   
x = Year
y = P_recentwinter(1)*x +P_recentwinter(2)
    title("Temperature Anomaly from 1888 to 1991 (�C)")
    ylabel("Temperature (�C)")
    xlabel("Year")
    plot(x,y)
    legend('Winter Temperature Anomaly', '5 Year Smoothed Anomaly', 'Winter Anomaly Trend Over All Years (1888 to 1991)', 'Winter Anomaly Trend Over Recent Years (1981 to 1991)' )

   hold off