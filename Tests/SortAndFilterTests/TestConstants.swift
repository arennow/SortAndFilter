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
		let score: Int?
		let nickname: String?
	}

	static let people = [
		Person(name: "Jeff", age: 24, isTall: true, score: 85, nickname: "The Ref"),
		Person(name: "Ethan", age: 50, isTall: false, score: nil, nickname: nil),
		Person(name: "Henrietta", age: 35, isTall: true, score: 92, nickname: "Henny"),
		Person(name: "Alfonso", age: 40, isTall: false, score: 71, nickname: nil),
		Person(name: "Susan", age: 22, isTall: false, score: 78, nickname: "Suze"),
	]
}
