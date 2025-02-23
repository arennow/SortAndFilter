//
//  SortTests.swift
//  SortAndFilter
//
//  Created by Aaron Rennow on 2024-12-28.
//

import SortAndFilter
import Testing

struct SortTests {
	@Test
	func ascComparable() {
		let sorted = TestConstants.people.sorted(by: Sort.asc(\.age))
		#expect(sorted.map(\.age) == [22, 24, 35, 40, 50])
	}

	@Test
	func ascBool() {
		let sorted = TestConstants.people.sorted(by: Sort.asc(\.isTall))
		let notTall = Set(sorted.prefix(while: !\.isTall).map(\.name))
		#expect(notTall == ["Ethan", "Alfonso", "Susan"])
	}

	@Test
	func descBool() {
		let sorted = TestConstants.people.sorted(by: Sort.desc(\.isTall))
		let tall = Set(sorted.prefix(while: \.isTall).map(\.name))
		#expect(tall == ["Henrietta", "Jeff"])
	}

	@Test
	func compoundBoolAndComparable() {
		let sorted = TestConstants.people.sorted(by: Sort.compose(Sort.desc(\.isTall), Sort.asc(\.name)))
		#expect(sorted.map(\.name) == ["Henrietta", "Jeff", "Alfonso", "Ethan", "Susan"])
	}
}
