/*
Cell Class 
Written by Suvigya Tripathi, 11/21/2014
*/

#include<string>
#include"list.h"

#ifndef __CELL_H__
#define __CELL_H__

//Polymorphic Base Class Cell
class Cell{

public:
	static unsigned count;
	virtual std::string toString();
	Cell() {
		++count;
	}

	~Cell() {
		--count;
	}
};

#endif