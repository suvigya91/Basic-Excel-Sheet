/*
Numeric Cell Header inheriting Base class= Cell
written by Suvigya Tripathi, 11/23/2014
*/
#include"cell.h"

class numericCell :public Cell{
private:
	double value = 0;
public:
	numericCell();
	numericCell(double val);
	std::string toString();
	double getNumData();

	~numericCell(){}
};