require(randomForest)
require(caret)
require(dplyr)
require(ggplot2)

#Data feeding
setwd("C:/Users/***/Desktop/ML/titanic")
data <- read.csv("titanic.csv")
data$Survived <- as.factor(data$Survived)
data$Sex <- as.factor(data$Sex)

#Data Partition
set.seed(5)
s <- sample(887,687)
train_data <- data[s,]
test_data <- data[-s,]

#Model Building
set.seed(55)
model <- randomForest(Survived~.,data=train_data,importance=TRUE, ntree=350, mtry=2)
model
varUsed(model) #how many times each variable was used in prediction
model$err.rate[nrow(model$err.rate),] #OOB error rate at maximum mtree

#Refining Model
plot(model) #tuning for ntree
oob.values <- vector(length=10) #tuning for mtry
for(i in 1:10){
  temp.model <- randomForest(Survived~.,data=train_data,mtry=i,ntree=350)
  oob.values[i] <- temp.model$err.rate[nrow(temp.model$err.rate),1]
}
oob.values #at mtry=i
plot(oob.values)

#Prediction
p1 <- predict(model, data)
cm1 <- confusionMatrix(p1, data$Survived)
cm1
p2 <- predict(model, test_data)
cm2 <- confusionMatrix(p2, test_data$Survived)
cm2

#Testing one line of trial data
trial <- data.frame(2,"2",35,2,1,100,"0")
colnames(trial) <- colnames(data)
trial$Survived <- factor(trial$Survived, levels=c("0","1"))
trial$Sex <- factor(trial$Sex, levels=c("1","2"))
trial$PassengerClass <- as.integer(trial$PassengerClass)
trial$Age <- as.numeric(trial$Age)
trial$Siblings.Spouses.Aboard <- as.integer(trial$Siblings.Spouses.Aboard)
trial$Parents.Children.Aboard <- as.integer(trial$Parents.Children.Aboard)
p3 <- predict(model, trial)
predict(model, trial, predict.all=TRUE) #For viewing predictions of each individual tree
plot(p3, main="Prediction", xlab="Survived")

#Importance plot
varImpPlot(model)
var_importance <- data.frame(variable=setdiff(colnames(train_data), "Survived"),
                             importance=as.vector(importance(model)))
var_importance <- arrange(var_importance, desc(importance))
var_importance$variable <- factor(var_importance$variable, levels=var_importance$variable)

p <- ggplot(var_importance, aes(x=variable, weight=importance, fill=variable))
p <- p + geom_bar() + ggtitle("Variable Importance from Random Forest Fit")
p <- p + xlab("Attributes") + ylab("Variable Importance (Mean Decrease in Gini Index)")
p <- p + scale_fill_discrete(name="Variable Name")
p + theme(axis.text.x=element_blank(),
          axis.text.y=element_text(size=12),
          axis.title=element_text(size=16),
          plot.title=element_text(size=18),
          legend.title=element_text(size=16),
          legend.text=element_text(size=12))

#Plot confusion matrix using caret package 
draw_confusion_matrix <- function(cm) {
  layout(matrix(c(1,1,2)))
  par(mar=c(2,2,2,2))
  plot(c(100, 345), c(300, 450), type = "n", xlab="", ylab="", xaxt='n', yaxt='n')
  title('CONFUSION MATRIX', cex.main=2)
  
  # create the matrix 
  rect(150, 430, 240, 370, col='#3F97D0')
  text(195, 435, 'Not_survive', cex=1.2)
  rect(250, 430, 340, 370, col='#F7AD50')
  text(295, 435, 'Survived', cex=1.2)
  text(125, 370, 'Prediction', cex=1.3, srt=90, font=2)
  text(245, 450, 'Actual', cex=1.3, font=2)
  rect(150, 305, 240, 365, col='#F7AD50')
  rect(250, 305, 340, 365, col='#3F97D0')
  text(140, 400, 'Not_survive', cex=1.2, srt=90)
  text(140, 335, 'Survived', cex=1.2, srt=90)
  
  # add in the cm results 
  res <- as.numeric(cm$table)
  text(195, 400, res[1], cex=1.6, font=2, col='white')
  text(195, 335, res[2], cex=1.6, font=2, col='white')
  text(295, 400, res[3], cex=1.6, font=2, col='white')
  text(295, 335, res[4], cex=1.6, font=2, col='white')
  
  # add in the specifics 
  plot(c(100, 0), c(100, 0), type = "n", xlab="", ylab="", main = "DETAILS", xaxt='n', yaxt='n')
  text(10, 85, names(cm$byClass[1]), cex=1.2, font=2)
  text(10, 70, round(as.numeric(cm$byClass[1]), 3), cex=1.2)
  text(30, 85, names(cm$byClass[2]), cex=1.2, font=2)
  text(30, 70, round(as.numeric(cm$byClass[2]), 3), cex=1.2)
  text(50, 85, names(cm$byClass[5]), cex=1.2, font=2)
  text(50, 70, round(as.numeric(cm$byClass[5]), 3), cex=1.2)
  text(70, 85, names(cm$byClass[6]), cex=1.2, font=2)
  text(70, 70, round(as.numeric(cm$byClass[6]), 3), cex=1.2)
  text(90, 85, names(cm$byClass[7]), cex=1.2, font=2)
  text(90, 70, round(as.numeric(cm$byClass[7]), 3), cex=1.2)
  
  # add in the accuracy information 
  text(30, 35, names(cm$overall[1]), cex=1.5, font=2)
  text(30, 20, round(as.numeric(cm$overall[1]), 3), cex=1.4)
  text(70, 35, names(cm$overall[2]), cex=1.5, font=2)
  text(70, 20, round(as.numeric(cm$overall[2]), 3), cex=1.4)
}  
draw_confusion_matrix(cm1)

#Model Export
for(i in 1:10){
  export <- (getTree(model, i, labelVar=FALSE))
  export <- cbind("#"=paste("#",i,sep=""), export)
  write.table(export,"C:\\Users\\***\\Desktop\\titanic_RF.csv",
              row.names=FALSE, sep = ",", append = TRUE, col.names = FALSE)
}
