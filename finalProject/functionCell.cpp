/*
Function Cell defination. Inherits NumericCell
Calculates min, max and mean
Written by Suvigya Tripathi, 11/23/2014
*/


#include"functionCell.h"

//Return the type of operation to be performed (min/max/mean)
std::string functionCell::getType(){
	return type;
}

/*Constructor to set the initial values of row, column, row value, begin offset, end offset and type of string, gives a call
	to max()/min()/mean() depending on type of string
*/
functionCell::functionCell(double fVal, LList<LList<Cell*>>* rows, int r, int c, int rowVal, int beginOff, int endOff, std::string commandType) :numericCell(){
	functionCell::funcValue = fVal;
	functionCell::row = r;
	functionCell::column = c;
	functionCell::rowValue = rowVal;
	functionCell::beginOffset = beginOff;
	functionCell::endOffset = endOff;
	functionCell::type = commandType;
	myList = rows;

	if (commandType == "max"){
		functionCell::max(rows);
	}
	if (commandType == "min"){
		functionCell::min(rows);
	}
	else if (commandType == "mean"){
		functionCell::mean(rows);
	}
}


/*Constructor to set the values of functionValue, row, column, row value, begin offset, end offset and type of string
*/

functionCell::functionCell(double val, int r, int c, int rowVal, int beginOff, int endOff, std::string commandType) :numericCell(val){
	funcValue = val;
	functionCell::row = r;
	functionCell::column = c;
	functionCell::rowValue = rowVal;
	functionCell::beginOffset = beginOff;
	functionCell::endOffset = endOff;
	functionCell::type = commandType;
}


/*
Constructor to set function value when there is no numeric cell or string cell 
*/
functionCell::functionCell(double val) :numericCell(val){
	funcValue = val;
}

std::string functionCell::toString(){
	return std::to_string(funcValue);
}

double functionCell::getFuncData(){
	return funcValue;
}

/*
Calculates maximum 
*/
void functionCell::max(LList<LList<Cell*>>* myList){
	int h1 = 0;
	double max = 2.22507e-308;

	/*
	Iterates over loop the spreadsheet
	*/
	for (LList<LList<Cell*>>::iterator I = myList->begin(); I != myList->end(); I++) {

		int w = 0;
		/*
			If height is equal to the rowValue. 
		*/
		if (h1 == rowValue){
			for (LList<Cell*>::iterator J = (*I).begin(); J != (*I).end(); J++){
				//Reached the offset of the numeric cell which is used to calculate max
				if (w == beginOffset){
					for (int w = beginOffset; w <= endOffset; w++, J++){
						//checks if the location has numeric call
						if (dynamic_cast<numericCell*>(*J) != NULL){
							//stores the current value from numeric cell
							double currValue = dynamic_cast<numericCell*>(*J)->getNumData();
							//checks if max is less than current value and if less, store max to current value
							if (max < currValue){
								max = currValue;
							}
						}
					}
					break;
				}
				w++;
			}
		}
		h1++;
	}


	int h2 = 0;
	for (LList<LList<Cell*>>::iterator I = myList->begin(); I != myList->end(); I++) {
		h2++;
		int w2 = 0;
		for (LList<Cell*>::iterator J = (*I).begin(); J != (*I).end(); J++){
			w2++;
			//checks if it reached the location where functional cell is set
			if (h2 == row && w2 == column){
				//deletes the current cell and replace it with new functional cell
				delete *J;
				*J = new functionCell(max, row, column, rowValue, beginOffset, endOffset, type);
				//if it has no numeric cell or string cell, set functional cell as NaN
				if (max == 2.22507e-308){
					m = std::numeric_limits < double >::quiet_NaN();
					delete *J;
					*J = new functionCell(m);
				}
			}
		}
	}
}

//Calculates Minimum
void functionCell::min(LList<LList<Cell*>>*lstptr){
	int h1 = 0;
	double min = 1.79769e+308;
	for (LList<LList<Cell*>>::iterator I = lstptr->begin(); I != lstptr->end(); I++) {

		int w = 0;
		if (h1 == rowValue){
			for (LList<Cell*>::iterator J = (*I).begin(); J != (*I).end(); J++){
				if (w == beginOffset){
					for (int w = beginOffset; w <= endOffset; w++, J++){
						if (dynamic_cast<numericCell*>(*J) != NULL){
							double currValue = dynamic_cast<numericCell*>(*J)->getNumData();
							if (min > currValue){
								min = currValue;
							}
						}
					}
					break;
				}

				w++;
			}
		}
		h1++;
	}


	int h2 = 0;

	for (LList<LList<Cell*>>::iterator I = lstptr->begin(); I != lstptr->end(); I++) {
		h2++;
		int w2 = 0;
		for (LList<Cell*>::iterator J = (*I).begin(); J != (*I).end(); J++){
			w2++;
			if (h2 == row && w2 == column){
				delete *J;
				*J = new functionCell(min, row, column, rowValue, beginOffset, endOffset, type);
				if (min == 1.79769e+308){
					m = std::numeric_limits < double >::quiet_NaN();
					delete *J;
					*J = new functionCell(m);
				}
			}
		}
	}
}

//Calculates mean
void functionCell::mean(LList<LList<Cell*>>* lstptr){
	int h1 = 0;
	double sum = 0;
	int count = 0;
	for (LList<LList<Cell*>>::iterator I = lstptr->begin(); I != lstptr->end(); I++) {

		int w = 0;
		if (h1 == rowValue){
			for (LList<Cell*>::iterator J = (*I).begin(); J != (*I).end(); J++){
				if (w == beginOffset){
					for (int w = beginOffset; w <= endOffset; w++, J++){
						if (dynamic_cast<numericCell*>(*J) != NULL){
							double currValue = dynamic_cast<numericCell*>(*J)->getNumData();
							sum = sum + currValue;
							count++;
						}
					}
					break;
				}
				w++;
				count++;
			}
		}
		h1++;
	}


	int h2 = 0;

	for (LList<LList<Cell*>>::iterator I = lstptr->begin(); I != lstptr->end(); I++) {
		h2++;
		int w2 = 0;
		for (LList<Cell*>::iterator J = (*I).begin(); J != (*I).end(); J++){
			w2++;
			if (h2 == row && w2 == column){
				delete *J;
				*J = new functionCell(sum / count);
				if (sum == NULL){
					delete *J;
					m = std::numeric_limits < double >::quiet_NaN();
					*J = new functionCell(m);
				}
			}
		}
	}
}
