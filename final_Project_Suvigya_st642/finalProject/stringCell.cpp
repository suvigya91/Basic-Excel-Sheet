/*
String Cell Functions Definition
Written by Suvigya Tripathi, 11/21/2014
*/

#include"stringCell.h"

stringCell::stringCell(std::string& str){
	strValue = str;
}

//Returns the string value
std::string stringCell::toString(){
	return strValue;
}
