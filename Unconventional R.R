#Unconventional R.  18 November 2015: SESYNC Pet Share example
#1. Basics
#2. Read in data
#2. Look at the data
#2. Summary stats
#3. Basic plots
#4. Sorting, filtering
#5. Reshaping data
#6. Merging and matching 

#==============================================================================
#1. Basic operations
#examples
1 + 1
sum(5,10)
sum(5,10)*mean(5,10)
# the number sign allows you to write text that R will not run.


#Packages
install.packages('readxl')      # Download and install a package (e.g.readxl) you want to use.Packages are special 'add-ons' that contain specific functions of interest. Only need to install once.
library(readxl)                 # Lets R know you want to use functions from a package (e.g.readxl) you downloaded. 
                                # Library function activates the package, you will need to use it once every R session 
#==============================================================================
#2. Read in data (look at presentation slides for code) 
Pet_exp <- read.csv(file="Z:/Unconventional R/Pet expenses.csv", header=T) #read in csv file as a data frame called 'Pet_exp'

# Someone sent species names as an excel file and not a csv!
# Look here for some code from October CSI: https://github.com/SESYNC-ci/oct2015-workshop/blob/master/cleaning_raw_data.md
library(readxl)                                                      # activate readxl package
Pet_sp <- read_excel("Z:/Unconventional R/Pet species.xlsx",         
                         sheet = 1, col_names = FALSE)               # read in the 1st sheet from an Excel file as a dataframe called 'Pet_sp'. NB: Leave a comma at the end of a function if you want want the function to continue to the next line so you won't have to scroll all the way to the right like you are doing now.
#==============================================================================
#3. Look at data
Pet_exp        # print out object in console below
View(Pet_exp)  # view object (usually data frame) in a new window
head(Pet_exp)  # quick peak at top 5 rows
dim(Pet_exp)   # how many rows and columns?
str(Pet_exp)   # what is the structure of each variable (column)?
names(Pet_exp) # names of the variables (columns)

head(Pet_sp)
#seems like the col_names function was to keep the column headings. Try again, with col_names=TRUE
Pet_sp <- read_excel("Z:/Unconventional R/Pet species.xlsx",
                     sheet = 1, col_names = TRUE)
head(Pet_sp)
#==============================================================================
#2. Summary stats
summary(Pet_exp)                             # quick summary of each column (variable) in the dataframe called Pet_exp
sum(Pet_exp$Jampel)                          # How much did Jampel spend altogether? Sums all values in Pet_exp for the variable/column called Jampel.
sum(Pet_exp$Kristal)                         # How much did Kristal spend?
sum(Pet_exp$Joe) -sum(Pet_exp$Matt)          # How much more did Joe spend than Matt?
library(psych)                               # Load the psych package for some useful functions to summarise data, like describe() 
describe(Pet_exp)                            # More detailed info
colSums(Pet_exp)                             # Sums of all the values in each column
colSums(Pet_exp[,-1])                        # Sums of all values in each column except for the 1st one
#==============================================================================
#3. Basic plots
pairs(Pet_exp[,-1])                     # scatterplot with all numeric variables
plot(x=Pet_exp$Jampel,y=Pet_exp$Bill)   # scatter plot
plot(x=Pet_exp$Jampel,y=Pet_exp$Bill,
     xlab='Jampel',ylab='Bill',
     main='Bill vs Jampel')             # scatter plot with labels
lm(Jampel~Bill,data=Pet_exp)            # linear model of Bill vs Jampel
BJ <- lm(Jampel~Bill,data=Pet_exp)      # save linear model as an object
summary(BJ)                             # summary of the linear model for more info (coefficients, p values, etc)
abline(BJ)                              # add linear model to plot
Totals <- colSums(Pet_exp[,-1])         # create an object with the column/variable totals
barplot(Totals)                         # create a simple barplot

#4. Sorting, filtering
#More code at: https://github.com/SESYNC-ci/oct2015-workshop/blob/master/data_processing.Rmd
Ordered_exp <- Pet_exp[order(Pet_exp$Pet),]            # order the data
Ordered_exp
subset(Pet_exp,Pet=='Jasper')                          # filter the data


#5. Reshaping data
#Useful to summarise data in columns that you want to aggregate into a single column (function melt() melts the columns like an ice cream). dcast() spreads them out like casting a fishing line.
head(Pet_exp)                                   # peak at the data
library(reshape2)                               # need this package to reshape the data
Exp_melt <- melt(Pet_exp,id.vars = 'Pet')       # melt all the columns into 1 column/variable except for the column 'Pet'
View(Exp_melt)                                  # take a look at it in a new window
names(Exp_melt) <- c('Pet','Sitter','Expense')  # change the names of the columns/variables
head(Exp_melt)

aggregate(data=Exp_melt,Expense~Pet,FUN=mean)                       # average expense per pet
aggregate(data=Exp_melt,Expense~Pet+Sitter,FUN=mean)                # average expense per pet per sitter
Pet_means <- aggregate(data=Exp_melt,Expense~Pet,FUN=mean)          # create dataframe object
barplot(Pet_means$Expense,names.arg = Pet_means$Pet)                # bar plot of mean expenditure per pet

#6. Merging and matching 
head(Exp_melt)
head(Pet_sp)
merged_Pet<- merge(Exp_melt, Pet_sp, by.x = 'Pet', by.y = 'Name',)  # merge 2 dataframes that share an identifying variable/column. by.x is the variable in the 1st dataframe you want to match,by.y is the column/variable in the other. 
head(merged_Pet)
aggregate(data=merged_Pet,Expense~Species,FUN=sum)                       # average expenses per species
Species_total <- aggregate(data=merged_Pet,Expense~Species,FUN=mean)     # save as dataframe object
barplot(Species_total$Expense,names.arg = Species_total$Species)         # plot the average expenses by species

#Bonus: t test
t.test(merged_Pet$Expense~merged_Pet$Species)                            # do a t-test

#Save an object you created as a csv that you can open in Excel.
write.csv(merged_Pet,"Z:/merged pet.csv",row.names = FALSE)

#Test out Rcmdr
install.packages('Rcmdr')   
library(Rcmdr)
