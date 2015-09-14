#1
library(XML)
library(plyr)
library(ggplot2)
library(RColorBrewer)
library(dplyr)
tags = xmlParse("tags.xml") 
tags_list =  t(xmlSApply(xmlRoot(tags), xmlAttrs)) 
len<-length(tags_list)
counts=rep(0,len)
Tags=rep("0",len)
for(i in 1:len){
	counts[i]=tags_list[[i]]["Count"]
	Tags[i]=tags_list[[i]]["TagName"]
}

tags_data<-data.frame(count=as.numeric(counts),Tag=Tags)
re<-arrange(tags_data,desc(count))
sum(re$count)
cols<-brewer.pal(10,"Set2")
library(datasets)
png(file = "top10Tags.png", width = 480, height = 480)
par(las=2,mai=c(1.7,0.8,0.8,0.3))
barplot(beside=TRUE, head(re$count/sum(re$count),10),names.arg=head(re$Tag,10),main="Top 10 popular tags",space=2,axisnames=TRUE,col=cols ,border="black")  
title(ylab="percent") 
dev.off()


posts = xmlParse("posts.xml") 
posts_list =  t(xmlSApply(xmlRoot(posts), xmlAttrs))
len<-length(posts_list)
PostTypeIds=rep("0",len)
Scores=rep("0",len)
for(i in 1:len){
	PostTypeIds[i]=posts_list[[i]]["PostTypeId"]
	Scores[i]=posts_list[[i]]["Score"]
}
Post_data<-data.frame(PostTypeId=PostTypeIds,Score=Scores)
PostTypes<-data.frame(PostTypeId=c(1,2,3,4,5,6,7),PostTypes=c("Question","Answer","Orphaned tag wiki","Tag wiki excerpt","Tag wiki","Moderator nomination","Wiki placeholder"))
Post_data2<-merge(Post_data,PostTypes,by="PostTypeId")
cols<-brewer.pal(7,"Set3")
par(las=2,mai=c(1.3,0.8,0.8,0.3))
plot(Post_data2$PostTypes,col=cols ,border="black")  

png(file = "PostTypes.png", width = 780, height = 480)
qplot(PostTypes,data=Post_data2,main="histogram of post types")  
dev.off()
Post_data2$Score<-as.numeric(Post_data2$Score)
png(file = "PostTypes.png", width = 780, height = 480)
qplot(PostTypes,data=Post_data2,main="histogram of post types")  
dev.off()

png(file = "PostTypes_Score.png", width = 680, height = 480)
qplot(Score,data=Post_data2,fill=PostTypes,main="Histogram of Score by Post Types")
dev.off()

Post_data3<-subset(Post_data2,PostTypeId=="1"|PostTypeId=="2" )
Post_data3$PostTypes<-as.factor(as.character(Post_data3$PostTypes))
png(file = "PostTypes_Score2.png", width = 480, height = 480)
boxplot(Score~PostTypes,data=Post_data3,main="Boxplot of Score of Question and Answer")
dev.off()




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

