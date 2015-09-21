/*
Linked list class
Written by Suvigya Tripathi, 11/20/2014
*/

#include "node.h"

#ifndef __LIST_H__
#define __LIST_H__

template<typename T>
class LList {
private:
	Node<T>* head;
	Node<T>* tail;

public:

	//Null constructor is for an empty list
	LList() {
		head = nullptr;
		tail = nullptr;
	}

	~LList() {
		//Keeps deleting the node after head until there aren't any
		if (nullptr != head) {
			while (nullptr != head->getNext()) {
				delete head->getNext();
			}
			delete head;
		}

	}

	void push_back(T val) {
		Node<T>* n = new Node<T>(val);
		//No head means we don't have a list yet
		if (nullptr == head) {
			head = n;
			tail = n;
		}
		else {
			tail->insert(n);
			tail = n;
		}
	}

	T& back(){
		return tail->getValue();
	}

	//Helper class for iterating through the linked list
	class iterator {
		//We can allow access to private variables to "friend" classes
		friend class LList;
	private:
		Node<T>* location;
	public:
		//Make sure that other templates can tell what type this iterator is holding
		typedef T value_type;

		iterator(Node<T>* start) {
			location = start;
		}

		//Prefix ++ operator
		iterator& operator++() {
			//Go to the next location if it exists
			if (nullptr != location) {
				location = location->getNext();
			}
			//Return the new value
			return *this;
		}
		iterator& operator--() {
			//Go to the next location if it exists
			if (nullptr != location) {
				location = location->getPrev();
			}

			//Return the new value
			return *this;
		}

		//Postfix ++ operator
		iterator operator++(int unused) {
			iterator copy = *this;
			operator++();
			return copy;
		}

		//* operator to access the element at this iterator's position
		T& operator*() {
			return location->getValue();
		}

		T& back(){
			return tail->getValue();
		}
		//The != operator compares this iterator's location to another iterator's location
		bool operator!=(iterator& other) {
			return location != other.location;
		}

		//We could define other things, such as operator+ or operator-
	};

	iterator begin() {
		return iterator(head);
	}

	iterator end() {
		//Return an iterator to nullptr rather than tail because end is one past the last element
		return iterator(nullptr);
	}

	//Erases the element at a position and returns the new valid location for the iterator
	//Retruns the iterator following the last removed element. If the iterator pos refers to the last element,
	//the end() iterator is returned.
	iterator erase(iterator position, int removeRowValue, int height) {
		iterator next = 0;
		if (removeRowValue != height && removeRowValue != 0)
		{
			next = position;
			++next;
		}
		else if (removeRowValue == 0){
			head = position.location->getNext();
		}

		else{
			tail = position.location->getPrev();
		}
		//Make sure that the user isn't trying to delete end()

		if (nullptr != position.location) {
			delete position.location;
		}
		return next;
	}

	//inserts value before the location pointed to by pos
	//Returns an iterator pointing to the inserted value
	iterator insert(iterator pos, const T& value, int addRowValue) {
		Node<T>* n = new Node<T>(value);
		if (nullptr != pos.location) {
			pos.location->insertBefore(n);
			if (addRowValue == 0){
				head = pos.location->getPrev();
			}
			return iterator(pos.location->getPrev());
		}
		else {
			//What if we are trying to insert something before the end?
			push_back(value);
			return iterator(tail);
		}
	}

};


#endif
