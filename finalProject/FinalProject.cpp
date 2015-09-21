/*
Final Project 
Prints a spreadsheet with Numeric cell, function cell and string cell.
Calculates min, max and mean of numeric cells excluding string cell.
It also updates min, max or mean if numeric cell they are depending is changed.

Written by Suvigya Tripathi, 11/21/2014
*/

#include<iostream>
#include<sstream>
#include<string>
#include<exception>
#include"functionCell.h"
#include"stringCell.h"
static int width;
static int height;

/****************************************************************************************************/
/*Updating Cells!!
	Spreadsheet is iterated over rows and columns and each cell is checked if it is Functional Cell
	using dynamic_caste. The values in functional cell gets updated if the values in numeric cells
	are modified.
	*/
void updateSheet(LList<LList<Cell*>>*rows){
	for (LList<LList<Cell*>>::iterator A = rows->begin(); A != rows->end(); A++){
		for (LList<Cell*>::iterator B = (*A).begin(); B != (*A).end(); B++){
			functionCell* n;
			n = dynamic_cast<functionCell*>(*B);

			//If the cell is functional, it dynamic_caste will not be NULL
			if (n != NULL){
				/* If the cell is functional cell, operation performed over the cell is obtained by
				   using getType() function of Functional Cell. getType() returns string of max/min or mean
				   */
				if (n->getType() == "max"){
					(dynamic_cast<functionCell*>(*B))->max(rows);
				}

				else if (n->getType() == "min"){
					(dynamic_cast<functionCell*>(*B))->min(rows);
				}

				else if (n->getType() == "mean"){
					(dynamic_cast<functionCell*>(*B))->mean(rows);
				}
			}
		}
	}
}

/****************************************************************************************************/
/*Printing list
	The spreadsheet is iterated over height and width. The value to be printed is obtained using
	toString(). toString() returns the values of each cell in string format.
	*/
void printList(LList<LList<Cell*>>& rows){
	for (LList<LList<Cell*>>::iterator I = rows.begin(); I != rows.end(); I++) {
		for (LList<Cell*>::iterator J = (*I).begin(); J != (*I).end(); J++)
		{
			if (*J == (*I).back()){
				std::cout << (*J)->toString();
			}
			else{
				std::cout << (*J)->toString() << ",";
			}
		}
		std::cout << '\n';
	}
}

/****************************************************************************************************/
/*Replacing Base cell by numeric cell/ string cell/ function cell
	Empty spreadsheet has each element of Cell type, which is replaced by numericCell/stringCell/
	functionalCell based on the input arguments. Input Areguments:
	1) "number" -> numericCell
	2) "string" -> stringCell
	3) "max/min/mean" -> functionalCell
	*/
void insertNewCell(LList<LList<Cell*>>& rows, std::string& command, int column, int row, std::istringstream& ss, std::string& commandType){
	int h = 0;
	for (LList<LList<Cell*>>::iterator I = rows.begin(); I != rows.end(); I++) {
		h++; //keeps the track of Iteration over height or number of rows
		int w = 0; //keeps the track of Iteration over width or number of columns and always sets to 0 for new row
		for (LList<Cell*>::iterator J = (*I).begin(); J != (*I).end(); J++){
			w++;

			/*If row and column iterated equals to the value of row and column in user input, compare the type of
			  cell to be inserted (numericCell/stringCell/functionalCell)
			  */
			if (h == row && w == column){

				//If user input command is string type, create stringCell on that particular position
				if (commandType == "string"){
					delete *J;
					*J = new stringCell(command);
				}

				//If user input command is number type, create numericCell on that particular position
				else if (commandType == "number"){

					//Trying to convert String type into Double type. Throws Exception if unsuccessful
					try{
						double val = std::stod(std::string(command));
						delete *J;
						*J = new numericCell(val);

						/* Always calls updateSheet function after every number insertion/updation and modify
						   the value of functionCell if dependent.
						   */
						updateSheet(&rows);
					}
					catch (std::exception e){
						std::cout << "Error: Bad input for set number\n";
					}
				}

				/*If user input command is max/min/mean type, create functionalCell on that particular position implementing
				  max/min/mean function
				  */
				else if (commandType == "max" || commandType == "min" || commandType == "mean"){
					try{
						double rowValue = std::stod(std::string(command));
						int beginOffset = 0, endOffset = 0;
						ss >> beginOffset >> endOffset;
						double fVal = 0;
						functionCell(fVal, &rows, row, column, rowValue, beginOffset, endOffset, commandType);
					}
					catch (std::exception e){
						std::cout << "Error\n";
					}
				}
			}
		}
	}

	/* Calls updateSheet() after every insertion so as to update if two functioncells are dependent on
		each other.
		*/
	updateSheet(&rows);
}

/****************************************************************************************************/
/*Function for adding row
	The spreadsheet is iterated till the position where the row is to be added. insert() is called to
	insert a row above the row values in user input. If the row is added to first position (0th position),
	head pointer is adjusted to point the row which is just inserted.
	*/
void addRow(LList<LList<Cell*>>& rows, int addRowValue){
	int h = 0; //increments to track the height or row value
	LList<Cell*> empty; //create an empty LinkedList of Cell type
	for (LList<LList<Cell*>>::iterator I = rows.begin(); I != rows.end(); I++){

		/*Insert a cell on the position if the value of the rows iterated equals to the value of row
		  in the user input where the row is to be inserted
		  */
		if (h == addRowValue)
		{
			for (LList<Cell*>::iterator J = (*I).begin(); J != (*I).end(); J++)
			{
				I = rows.insert(I, empty, addRowValue); //inserts a Cell in first column (0th column) at specific row position

				//Push backs empty LList at the back of the First cell till the width of column (last column)
				for (int k = 0; k < width; k++){
					(*I).push_back(new Cell());
				}
				break;
			}
		}
		h++;
	}

	//increase the height of the spreadsheet if a row is added
	height += 1;
}

/****************************************************************************************************/
/*Function for removing the row
	The spreadsheet is iterated till the position where the row is to be removed. remove() is called to
	remove a row at the row value position in user input. If last row is removed, tail pointer is adjusted
	and made to point the row above it. If first row (0th row) is removed, head pointer is adjusted adjusted
	to point next row.
	*/
void removeRow(LList<LList<Cell*>>& rows, int removeRowValue){
	int h = 0; //increments to track the height or row value
	LList<LList<Cell*>>::iterator I = rows.begin();
	for (LList<LList<Cell*>>::iterator I = rows.begin(); I != rows.end(); I++){

		/*Remove a cell on the position if the value of the rows iterated equals to the value of row
		in the user input where the row is to be removed.
		*/
		if (h == removeRowValue){
			I = rows.erase(I, removeRowValue, height);
		}
		h++;
	}

	//decrease the height of the spreadsheet by one if a row is removed
	height -= 1;
}

/****************************************************************************************************/
/*Function for setting different cell contents

*/
void setCell(std::istringstream& ss, std::string& command, LList<LList<Cell*>>& rows, std::string& line){

	std::string subCmd;
	try{
		ss >> command;
		int column = std::stoi(std::string(command));
		column += 1;
		ss >> command;
		int row = std::stoi(std::string(command));
		row += 1;
		if (column > width || row > height){
			std::cout << "Error: cell out of range\n";
		}
		else{

			ss >> command;
			std::string commandType = command;

			/************************************************************************************************/
			//Checks if the input is number, if number, call numericCell
			if (command == "number"){
				ss >> command;
				try{
					double numVal = std::stod(std::string(command));
					insertNewCell(rows, command, column, row, ss, commandType);
				}
				catch (std::exception e){
					std::cout << "Error: Bad input for set number\n";
					return;
				}

			}

			/************************************************************************************************/
			else if (command == "string"){
				//stores the complete string after "string" command into string variable
				std::getline(ss, subCmd);

				//Checks if is has "spaces" at the start of string and removes it
				if (subCmd[0] < 33){
					subCmd.erase(subCmd.begin()); //remove all leading whitespace
				}

				//Checks for "spaces" after the string and removes it if present
				else if (subCmd[subCmd.size() - 1] < 33){
					subCmd.erase(subCmd.size() - 1); //remove all trailing whitespace
				}

				//Checks if the string is empty. Displays error message if empty
				if (subCmd.empty()){
					std::cout << "Error: No string\n";
				}

				//If everything is fine, insert the string at the location in the spreadsheet
				else{
					insertNewCell(rows, subCmd, column, row, ss, commandType);
				}
			}

			else if (command == "max"){
				ss >> command;
				try{
					double funcVal = std::stod(std::string(command));
					insertNewCell(rows, command, column, row, ss, commandType);
				}
				catch (std::exception e){
					std::cout << "Error: Bad input for set number\n";
					return;
				}
			}
			else if (command == "min"){
				ss >> command;
				try{
					double funcVal = std::stod(std::string(command));
					insertNewCell(rows, command, column, row, ss, commandType);
				}
				catch (std::exception e){
					std::cout << "Error: Bad input for set number\n";
					return;
				}
			}
			else if (command == "mean"){
				ss >> command;
				try{
					double funcVal = std::stod(std::string(command));
					insertNewCell(rows, command, column, row, ss, commandType);
				}
				catch (std::exception e){
					std::cout << "Error: Bad input for set number\n";
					return;
				}
			}
		}
	}

	catch (std::exception e){
		std::cout << "Error:Bad Input Argument\n";
	}

}


/****************************************************************************************************/
/*
Main function. 
Checks if the correct number of command line arguments are given. User input in form of string is 
stored in stream buffer. 
*/
int main(int argc, char** argv){

	/***********************************************************************************************/
	//Checks the correct number of input arguments
	if (argc != 3){
		std::cout << "Error: unknown command\n";
		return 1;
	}

	/**********************************************************************************************/
	//checks if input is a string or not. Returns 1 if string and quits.
	try{
		width = std::stoi(std::string(argv[1]));
		height = std::stoi(std::string(argv[2]));
	}
	catch (std::exception e){
		std::cout << "Bad string values!!\n";
		return 1;
	}

	/***********************************************************************************************/
	//Validates the input argument
	if (width <= 0 || height <= 0){
		std::cout << "Error!!!Bad Input Arguments!!\n";
		return 1;
	}

	/************************************************************************************************/
	//Initilizing linked List
	LList<LList<Cell*>> rows;

	for (int i = 0; i < height; i++){
		LList<Cell*> empty;
		rows.push_back(empty);

		for (int j = 0; j < width; j++){
			rows.back().push_back(new Cell());
		}
	}

	/************************************************************************************************/
	//Taking user commands from command line as string and processing it
	std::string line;

	int k = 0;
	while (std::getline(std::cin, line)){
		std::istringstream ss(line);
		std::string command;
		ss >> command;

		//checks if the input command is print, set, addrow, removerow, quit.
		if (command == "print"){
			printList(rows);
		}

		else if (command == "addrow"){
			ss >> command;
			try{
				int addRowValue = std::stoi(std::string(command));
				if (addRowValue > height || addRowValue < 0){
					std::cout << "Error: row out of range\n";
				}
				else{
					addRow(rows, addRowValue);
				}
			}
			catch (std::exception e){
				std::cout << "Error: row out of range\n";
			}
		}

		else if (command == "removerow"){
			ss >> command;
			try{
				int removeRowValue = std::stoi(std::string(command));
				if (removeRowValue > height || removeRowValue < 0){
					std::cout << "Error: row out of range\n";
				}
				else{
					removeRow(rows, removeRowValue);
				}
			}
			catch (std::exception e){
				std::cout << "Error: row out of range\n";
			}
		}

		else if (command == "set"){
			setCell(ss, command, rows, line);
		}

		else if (command == "quit"){
			std::cout << "\nCount Value: " << Cell::count;
			for (LList<LList<Cell*>>::iterator I = rows.begin(); I != rows.end(); I++){
				for (LList<Cell*>::iterator J = (*I).begin(); J != (*I).end(); J++){
					delete *J;
					std::cout << "\nCount Value: " << Cell::count;
				}
			}
			return 0;
		}
		else{
			std::cout << "Error: unknown command\n";
		}
	}

	/****************************************************************************************************/

}