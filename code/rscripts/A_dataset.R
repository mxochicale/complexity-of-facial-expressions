###############################################################################	
#
# Create dataset for openface  features
# 
#
#
#
#
# Miguel P Xochicale [http://mxochicale.github.io]
#
###############################################################################	
	# OUTLINE:
	# (0) Loading libraries and functions
 	# (1) Definifing paths and Reading data
	# (2) Data Filtering
		# (2.1) Windowing
	# (4) Creating Preprossed Data Path
	# (5) Writing Data



#################
# Start the clock!
start.time <- Sys.time()


################################################################################
# (0) Loading Functions and Libraries and Setting up digits
library(data.table) # for manipulating data
library(ggplot2) # for plotting 




################################################################################
# (1) Defining paths for main_path, r_scripts_path, ..., etc.

homepath <- Sys.getenv("HOME") 
r_scripts_path <- getwd()
setwd("../../")
repository_path <- getwd()


##VERSION 
version <- '00'
feature_path <- '/dataset'

### Outcomes Data Path
outcomes_data_path <- paste(repository_path,'/data', feature_path, '/v', version, sep="")
### Raw Data Path
data_path <- paste(repository_path, '/data/rawdata',sep="")




################################################################################
# (1) Setting DataSets paths and reading data
setwd(data_path)
data_path_list <- list.dirs(path = ".", full.names = TRUE, recursive = TRUE)

participantsNN <- 1
trialsNN <- 3
trial_index <- c(3,5,7)


pNNtNN_tmp  <- NULL ## initialise variable

#forSTART......... to read data from participants paths
for(participants_k in 1:participantsNN)
{

	#forSTART......... to read data from trials paths
	for(trials_k in 1:trialsNN)
	{

	participant_NN_path <-  substring( (toString(data_path_list[ trial_index[trials_k] ])) , 2, last = 1000000L)
	full_participant_NN_path <- paste(data_path, participant_NN_path, "/",sep="")
	message(' PATH for PARTICIPANT=', participants_k, '   TRIAL=',  trials_k,'  : ', full_participant_NN_path )
	setwd( full_participant_NN_path )



	details = file.info(list.files(pattern=""))
	files = rownames(details)


    	# Particpant Number
	pNNtNN_ <-  paste("p", participants_k, 't', trials_k, sep="")
    	assign (pNNtNN_, fread(  files[2] , header = TRUE, sep=',') )
    	temp <- get(pNNtNN_)
 
	# add particpant
	func <-function(x) {list( participants_k )} 
	temp[,c("participant"):=func(), ]
	setcolorder(temp,c(432,1:431) )

	#add trial
	func <-function(x) {list( trials_k )} 
	temp[,c("trial"):=func(), ]
	setcolorder( temp,c(1,433,2:432) )
	pNNtNN_tmp <- rbind(pNNtNN_tmp, temp)


	}
	#forEND......... to read data from trials paths


}
#forEND......... to read data from participants paths


###### dataTable
datatable <- pNNtNN_tmp











################################################################################
# (2) Data Filtering

################################
### (2.1) Windowing Data [xdata[,.SD[1:2],by=.(Participant,Activity,Sensor)]]
windowframe = 002:280;
xdata <- datatable[,.SD[windowframe],by=.(participant,trial)];



#################################################################################
## (4) Creating Preprossed Data Path
#

if (file.exists(outcomes_data_path)){
    setwd(file.path(outcomes_data_path))
} else {
  dir.create(outcomes_data_path, recursive=TRUE)
  setwd(file.path(outcomes_data_path))
}


################################################################################
####  (5)  Writing Data
write.table(xdata, "rawopenfacedata.datatable", row.name=FALSE)

message('datatable file has been created at '  )
message (outcomes_data_path)


#################
# Stop the clock!
end.time <- Sys.time()
end.time - start.time

################################################################################
setwd(r_scripts_path) ## go back to the r-script source path


