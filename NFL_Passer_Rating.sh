#!/bin/bash
# Version 1.0 5/30/2017 drmmeattornado (https://github.com/drmeattornado)
# 
# A portable bash script to calculate NFL and CFL passer ratings based on user input data.  
# Planning on entering NFL.com API info to automate process at a later date.
# Why did I do this when it's already calculated on NFL.com and elsewhere?  Because I can!

# At least 1 attempt must be entered or else the calculation will not work 
echo -en "Enter the total number of attempts:\t\t"
read attempts
if [[ $attempts -lt 1 ]] ; then
    echo "Enter at least one attempt in order to calculate a passer rating"
	echo -en "Enter the total number of attempts:\t\t"
	read attempts
fi

# Checks for whether the number of completions is greater than attempts.  If that is true, the script exits.
# You can't have more completions than attempts.
echo -en "Enter the total number of completions:\t\t"
read completions
if [[ $completions == "" ]] ; then
    completions="0"
fi
if [[ $completions -gt $attempts ]] ; then
    echo -e "The number of completions\n"
    echo -e "exceeds the number of\n"
    echo -e "attempts, enter the correct\n"
    echo -e "value and try again."
    exit 1
fi

# Enter total passing yards.  The default is 0.  Yes it is possible to net 0 yards on a pass completion.
echo -en "Enter the total number of passing yards:\t"
read yards
if [[ $yards == "" ]] ; then
    yards="0"
fi
 
# Enter total touchdown passes (Not rushing TD's). The default is 0.
echo -en "Enter the total number of touchdown passes:\t"
read touchdowns
if [[ $touchdowns == "" ]] ; then
    touchdowns="0"
fi
 
# Enter total number of interceptions.  The default is 0.
echo -en "Enter the total number of interceptions:\t"
read interceptions
if [[ $interceptions == "" ]] ; then
    interceptions="0"
fi
 
# Here is the formula taken from Wikipedia: https://en.wikipedia.org/wiki/Passer_rating#NFL_and_CFL_formula
# The are 4 parts to the calculation and then a final calculation to get the actual rating.
# a = ( Completions / Attempts - .3 ) x 5
# b = ( Yards / Attempts - 3 ) x .25
# c = ( Touchdowns / Attempts ) x 20
# d = ( 2.375 - (Interceptions / Attempts x 25 )
# Passer Rating = ( (a + b + c + d) / 6 ) x 100

# Part a
a=$(echo -e $completions $attempts | awk -v completions=$completions -v attempts=$attempts '{ print (((completions / attempts) - 0.3 ) * 5 ) }')

# Added the completion percentage just for fun
completepercentage=$(echo -e $completions $attempts | awk -v completions=$completions -v attempts=$attempts '{ printf("%3.1f",(completions / attempts) * 100 ) }')
echo -e "Completion Percentage is:\t\t\t$completepercentage%"

# Part b
b=$(echo -e $yards $attempts | awk -v yards=$yards -v attempts=$attempts '{ print ((yards/attempts - 3) * 0.25) }')

# Part c
c=$(echo -e $touchdowns $attempts | awk -v touchdowns=$touchdowns -v attempts=$attempts '{ print (( touchdowns / attempts ) * 20 ) }')

# Part d
d=$(echo -e $interceptions $attempts | awk -v interceptions=$interceptions -v attempts=$attempts '{ print 2.375 - ( interceptions / attempts * 25 ) }')

# Calculate the passer rating then printing the output to STDOUT.
output=$(echo $a $b $c $d | awk -v a=$a -v b=$b -v c=$c -v d=$d '{ printf("%3.1f",((a + b + c + d) / 6 * 100 )) }')
echo -e "The Quarterback Passer Rating is:\t\t$output"
echo -e "********Any rating above 158.3 is considered a Perfect Rating and rated as 158.3********"
exit 0