### Load Raw data sets + descripions
library(dplyr)

setwd("~/R/Cleaning Data/Project/UCI HAR Dataset/train")

X_train <- read.delim('X_train.txt', header =FALSE, sep=" ", fill=TRUE, col.names = c(seq(1:1000)), colClasses = c(rep("numeric",1000)) )
y_train <- read.delim('y_train.txt', header =FALSE, sep=" ", fill=TRUE)
s_train <- read.delim('subject_train.txt', header =FALSE, sep=" ", fill=TRUE)

setwd("~/R/Cleaning Data/Project/UCI HAR Dataset/test")

X_test <- read.delim('X_test.txt', header =FALSE, sep=" ", fill=TRUE, col.names = c(seq(1:1000)), colClasses = c(rep("numeric",1000)) )
y_test <- read.delim('y_test.txt', header =FALSE, sep=" ", fill=TRUE)
s_test <- read.delim('subject_test.txt', header =FALSE, sep=" ", fill=TRUE)


setwd("~/R/Cleaning Data/Project/UCI HAR Dataset/")

features <- read.delim('features.txt', header =FALSE, sep=" ", fill=TRUE, stringsAsFactors = FALSE ) 
features <- as.vector( features[,2])

activities<- read.delim('activity_labels.txt', header =FALSE, sep=" ", fill=TRUE, stringsAsFactors = FALSE )
names(activities)<-c('Activity_code', 'Activity')




### Remove empty columns

X_train<- X_train[,colSums(X_train , na.rm=TRUE) !=0]
names(X_train)<-paste('X',seq(1:ncol(X_train)),sep='')

X_test<- X_test[,colSums(X_test , na.rm=TRUE) !=0]
names(X_test)<-paste('X',seq(1:ncol(X_test)),sep='')

## Prepare header of 'results' data.frame
result<-data.frame(as.list(c(1:561)))
names(result) <-paste('X',seq(1:ncol(result)),sep='')


## Remove Nulls from each rows 'X_train'
for (i in 1: nrow(X_train))
{
  n<-X_train[i,-which(sapply(X_train[i,1:ncol(X_train)], is.na))]
  names(n) <-paste('X',seq(1:ncol(n)),sep='')
  result <-rbind(result,n)
}  

result <-result[rowSums(result , na.rm=TRUE) != sum(c(1:561)),]
X_train <-result
m_train<-cbind(s_train,y_train,X_train)

## Prepare header of 'results' data.frame
result<-data.frame(as.list(c(1:561)))
names(result) <-paste('X',seq(1:ncol(result)),sep='')


## Remove Nulls from each rows 'X_test'
for (i in 1: nrow(X_test))
{
  n<-X_test[i,-which(sapply(X_test[i,1:ncol(X_test)], is.na))]
  names(n) <-paste('X',seq(1:ncol(n)),sep='')
  result <-rbind(result,n)
}  

result <-result[rowSums(result , na.rm=TRUE) != sum(c(1:561)),]
X_test <-result

m_test<-cbind(s_test,y_test,X_test)


# clean-up Environment
remove("X_test","y_test","X_train","y_train",'result','n','i')
merged_input <- rbind.data.frame(m_test,m_train)
remove('m_test','m_train')
names(merged_input)= c('Subject','Activity_code',features)

#preparation of list of 'std' and 'mean' features 
s<-features[grep('*-std*',features)]

m<-features[grep('mean',features)]
m<-m[-grep('Freq',m)]
lista <-c('Activity_code',m,s)

final_ds <- merge.data.frame(x = activities, y=merged_input, by.x ='Activity_code' , by.y ='Activity_code' )
final_ds <- final_ds[,c('Subject','Activity',m,s)]

mean_subset <- final_ds %>% group_by(Subject,Activity) %>% summarise_at(c(m,s), mean)
mean_subset <-as.data.frame((mean_subset))

names(mean_subset)<-append(c("Subject","Activity"),sapply(names(mean_subset[1,3:ncol(mean_subset)]), function(x) paste("Mean of '",x,"'") ))

remove('activities','features','lista','m','s','merged_input','s_test','s_train')

write.table(mean_subset,'data_set.txt',row.names=FALSE)
