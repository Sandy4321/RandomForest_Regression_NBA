library('randomForest')
library('ggplot2')

##read the stats from the text file into a data frame
stats<-read.table('12-13RD.txt', header=T) 

##reclassify the traditional positions as Guard/Forward
pos = as.character(stats$PS)
pos[which(pos == "C" | pos == "PF" | pos == "SF")] = "F"
pos[which(pos != "F")] = "G"
pos = as.factor(pos) 
#The as.factor() command creates a categorical (or factor/class)
# variable from a variable

##merge the guard/forward coding with the 
##relevant columns from the stats data.frame
##and normalize all stats by minutes played
d<-data.frame( stats[,6:23]/stats$Min, pos=pos ) 

##grow the forest
rf <- randomForest(
	pos ~ ., ##this is the model specification, position vs. all
	data=d,
	importance=TRUE, 
	proximity=TRUE, 
	keep.forest=TRUE)

##get confusion matrix
rf$confusion

##make importance bar graph
imp <- data.frame(MDA = sort(rf$importance[,3], decreasing=T) )
imp <- data.frame( Stat = rownames(imp)[1:14], MDA = imp$MDA[1:14])
imp$Stat <- reorder(imp$Stat, -imp$MDA)
ggplot( imp, aes(x = Stat, y = MDA, fill = Stat)) + geom_bar(stat = "identity") +
scale_y_continuous("Mean Decrease in Classification Accuracy", breaks=seq(0,.1,length.out=6), labels=c("0%","2%","4%","6%","8%","10%")) +
scale_x_discrete("Statsitcal Category Permuted") + 
opts(legend.position = "none")
ggsave( filename = "importance.png")

##make proximity scatterplot
mds = cmdscale(rf$proximity-1, eig=TRUE)
##filter out only players with > 1100 points to make plot more readable
prox = data.frame( x = mds$points[which(stats$PTS > 1100),1], 
y = mds$points[which(stats$PTS > 1100),2],
name = as.character(stats$Player[which(stats$PTS > 1100)]))
ggplot(prox, aes(x=x, y=y )) + 
geom_text(label=prox$name, size = 4.5, position = position_jitter(w=.2, h = .4), aes( color = name)) +
geom_point(size = 1,aes(color = name, alpha=0.5)) +
opts(legend.position = "none") + 
scale_x_continuous("", limits = c(-0.7,0.71)) + 
scale_y_continuous("") 
ggsave( filename = "cluster.png")

