#Codebook

## Dictionary 

#### Activity 

This is the mapping from the integer values in the 'y...' files to the factors. 

     1 WALKING
     2 WALKING_UPSTAIRS
     3 WALKING_DOWNSTAIRS
     4 SITTING
     5 STANDING
     6 LAYING
    
    
## Feature names

The feature or measure names are generated from the text file `UCI HAR Dataset/features.txt` included in the data file.

The transformations applied were (see function 'get_selected_colname_idx()' in 'run_analysis.R': 
- replace '-' (dash) by '_' (underscore)
- drop commas, parenthesis and spaces 

#### CamelCase feature names

Normally tidy data requires column names to be all lowercase, but it was decided against this for the features names, because of legibility reasons. 

Eg. consider following CamelCase column names: 

    angletBodyAccMeangravity 
    angletBodyAccJerkMeangravityMean 
    angletBodyGyroMeangravityMean 

which would be the following in lowercase : 

    angletbodyaccmeangravity 
    angletbodyaccjerkmeangravitymean 
    angletbodygyromeangravitymean 

Which type is more legible? Few people will disagree with the CamelCase being more legible.

### Issues with feature names

It was noted there are duplicate feature names listed in the `UCI HAR Dataset/features.txt`. 

To find the dupes: 

        l<-zippedfile2list(zipfilename,"/features.txt", -1)
        c<-count(unlist(lapply(l,function(x) { x[2]} )))
        c[c$freq>1,]

(note: function zippedfile2list() of run_analysis.R is used in above code, so source that script first)

List of the duplicates feauture names:

        > c[c$freq>1,]
                                           x freq
        8        fBodyAcc-bandsEnergy()-1,16    3
        9        fBodyAcc-bandsEnergy()-1,24    3
        10      fBodyAcc-bandsEnergy()-17,24    3
        11      fBodyAcc-bandsEnergy()-17,32    3
        12        fBodyAcc-bandsEnergy()-1,8    3
        13      fBodyAcc-bandsEnergy()-25,32    3
        14      fBodyAcc-bandsEnergy()-25,48    3
        15      fBodyAcc-bandsEnergy()-33,40    3
        16      fBodyAcc-bandsEnergy()-33,48    3
        17      fBodyAcc-bandsEnergy()-41,48    3
        18      fBodyAcc-bandsEnergy()-49,56    3
        19      fBodyAcc-bandsEnergy()-49,64    3
        20      fBodyAcc-bandsEnergy()-57,64    3
        21       fBodyAcc-bandsEnergy()-9,16    3
        31   fBodyAccJerk-bandsEnergy()-1,16    3
        32   fBodyAccJerk-bandsEnergy()-1,24    3
        33  fBodyAccJerk-bandsEnergy()-17,24    3
        34  fBodyAccJerk-bandsEnergy()-17,32    3
        35    fBodyAccJerk-bandsEnergy()-1,8    3
        36  fBodyAccJerk-bandsEnergy()-25,32    3
        37  fBodyAccJerk-bandsEnergy()-25,48    3
        38  fBodyAccJerk-bandsEnergy()-33,40    3
        39  fBodyAccJerk-bandsEnergy()-33,48    3
        40  fBodyAccJerk-bandsEnergy()-41,48    3
        41  fBodyAccJerk-bandsEnergy()-49,56    3
        42  fBodyAccJerk-bandsEnergy()-49,64    3
        43  fBodyAccJerk-bandsEnergy()-57,64    3
        44   fBodyAccJerk-bandsEnergy()-9,16    3
        162     fBodyGyro-bandsEnergy()-1,16    3
        163     fBodyGyro-bandsEnergy()-1,24    3
        164    fBodyGyro-bandsEnergy()-17,24    3
        165    fBodyGyro-bandsEnergy()-17,32    3
        166      fBodyGyro-bandsEnergy()-1,8    3
        167    fBodyGyro-bandsEnergy()-25,32    3
        168    fBodyGyro-bandsEnergy()-25,48    3
        169    fBodyGyro-bandsEnergy()-33,40    3
        170    fBodyGyro-bandsEnergy()-33,48    3
        171    fBodyGyro-bandsEnergy()-41,48    3
        172    fBodyGyro-bandsEnergy()-49,56    3
        173    fBodyGyro-bandsEnergy()-49,64    3
        174    fBodyGyro-bandsEnergy()-57,64    3
        175     fBodyGyro-bandsEnergy()-9,16    3

Fortunately nothing needs to be done about this, since ..
- none of the duplicate column names are required in the tidy dataset  
- the R processing done in this script, can live with the duplicate colunm names

## Extensive list of column names 

In short: the first two columns of the dataset are the activity and the subject.  The remainder are all numerical features as described in the `features.txt` file included in the zip. 

- **`activity`** :  WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
- **`subject`** : integer value between 1 and 30
- **`tBodyAcc_mean_X`** : feature, numerical 
- **`tBodyAcc_mean_Y`** : feature, numerical 
- **`tBodyAcc_mean_Z`** : feature, numerical 
- **`tBodyAcc_std_X`** : feature, numerical 
- **`tBodyAcc_std_Y`** : feature, numerical 
- **`tBodyAcc_std_Z`** : feature, numerical 
- **`tGravityAcc_mean_X`** : feature, numerical 
- **`tGravityAcc_mean_Y`** : feature, numerical 
- **`tGravityAcc_mean_Z`** : feature, numerical 
- **`tGravityAcc_std_X`** : feature, numerical 
- **`tGravityAcc_std_Y`** : feature, numerical 
- **`tGravityAcc_std_Z`** : feature, numerical 
- **`tBodyAccJerk_mean_X`** : feature, numerical 
- **`tBodyAccJerk_mean_Y`** : feature, numerical 
- **`tBodyAccJerk_mean_Z`** : feature, numerical 
- **`tBodyAccJerk_std_X`** : feature, numerical 
- **`tBodyAccJerk_std_Y`** : feature, numerical 
- **`tBodyAccJerk_std_Z`** : feature, numerical 
- **`tBodyGyro_mean_X`** : feature, numerical 
- **`tBodyGyro_mean_Y`** : feature, numerical 
- **`tBodyGyro_mean_Z`** : feature, numerical 
- **`tBodyGyro_std_X`** : feature, numerical 
- **`tBodyGyro_std_Y`** : feature, numerical 
- **`tBodyGyro_std_Z`** : feature, numerical 
- **`tBodyGyroJerk_mean_X`** : feature, numerical 
- **`tBodyGyroJerk_mean_Y`** : feature, numerical 
- **`tBodyGyroJerk_mean_Z`** : feature, numerical 
- **`tBodyGyroJerk_std_X`** : feature, numerical 
- **`tBodyGyroJerk_std_Y`** : feature, numerical 
- **`tBodyGyroJerk_std_Z`** : feature, numerical 
- **`tBodyAccMag_mean`** : feature, numerical 
- **`tBodyAccMag_std`** : feature, numerical 
- **`tGravityAccMag_mean`** : feature, numerical 
- **`tGravityAccMag_std`** : feature, numerical 
- **`tBodyAccJerkMag_mean`** : feature, numerical 
- **`tBodyAccJerkMag_std`** : feature, numerical 
- **`tBodyGyroMag_mean`** : feature, numerical 
- **`tBodyGyroMag_std`** : feature, numerical 
- **`tBodyGyroJerkMag_mean`** : feature, numerical 
- **`tBodyGyroJerkMag_std`** : feature, numerical 
- **`fBodyAcc_mean_X`** : feature, numerical 
- **`fBodyAcc_mean_Y`** : feature, numerical 
- **`fBodyAcc_mean_Z`** : feature, numerical 
- **`fBodyAcc_std_X`** : feature, numerical 
- **`fBodyAcc_std_Y`** : feature, numerical 
- **`fBodyAcc_std_Z`** : feature, numerical 
- **`fBodyAccJerk_mean_X`** : feature, numerical 
- **`fBodyAccJerk_mean_Y`** : feature, numerical 
- **`fBodyAccJerk_mean_Z`** : feature, numerical 
- **`fBodyAccJerk_std_X`** : feature, numerical 
- **`fBodyAccJerk_std_Y`** : feature, numerical 
- **`fBodyAccJerk_std_Z`** : feature, numerical 
- **`fBodyGyro_mean_X`** : feature, numerical 
- **`fBodyGyro_mean_Y`** : feature, numerical 
- **`fBodyGyro_mean_Z`** : feature, numerical 
- **`fBodyGyro_std_X`** : feature, numerical 
- **`fBodyGyro_std_Y`** : feature, numerical 
- **`fBodyGyro_std_Z`** : feature, numerical 
- **`fBodyAccMag_mean`** : feature, numerical 
- **`fBodyAccMag_std`** : feature, numerical 
- **`fBodyBodyAccJerkMag_mean`** : feature, numerical 
- **`fBodyBodyAccJerkMag_std`** : feature, numerical 
- **`fBodyBodyGyroMag_mean`** : feature, numerical 
- **`fBodyBodyGyroMag_std`** : feature, numerical 
- **`fBodyBodyGyroJerkMag_mean`** : feature, numerical 
- **`fBodyBodyGyroJerkMag_std`** : feature, numerical 
- **`angletBodyAccMeangravity`** : feature, numerical 
- **`angletBodyAccJerkMeangravityMean`** : feature, numerical 
- **`angletBodyGyroMeangravityMean`** : feature, numerical 
- **`angletBodyGyroJerkMeangravityMean`** : feature, numerical 
- **`angleXgravityMean`** : feature, numerical 
- **`angleYgravityMean`** : feature, numerical 
- **`angleZgravityMean`** : feature, numerical 
