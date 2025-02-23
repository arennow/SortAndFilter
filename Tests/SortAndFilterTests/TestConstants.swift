//
//  TestConstants.swift
//  SortAndFilter
//
//  Created by Aaron Rennow on 2025-02-23.
//

enum TestConstants {
	struct Person {
		let name: String
		let age: Int
		let isTall: Bool
	}

	static let people = [
		Person(name: "Jeff", age: 24, isTall: true),
		Person(name: "Ethan", age: 50, isTall: false),
		Person(name: "Henrietta", age: 35, isTall: true),
		Person(name: "Alfonso", age: 40, isTall: false),
		Person(name: "Susan", age: 22, isTall: false),
	]
}
