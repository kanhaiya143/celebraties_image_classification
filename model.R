# Load Packages
library(EBImage)
library(keras)


# Read images
getwd()
setwd('C:/Users/lenovo/Documents/DataSet') 

pics=c('1 (1).jpeg','1 (2).jpg','1 (3).jpg','1 (4).jpg','1 (5).jpg','6 (1).jpg','6 (2).jpg','6 (3).jpg','6 (4).jpg','6 (5).jpg','7 (1).jpg','7 (2).jpg','7 (3).jpg','7 (4).jpg','7 (5).jpg',
       '16 (1).jpeg','16 (2).jpg','16 (3).jpeg','16 (4).jpeg','16 (5).jpg','18 (1).jpg','18 (2).jpg','18 (3).jpg','18 (4).jpg','18 (5).jpg','22 (1).jpeg','22 (2).jpg','22 (3).jpg','22 (4).jpg','22 (5).jpg',
       '24 (1).jpg','24 (2).jpg','24 (3).jpg','24 (4).jpg','24 (5).jpg','32 (1).jpeg','32 (2).jpg','32 (3).jpg','32 (4).jpg','32 (5).jpg','44 (1).jpg','44 (2).jpg','44 (3).jpg','44 (4).jpg','44 (5).jpg',
       '45 (1).jpg','45 (2).jpg','45 (3).jpg','45 (4).jpg','45 (5).jpg','47 (1).jpg','47 (2).jpg','47 (3).jpg','47 (4).jpg','47 (5).jpg','54 (1).jpg','54 (2).jpg','54 (3).jpg','54 (4).jpg','54 (5).jpg',
       '59 (1).jpg','59 (2).jpg','59 (3).jpg','59 (4).jpg','59 (5).jpg','69 (1).jpeg','69 (2).jpg','69 (3).jpg','69 (4).jpg','69 (5).jpg')
mypic=list()
for(i in 1:70){mypic[[i]]=readImage(pics[i])}

# Resize
for (i in 1:70) {mypic[[i]] <- resize(mypic[[i]], 28, 28)}
library(reticulate)
str(mypic)
# Reshape
for (i in 1:70) {mypic[[i]] <- array_reshape(mypic[[i]], c(28, 28,3))}




# Row Bind
trainx <- NULL
for (i in 1:70) {trainx <- rbind(trainx, mypic[[i]])}
trainy <- c(0,0,0,0,0,1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,5,5,5,5,5,6,6,6,6,6,7,7,7,7,7,8,8,8,8,8,9,9,9,9,9,10,10,10,10,10,11,11,11,11,11,12,12,12,12,12,13,13,13,13,13)
testy <- c(0,1)                                                
# 0 for plane
# 1 for car
# One Hot Encoding
trainLabels <- to_categorical(trainy)
testLabels <- to_categorical(testy)

levels(trainLabels)

###################################

# Model
create_model <- function() {
model <- keras_model_sequential()
model %>%
  layer_dense(units = 256, activation = 'relu', input_shape = c(2352)) %>%       # 28*28*3 = 2352
  layer_dense(units = 128, activation = 'relu') %>%
  layer_dense(units = 14, activation = 'softmax')


# Compile
model %>%
  compile(loss = 'binary_crossentropy',
          optimizer = optimizer_rmsprop(),
          metrics = c('accuracy'))

# Fit Model
history <- model %>%
  fit(trainx,
      trainLabels,
      epochs = 30,
      batch_size = 32,
      validation_split = 0.2)
model
}
plot(history)

####test

test=readImage('test.jpg')
dim(test)
test=resize(test,28,28)
test=array_reshape(test,c(28,28,3))
test=rbind(test)
dim(test)
pred1 <- model %>% predict_classes(test)
pred1


model <- create_model()

model %>% fit(trainx,
              trainLabels,
              epochs = 30,
              batch_size = 32,
              validation_split = 0.2)
model %>% save_model_hdf5("myR_model.h5")

######xxxxxxxxxxxxxxx
model %>% evaluate(trainx , trainLabels)

pred1 <- model %>% predict_classes(trainx)
table(Predicted = pred, Actual = trainy)
prob <- model %>% predict_proba(trainx)
cbind(prob, Prected = pred, Actual= trainy)
