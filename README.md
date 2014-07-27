Instructions to run the script and produce the expected result
=================

1.  Create a file named CourseProject in your hard disk.

2.  Set this directory as the working directory by running the R command setwd in R command line.
	  For example if the directory is "C:\CourseProject" then the R command must be:
  	setwd("C:/CourseProject")

3.  In this directory unzip the zipped file named "getdata-projectfiles-UCI HAR Dataset" that contains the dataset provided.   	Now a file named UCI HAR Dataset that contains the entire dataset must be present.
 
4.  Also, in the same directory download and insert the script run_analysis.R from my Github repository (...).

5.  Run the script with the command source(). For example if directory is  "C:/CourseProject" the run the R command:
	  source('C:/CourseProject/run_analysis.R')

6.  Two datasets files are going to be created in the directory. The first one, named "tidy_dataset1", is the tidy dataset 
	  that was created after following instructions of steps 1-4 of the course project. The second one, named "tidy_dataset2",     is the tidy dataset that was created after following the instructions of step 5.
