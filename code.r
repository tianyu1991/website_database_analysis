library(XML)
library(plyr)
library(ggplot2)
library(RColorBrewer)
library(dplyr)

#"top10Tags
tags = xmlParse("tags.xml") 
tags_list =  t(xmlSApply(xmlRoot(tags), xmlAttrs)) 
post_len<-length(tags_list)
tags_data<-data.frame(count=rep(0,post_len),Tag=rep("0",post_len),stringsAsFactors=FALSE)
for(i in 1:post_len){
	tags_data[i,1]=as.numeric(tags_list[[i]]["Count"])
	tags_data[i,2]=tags_list[[i]]["TagName"]
}
tags_data<-arrange(tags_data,desc(count))
cols<-c(brewer.pal(7,"Set1"),brewer.pal(3,"Set2"))

library(datasets)
png(file = "top10Tags.png", width = 480, height = 480)
par(las=2,mai=c(1.7,0.8,0.8,0.3))
barplot(beside=TRUE, head(tags_data$count/sum(tags_data$count),10),names.arg=head(tags_data$Tag,10),main="Top 10 popular tags",space=2,col=cols ,border="black")  
title(ylab="percent") 
dev.off()

#post score and view

posts = xmlParse("posts.xml") 
posts_list =  t(xmlSApply(xmlRoot(posts), xmlAttrs))
post_len=length(posts_list)
Post_data<-data.frame(PostTypeId=rep(0,post_len),Score=rep(0,post_len),Views=rep(0,post_len))
for(i in 1:post_len){
	Post_data[i,1]=posts_list[[i]]["PostTypeId"]
	Post_data[i,2]=as.numeric(posts_list[[i]]["Score"])
	Post_data[i,3]=as.numeric(posts_list[[i]]["ViewCount"])
}
PostTypes<-data.frame(PostTypeId=c(1,2,3,4,5,6,7),PostTypes=c("Question","Answer","Orphaned tag wiki","Tag wiki excerpt","Tag wiki","Moderator nomination","Wiki placeholder"))
Post_data2<-merge(Post_data,PostTypes,by="PostTypeId")
cols<-brewer.pal(7,"Set2")

png(file = "PostTypes.png", width = 780, height = 480)
qplot(PostTypes,data=Post_data2,main="histogram of post types")  
dev.off()

png(file= "PostTypes_Score.png", width = 680, height = 480)
qplot(Score,data=Post_data2,fill=PostTypes,main="Histogram of Score by Post Types")
dev.off()

Post_data3<-subset(Post_data2,PostTypeId=="1"|PostTypeId=="2" )
Post_data3$PostTypes<-as.factor(as.character(Post_data3$PostTypes))
png(file = "PostTypes_Score2.png", width = 480, height = 480)
boxplot(Score~PostTypes,data=Post_data3,main="Boxplot of Score of Question and Answer")
dev.off()

Post_data4<-subset(Post_data3,PostTypeId=="1")
png(file = "PostTypes_Score3.png", width = 480, height = 480)
qplot(Score,Views,data=Post_data4,geom=c("point","smooth"),method="lm",main="Scatter Plot of a Question's Score VS Viewcount")
dev.off()


#Score_Reputation
idnum<-0
for(i in 1:len){
	if(!is.na(posts_list[[i]]["OwnerUserId"])) idnum<-idnum+1
}
Ids<-rep(0,idnum)
Scores<-rep(0,idnum)
n<-1
for(i in 1:len)	{
	if(!is.na(posts_list[[i]]["OwnerUserId"])){
		Ids[n]<-posts_list[[i]]["OwnerUserId"]
		Scores[n]<-as.numeric(posts_list[[i]]["Score"])
		n<-n+1}}
id_score<-data.frame(Id=Ids,Score=Scores,stringsAsFactors=FALSE)
id_score$Id<-as.factor(id_score$Id)
id_score2<-subset(id_score,Id!=-1)
id2<-group_by(id_score2,Id)
id_score3<-as.data.frame(summarize(id2,Score=sum(Score)))


users = xmlParse("Users.xml") 
users_list =  t(xmlSApply(xmlRoot(users), xmlAttrs))[,-1] 
user_len<-length(users_list)
users2<-rep(0,user_len)
rep<-rep(0,user_len)
for(i in 1:user_len){
		users2[i]<-users_list[[i]]["Id"]
		rep[i]<-users_list[[i]]["Reputation"]
}
id_rep<-data.frame(Id=users2,Rep=rep,stringsAsFactors=FALSE)
rep_score=merge(id_score3,id_rep,by="Id",all=FALSE)

rep_score[,2]<-as.numeric(rep_score[,2])
rep_score[,3]<-as.numeric(rep_score[,3])

png(file = "Score_Rep.png", width = 480, height = 480)
qplot(Score,Rep,data=rep_score,geom=c("point","smooth"),method="lm",main="Scatter Plot of a User’s Reputation VS Total Score from Posts")
dev.off()

fit <- lm(Rep ~ Score, data=rep_score)
cor.test( rep_score$Rep,rep_score$Score, method = "pearson", alternative = "greater")


#Time to answer
que_len=nrow(Post_data4)
ans_len=nrow(Post_data3)-nrow(Post_data4)
quesid<-data.frame(que_id=rep(0,que_len),creatt=rep("0",que_len),comc=rep(0,que_len),ans_id=rep(0,que_len),stringsAsFactors=FALSE)
ansid<-data.frame(ans_id=rep(0,que_len),creatt=rep("0",que_len),comc=rep(0,que_len),stringsAsFactors=FALSE)
q<-1
a<-1

for(i in 1:post_len){
	if(posts_list[[i]]["PostTypeId"]==1) {
		quesid[q,1]<-posts_list[[i]]["Id"]
		quesid[q,2]<-posts_list[[i]]["CreationDate"]
		quesid[q,3]<-posts_list[[i]]["CommentCount"]
		quesid[q,4]<-posts_list[[i]]["AcceptedAnswerId"]
		q<-q+1}
	if(posts_list[[i]]["PostTypeId"]==2) {
		ansid[a,1]<-posts_list[[i]]["Id"]
		ansid[a,2]<-posts_list[[i]]["CreationDate"]
		ansid[a,3]<-posts_list[[i]]["CommentCount"]
		a<-a+1}
}
library(lubridate)
quesid$creatt<-ymd_hms(quesid$creatt)

png(file = "creat_time_new.png", width = 480, height = 480)
qplot(strftime(quesid$creatt, "%H"),main="Creation Time of Question",xlab="time")
dev.off()

quesid$comc<-as.numeric(quesid$com)
hour<-strftime(as.character(quesid$creatt),"%H")
quesid2<-cbind(quesid,hour)

ansid$creatt<-ymd_hms(ansid$creatt)
mergy_time<-merge(quesid2,ansid,by="ans_id",all = FALSE)
time<-mergy_time$creatt.y-mergy_time$creatt.x
mergy_time<-cbind(mergy_time,time)

mergy_time2<-group_by(mergy_time,hour)
mergy_time3<-summarize(mergy_time2,time=median(time,na.rm=TRUE))

png(file = "anstime.png", width = 480, height = 480)
qplot(hour,as.numeric(time),data=mergy_time3,main="Time needed to get accepted answer", xlab="Creation Time of Question(hour)")
dev.off()

mergy_time4<-summarize(mergy_time2,time=mean(time,na.rm=TRUE))
qplot(hour,as.numeric(time),data=mergy_time4)
(max(mergy_time3$time)-min(mergy_time3$time))/60/60

png(file = "boxplot_time.png", width = 1080, height = 480)
boxplot(log(as.numeric(time))~hour,data=mergy_time,ylab="log(time)",xlab="Creation Time of Question(hour)",main="Time needed to get accepted answer")
dev.off()
