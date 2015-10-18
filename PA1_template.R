#---
#  title: "PA1_template"
#author: "Jessica Costa"
#date: "October 17, 2015"
#output: html_document
#---
  
  
#  Loading and preprocessing the data

#In this first Peer Assessment Assignment, we first read the data from the file "activity.csv":
  
#  ```{r, echo=TRUE}
Data <- read.csv("C:/Users/jcosta/Documents/Data Science/Reproducible Research/RepData_PeerAssessment1/activity/activity.csv")
#```

#What is mean total number of steps taken per day?

#We want to determine the mean total number of steps taken per day.  We do this using the following code chunk:
  
#  ```{r, echo=TRUE}
TotalSteps <- aggregate(Data$steps ~ Data$date, Data, sum)
barplot(TotalSteps$`Data$steps`, names.arg = TotalSteps$`Data$date`, main = "Total Number of Steps Taken Per Day", xlab = "Day", ylab = "Total Steps")
#```

#The mean number of steps per day is calculated using the following code chunk:
#  ```{r, echo=TRUE}
mean(TotalSteps$`Data$steps`)
#```

#The median number of steps per day is calculated using the following code chunk:
#  ```{r, echo=TRUE}
median(TotalSteps$`Data$steps`)
#```

#What is the average daily activity pattern?

#First, we need to aggregate the data to find the average number of steps per 5-minute interval, using the following code:
  
#  ```{r, echo=TRUE}
aggStepsByInterval <- aggregate(Data$steps ~ Data$interval, Data, mean)
#```

#Now we can plot the time series using the following code:
#  ```{r, echo=TRUE}
plot(aggStepsByInterval$`Data$interval`, aggStepsByInterval$`Data$steps`, type="l", main = "Average Number of Steps Taken by Time of Day", xlab = "5-minute time interval in day", ylab =  "Average Number of Steps Taken")
#```

#The 5-minute interval that on-average across all the days in the data set contains the highest number of steps is calculated as follows:
  
#  ```{r, echo=TRUE}
aggStepsByInterval$`Data$interval`[which.max(aggStepsByInterval$`Data$steps`)]
#```

#Inputting missing values

#First, how many missing values are there in the data set?

#We calculate this using the following code:
  
#  ```{r, echo=TRUE}
sum(is.na(Data$steps)) + sum(is.na(Data$date)) + sum(is.na((Data$interval)))
#```

#How will we deal with them? We will create a new data set by filling in the average number of steps for that 5-minute interval when we encounter missing data for any given interval:
  
#  ```{r, echo=TRUE}
NewData <- merge(Data, aggStepsByInterval, by.x = "interval", by.y = "Data$interval")
NewData$steps[which(is.na(NewData$steps))] <- NewData$`Data$steps`[which(is.na(NewData$steps))]
#```

#Create a new histogram and mean and median to compare against the original data set:
  
#  ```{r, echo=TRUE}
TotalSteps2 <- aggregate(NewData$steps ~ NewData$date, NewData, sum)
barplot(TotalSteps2$`NewData$steps`, names.arg = TotalSteps2$`NewData$date`, main = "Total Number of Steps Taken Per Day", xlab = "Day", ylab = "Total Steps")
#```

#The mean number of steps per day is calculated using the following code chunk:
#  ```{r, echo=TRUE}
mean(TotalSteps2$`NewData$steps`)
#```

#The median number of steps per day is calculated using the following code chunk:
#  ```{r, echo=TRUE}
median(TotalSteps2$`NewData$steps`)
#```


#Are there any differences in activity patterns between weekdays and weekends?

#For this part of the Assignment, the data set containing the average values filled in for the missing data is used.

#1.  Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or a weekend.

#A new factor variable is added to the data set, containing two levels - "weekday" and "weekend", using the following code chunk:
  
#  ```{r echo=TRUE}
NewData$date <- as.Date(NewData$date)
weekend <- c("Saturday", "Sunday")
NewData$DayOfWeek <- factor((weekdays(NewData$date, abbreviate = FALSE) %in% weekend), levels=c(FALSE, TRUE), labels=c("weekday", "weekend"))
#```

#2.  Make a panel plot containing a time series plot of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis)

# First subset and weekday days and weekend days using the following code:

weekdayDays <- subset(NewData, NewData$DayOfWeek == "weekday")

weekendDays <- subset(NewData, NewData$DayOfWeek == "weekend")

#Next, aggregate the data to find the average number of steps per 5-minute interval across weekday days and across weekend days, using the following code:

#  ```{r, echo=TRUE}
aggStepsByIntervalWDdays <- aggregate(weekdayDays$steps ~ weekdayDays$interval, weekdayDays, mean)

aggStepsByIntervalWEdays <- aggregate(weekendDays$steps ~ weekendDays$interval, weekendDays, mean)
#```

#Now we can plot the time series using the following code:
#  ```{r, echo=TRUE}
plot(aggStepsByIntervalWDdays$`weekdayDays$interval`, aggStepsByIntervalWDdays$`weekdayDays$steps`, type="l", main = "Average Number of Steps Taken by Time of Day on Weekdays", xlab = "5-minute time interval in day", ylab =  "Average Number of Steps Taken")

plot(aggStepsByIntervalWEdays$`weekendDays$interval`, aggStepsByIntervalWEdays$`weekendDays$steps`, type="l", main = "Average Number of Steps Taken by Time of Day on Weekend Days", xlab = "5-minute time interval in day", ylab =  "Average Number of Steps Taken")

#```

