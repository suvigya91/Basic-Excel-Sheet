/*
FunctionCell class header file
Written by Suvigya Tripathi, 11/23/2014
*/

#include"numericCell.h"

#ifndef __FUNCTIONCELL_H__
#define __FUNCTIONCELL_H__


class functionCell :public numericCell{
private:
	int row = 0;
	int column = 0;
	int rowValue = 0;
	int beginOffset = 0;
	int endOffset = 0;
	double funcValue = 0;
	std::string type;
	double m = 0;
	LList<LList<Cell*>>* myList;
public:
	functionCell(double, LList<LList<Cell*>>* lstptr, int r, int c, int rowVal, int beginOff, int endOff, std::string commandType);
	functionCell(double, int r, int c, int rowVal, int beginOff, int endOff, std::string commandType);
	functionCell(double val);
	std::string toString();
	double getFuncData();
	std::string getType();


	void max(LList<LList<Cell*>>* lstptr);
	void min(LList<LList<Cell*>>* lstptr);
	void mean(LList<LList<Cell*>>* lstptr);

	~functionCell(){}
};
#endif