/*
Numeric Cell Functions Definition
Written by Suvigya Tripathi, 11/21/2014
*/

#include"numericCell.h"

numericCell::numericCell()
{
}

//Constructor setting the value of numeric cell variable
numericCell::numericCell(double val){
	value = val;
}

//Returns the value by converting it into string
std::string numericCell::toString(){
	return std::to_string(value);
}

//Return the value in double
double numericCell::getNumData(){
	return value;
}
