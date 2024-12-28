//
//  Test.swift
//  SortAndFilter
//
//  Created by Aaron Rennow on 2024-12-28.
//

import Testing
import SortAndFilter

struct SortTests {
	private struct Person {
		let name: String
		let age: Int
		let isTall: Bool
	}
	
	private static let people = [
		Person(name: "Jeff", age: 24, isTall: true),
		Person(name: "Ethan", age: 50, isTall: false),
		Person(name: "Henrietta", age: 35, isTall: true),
		Person(name: "Alfonso", age: 40, isTall: false),
		Person(name: "Susan", age: 22, isTall: false),
	]
	
	@Test
	func ascComparable() {
		let sorted = Self.people.sorted(by: Sort.asc(\.age))
		#expect(sorted.map(\.age) == [22,24,35,40,50])
	}
	
	@Test
	func ascBool() {
		let sorted = Self.people.sorted(by: Sort.asc(\.isTall))
		let notTall = Set(sorted.prefix(while: !\.isTall).map(\.name))
		#expect(notTall == ["Ethan", "Alfonso", "Susan"])
	}
	
	@Test
	func descBool() {
		let sorted = Self.people.sorted(by: Sort.desc(\.isTall))
		let tall = Set(sorted.prefix(while: \.isTall).map(\.name))
		#expect(tall == ["Henrietta", "Jeff"])
	}
	
	@Test
	func compoundBoolAndComparable() {
		let sorted = Self.people.sorted(by: Sort.compose(Sort.desc(\.isTall), Sort.asc(\.name)))
		#expect(sorted.map(\.name) == ["Henrietta", "Jeff", "Alfonso", "Ethan", "Susan"])
	}
}
