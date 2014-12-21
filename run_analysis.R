# ----------------------------------------------------------------------- 
#   R program to turn a zipped datafile into a tidy dataset. 
#   Github project: https://github.com/wmo/ds03gcd
#   December 2014
# ---------------------------------------------------------------------- 


# ---------------------------------------------------------------------- 
# Configurable variables 
#
# the input file name 
zipfilename <- "UCI HAR Dataset.zip"
#alternative: zipfilename <- "getdata%2Fprojectfiles%2FUCI HAR Dataset.zip"
#
# the number of observations to read
max_observations=-1 # read all the rows
#max_observations=125 # only the first x rows
# ---------------------------------------------------------------------- 

# load the libraries
library(plyr) 
library(reshape2) # ??? 

# ---------------------------------------------------------------------- 
# Function that reads a file within the zipfile and returns the content
# as a list. 
zippedfile2list <- function(
        zipfilename,       # zipfile that serves as input
        filename_pattern,  # pattern grepped for in list of zipfile entries
        maxlines           # maximum number of lines to be read, set to -1 for all lines
        ) { 
    # get a list of files in the zipfilename
    df_files_in_zip<-unzip(zipfilename, list=T)
    # grep for the filename_pattern in the list of filenames in the zipfile
    entryname=grep(filename_pattern,df_files_in_zip$Name,value=T)

    # keep the user up to date of what's happening
    cat( "Reading entry :", entryname, "\n")

    # open the entry in the zipfile
    con<-unz(zipfilename,entryname)
    f<-readLines(con,n=maxlines)
    close(con)
    # convert it to a list
    lapply(f, function(s) { unlist(strsplit( sub('^  *','',s),'  *')); } )
}


# ---------------------------------------------------------------------- 
# Function that creates a dataframe from the subject, y, and x entries in the zipfile.
zippedfiles2dataframe <- function(
        observation_type, # train or test, will be put in the first column of the dataframe
        zipfilename,          # zipfile that serves as input
        subject_file_pattern, # pattern grepped for in list of zipfile entries for subject_file
        y_file_pattern,       # same as above, but for y_file
        x_file_pattern,       # same as above, but for x_file
        column_names,         # vector that contains the column names for the dataframe
        max_observations      # maximum number of observations to be read, set to -1 for all lines
        ) {
    lsub<-zippedfile2list(zipfilename, subject_file_pattern,max_observations)
    ly<-zippedfile2list(zipfilename, y_file_pattern,max_observations)
    lx<-zippedfile2list(zipfilename, x_file_pattern,max_observations)

    m<-length(lsub) # num observations
    n=length(ly[[1]]) + length(lsub[[1]]) + length(lx[[1]]) # num features

    # first build an array of numbers
    ar<-array(0.0,dim=c(m,n)) 
    for (i in 1:m) {
        ar[i,]=as.numeric(unlist(c(ly[[i]],lsub[[i]],lx[[i]])))
    }

    # the activity column contains the integers of the y-file translated into a factor
    act<-mapvalues( unlist(ly), 
                    from=c(1,2,3,4,5,6), 
                    to=c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", 
                         "SITTING", "STANDING", "LAYING"))

    # turn it into a dataframe
    df<-data.frame(observation_type, act, ar)
    names(df)=colnames
    df
}

# ---------------------------------------------------------------------- 
# Reduce the set of feature names to only those with 'mean' and 'std' in their name. 
# Returns the INDEXES of the selected names. 
get_selected_colname_idx <- function( colnames ) {
    # only remain with the first four columns plus the features regarding mean and standard deviation 
    selcolidx<-append(c(1,2,3,4),sort(union( grep("std", colnames,value=F, ignore.case=T), 
                                             grep("mean",colnames,value=F,ignore.case=T))) )
    # to be removed from the above set: meanFreq() colnames
    tbr<-grep("meanfreq",colnames, value=F, ignore.case=T)
    # make a list of index values to be removed
    tbri<-sapply(tbr, function(x) { which(x==selcolidx)})
    # remove from selcolidx
    selcolidx<-selcolidx[-tbri]
    # index of selected column names
    selcolidx 
}

# -----------------------------------------------------------
# MAIN PART, the processing starts here
#
# step 1; download the datafile if we don't have it already
if(!file.exists(zipfilename)) {
    cat( "Downloading ", zipfilename , "\n")
    fileUrl <- "d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl,destfile=zipfilename,method="curl")
    dateDownloaded <- date()
}


# -----------------------------------------------------------
# step 2: suss out the column names: id columns plus measure names (aka features) 
#
# Read the features text file in the zipfile, and convert the names into 'column-name'-safe variants
# (ie. replace/remove certain characters)
l<-zippedfile2list(zipfilename,"/features.txt", -1)
measure_colnames=unlist(lapply(l,function(x) { gsub( " ","",chartr(",()-","   _",x[2]))} ))
rm(l) # no need for 'l' anymore

# the comprehensive dataframe has id-columns (first 4 columns) and measure columns (the remainder of the columns)
# colnames = id_column_names + measure_colnames
colnames=c( c("observation_type", "activity", "y", "subject" ),  measure_colnames)
rm(measure_colnames) # no need for it anymore


# -----------------------------------------------------------
# step 3: create the comprehensive dataframe
#
# This corresponds to task 1: merge the training and the test sets to create one data set. 
# Also already taken care of in this step are: 
# - task 3: Uses descriptive activity names to name the activities in the data set
# - task 4: Appropriately labels the data set with descriptive variable names.
dfc<-rbind(
    zippedfiles2dataframe("test", zipfilename, 
                          "/subject_test.txt","/y_test.txt","/X_test.txt", 
                          colnames, max_observations)
   ,zippedfiles2dataframe("train", zipfilename, 
                          "/subject_train.txt","/y_train.txt","/X_train.txt", 
                          colnames, max_observations)
   )

# -----------------------------------------------------------
# step 4: subset the data: reduce the number of columns
#
# This corresponds to task 2: extract only the measurements on the mean and 
# standard deviation for each measurement.
dfs<-dfc[,get_selected_colname_idx(colnames)]

# -----------------------------------------------------------
# step 5: create a narrow dataframe by 'melting' the dfs dataframe 
#
dfnrw<- melt(dfs,id=c("activity","subject"),measure.vars = names(dfs)[5:ncol(dfs)])

# create a temporary dataframe from the narrow dataframe
dftmp<-ddply(dfnrw, .(activity,subject,variable ),summarise,mean=mean(value) )

# -----------------------------------------------------------
# step 6: create the final, tidy dataset
#
# Cast the narrow, temporary dataframe back to a wide dataframe.
# This corresponds to task 5: from the data set in step 4, creates a 
# second, independent tidy data set with the average of each variable 
# for each activity and each subject.
df<-dcast(dftmp, activity + subject ~ variable , value.var="mean")

rm(colnames,dftmp)  # no need anymore

# Done, write to file, if needed.
#write.table(df,file="df.txt",row.names=F)              # the to-be-uploaded data
#write.table(names(df),file="colnames.txt",row.names=F) # the column names, used to make the codebook.
