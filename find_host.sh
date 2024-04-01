#!/bin/bash
###########################
#
#   Created by Francesco Alongi in 30/03/2023
#   Version 0.1
#
#   The script read a txt file wich contains a series of ip or hostname and write in a csv file if are reaceble or not.
#   For the ip script recover also the hostname. 
#   The variable N_PING contain the number of request we want make, the variable FILE contain the name of the file we want read.
#   Make sure the file we want read and conteins the list of ip is in the same directory of the script
#
###########################

FILE="host.txt"     # Input file containing a list of hosts
CURRENT_TIME=$(date +"%Y_%m_%d_%H_%M")   
N_PING=5

READ_TXT () {
# This function read the file txt in FILE variable, and pass output to the next function
    IFS=$'\n'   # Separatore
    for LINE in $(cat $FILE)
    do 
        echo $LINE
    done
}

FIND_HOST_INFORMATION () {
# This function call the previous function in a for cicle, query the IP and write the answer, if the answer is 0 the ip is reachable otherwise is not.
    echo "Start Scan"
    echo "--------------"
    echo "IP,Hostname, Reachable" > "Risultato_$CURRENT_TIME.csv" # This command create a csv file and a header line
    for LINE in $(READ_TXT)
    do
        ping -c $N_PING $LINE >> /dev/null
        if [[ $(echo $?) = 0 ]];then
            echo -e "Host: " $LINE "reachable"
            echo -e "$LINE, $(host $LINE|cut -d " " -f5), yes" >> "Risultato_$CURRENT_TIME.csv"
        else
            echo -e "Host: " $LINE "no reachable"
            echo -e "$LINE,$(host $LINE|cut -d " " -f5), no" >> "Risultato_$CURRENT_TIME.csv"
        fi
    done
    echo "--------------"
    echo "End scann"
}

FIND_HOST_INFORMATION
