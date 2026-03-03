#! bin/bash

number1=20
number2=2


if [ $number1 -eq $number2 ]
then 

sum=$(($number1 + $number2))
number3=$sum

echo "here is $number3 "

else 

echo "$number3 is not equal to $number1"

fi


