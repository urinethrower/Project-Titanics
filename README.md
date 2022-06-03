# Project-Titanics
Random forest model on classic Titanics dataset, with a C++ twist - inspired by PredictNow.ai (Dr. Ernest Chan)
  
## Overview
* This is a feasibility study towards future development in leveraging machine learning models in developing quantitative trading strategies
* Random forest model was chosen mainly because of its generally lower risk of over-fitting for small datasets, and it is great for performing feature-based analysis
* Classic Titanics dataset is used for simplicity, 89% accuracy was recorded after minimal tuning hyper parameters
* Model is first built in R, output to flat file, parsed with C++, and eventually compiled as `.dll` and imported into MQL4
  
## Modelling in R
* Dataset was downloaded from [Kaggle](https://www.kaggle.com/c/titanic), I have uploaded [here](https://github.com/urinethrower/Project-Titanics/blob/main/titanic.csv)
* Dataset was parted into training and testing sets, to avoid over-fitting
* Hyper perameters like mtry and ntrees are visualised and tuned accordingly:
![ntrees](https://user-images.githubusercontent.com/106392189/171839711-84ca8a9b-58d0-457f-ac22-7ef443f000e5.png)
![mtry](https://user-images.githubusercontent.com/106392189/171839746-6ba82794-5425-471a-842e-9f25d27a1173.png)
  
* Sex (M/F) is the most important feature in prediction, which is in line with other ML models on this dataset:
![variable_importance](https://user-images.githubusercontent.com/106392189/171839998-b61abc41-8ca8-4429-a9e7-d8d1aa07975b.png)
  
* And this is the confusion matrix:
![ConfusionMatrix](https://user-images.githubusercontent.com/106392189/171840101-1674f088-6ebd-4ad8-a669-016c9998df0b.png)
  
* Following my codes, the final step is the model export in `.csv`, uploaded [here](https://github.com/urinethrower/Project-Titanics/blob/main/titanic_RF.csv)
  
## Parsing with C++
  

## Future directions
* To perform feature-based time-series analysis for trading strategies
* Develop algorithmic trading strategies around random forest model
  
## Resources used
* Using the randomForest package in R: [Dr. Bharatendra Rai](https://www.youtube.com/watch?v=dJclNIN-TPo), [StatQuest](https://www.youtube.com/watch?v=6EXPYzbfLCE)
* Visualising with ggplot2 package: [ramhiser](https://gist.github.com/ramhiser/6dec3067f087627a7a85)
* Visualising with caret package: [Cybernetic](https://stackoverflow.com/questions/23891140/r-how-to-visualize-confusion-matrix-using-the-caret-package)
