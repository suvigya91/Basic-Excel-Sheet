/*
String Cell Header inheriting Base class= Cell
written by Suvigya Tripathi, 11/24/2014
*/

#include"cell.h"

#ifndef __STRINGCELL_H__
#define __STRINGCELL_H__

class stringCell :public Cell{
private:
	std::string strValue;
public:
	stringCell(std::string& str);
	std::string toString();

	~stringCell(){}
};
#endif