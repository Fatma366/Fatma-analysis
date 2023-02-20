#!/bin/bash

#the length of the finonacci sequence
echo "Enter the number of terms in the Fibonacci sequence:"
read n
# to compute the Fibonacci numbers function fib
#First Number of the Fibonacci Series
a=0
# Second Number of the Fibonacci Series
b=1
#display the line of texts
echo "Fibonacci sequence:"

#loop through the sequence from 0 as the first index to 8 terms
for (( i=0; i<n; i++ ))
do
    fn=$((a + b))
    a=$b
    b=$fn
    echo "$fn "
done
# End of for loop
