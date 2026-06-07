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

	@Test
	func ascOptionalComparable() {
		let sorted = TestConstants.people.sorted(by: Sort.asc(\.score))
		// nils sort last; non-nils ascending: 71, 78, 85, 92
		#expect(sorted.map(\.score) == [71, 78, 85, 92, nil])
	}

	@Test
	func descComparable() {
		let sorted = TestConstants.people.sorted(by: Sort.desc(\.age))
		#expect(sorted.map(\.age) == [50, 40, 35, 24, 22])
	}

	@Test
	func descOptionalComparable() {
		let sorted = TestConstants.people.sorted(by: Sort.desc(\.score))
		// nils sort last; non-nils descending: 92, 85, 78, 71
		#expect(sorted.map(\.score) == [92, 85, 78, 71, nil])
	}

	@Test
	func memoize() {
		var callCount = 0
		let memoized = Extractor.memoize({ (n: Int) -> Int in
			callCount += 1
			return n * 2
		})

		#expect(memoized(3) == 6)
		#expect(memoized(3) == 6)
		#expect(callCount == 1)
		_ = memoized(5)
		#expect(callCount == 2)
	}
}
