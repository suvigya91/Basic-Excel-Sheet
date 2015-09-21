/*
Cell Header 
written by Suvigya Tripathi, 11/20/2014
*/
#ifndef __NODE_H__
#define __NODE_H__

template <typename T>
class Node{
private:
	T val;
	Node* next;
	Node* prev;

	Node(Node& other);

public:
	//virtual std::string toString();
	Node(T value){
		val = value;
		next = nullptr;
		prev = nullptr;
	}

	T& getValue(){
		return val;
	}


	//Insert a cell after this
	void insert(Node* n){
		//fix link between new node and next
		if (nullptr != next){
			next->prev = n;
		}
		n->next = next;

		//fix link from this cell to next
		n->prev = this;
		next = n;
	}

	//Insert new node before this node
	void insertBefore(Node* n){
		if (nullptr != prev){
			prev->next = n;
		}
		n->prev = prev;

		//fix link from this to new one
		n->next = this;
		prev = n;
	}

	~Node() {
		if (nullptr != prev) {
			prev->next = next;
		}
		if (nullptr != next) {
			next->prev = prev;
		}
	}

	Node* getPrev() {
		return prev;
	}

	Node* getNext() {
		return next;
	}
};

#endif