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
		let extractor: (TestConstants.Person) -> Int = \.age
		let sorted = TestConstants.people.sorted(by: Sort.asc(extractor))
		#expect(sorted.map(\.age) == [22, 24, 35, 40, 50])
	}

	@Test
	func ascBool() {
		let extractor: (TestConstants.Person) -> Bool = \.isTall
		let sorted = TestConstants.people.sorted(by: Sort.asc(extractor))
		let notTall = Set(sorted.prefix(while: !\.isTall).map(\.name))
		#expect(notTall == ["Ethan", "Alfonso", "Susan"])
	}

	@Test
	func descBool() {
		let extractor: (TestConstants.Person) -> Bool = \.isTall
		let sorted = TestConstants.people.sorted(by: Sort.desc(extractor))
		let tall = Set(sorted.prefix(while: \.isTall).map(\.name))
		#expect(tall == ["Henrietta", "Jeff"])
	}

	@Test
	func compoundBoolAndComparable() {
		let isTall: (TestConstants.Person) -> Bool = \.isTall
		let name: (TestConstants.Person) -> String = \.name
		let sorted = TestConstants.people.sorted(by: Sort.compose(Sort.desc(isTall), Sort.asc(name)))
		#expect(sorted.map(\.name) == ["Henrietta", "Jeff", "Alfonso", "Ethan", "Susan"])
	}

	@Test
	func ascOptionalComparable() {
		let extractor: (TestConstants.Person) -> Int? = \.score
		let sorted = TestConstants.people.sorted(by: Sort.asc(extractor))
		// nils sort last; non-nils ascending: 71, 78, 85, 92
		#expect(sorted.map(\.score) == [71, 78, 85, 92, nil])
	}

	@Test
	func descComparable() {
		let extractor: (TestConstants.Person) -> Int = \.age
		let sorted = TestConstants.people.sorted(by: Sort.desc(extractor))
		#expect(sorted.map(\.age) == [50, 40, 35, 24, 22])
	}

	@Test
	func descOptionalComparable() {
		let extractor: (TestConstants.Person) -> Int? = \.score
		let sorted = TestConstants.people.sorted(by: Sort.desc(extractor))
		// nils sort last; non-nils descending: 92, 85, 78, 71
		#expect(sorted.map(\.score) == [92, 85, 78, 71, nil])
	}

	@Test
	func ascOptionalBool() {
		let extractor: (TestConstants.Person) -> Bool? = \.isVerified
		let sorted = TestConstants.people.sorted(by: Sort.asc(extractor))
		// false before true, nils last
		#expect(sorted.map(\.isVerified) == [false, true, true, nil, nil])
	}

	@Test
	func descOptionalBool() {
		let extractor: (TestConstants.Person) -> Bool? = \.isVerified
		let sorted = TestConstants.people.sorted(by: Sort.desc(extractor))
		// true before false, nils last
		#expect(sorted.map(\.isVerified) == [true, true, false, nil, nil])
	}

	@Test
	func emptyCompose() {
		let comparator: Sort.Comparator<Int> = Sort.compose()
		#expect(!comparator(1, 2))
		#expect(!comparator(2, 1))
	}

	@Test
	func extractorWithMutableCapture() {
		var callCount = 0
		let extractor: (Int) -> Int = { value in
			callCount += 1
			return value
		}
		let comparator = Sort.asc(extractor)

		#expect(comparator(1, 2))
		#expect(callCount == 2)
	}

	@Test
	func mixedCompose() {
		var callCount = 0
		let extractor: (TestConstants.Person) -> Bool = {
			callCount += 1
			return $0.isTall
		}
		let ordinary = Sort.desc(extractor)
		let sendable = Sort.asc(\TestConstants.Person.name)
		let comparator = Sort.compose(ordinary, sendable)
		let sorted = TestConstants.people.sorted(by: comparator)
		#expect(sorted.map(\.name) == ["Henrietta", "Jeff", "Alfonso", "Ethan", "Susan"])
		#expect(callCount > 0)

		let reversed = Sort.compose(sendable, ordinary)
		let sortedByName = TestConstants.people.sorted(by: reversed)
		#expect(sortedByName.map(\.name) == ["Alfonso", "Ethan", "Henrietta", "Jeff", "Susan"])
	}

	@Test
	func nonSendableComparable() {
		final class Rank: Comparable {
			let value: Int

			init(_ value: Int) { self.value = value }

			static func == (lhs: Rank, rhs: Rank) -> Bool { lhs.value == rhs.value }
			static func < (lhs: Rank, rhs: Rank) -> Bool { lhs.value < rhs.value }
		}

		let extractor: (Rank) -> Rank = { $0 }
		let comparator = Sort.asc(extractor)
		let sorted = [Rank(3), Rank(1), Rank(2)].sorted(by: comparator)
		#expect(sorted.map(\.value) == [1, 2, 3])
	}

	@Test
	func memoizedExtractor() {
		var callCount = 0
		let extractor = Extractor.memoize { (value: Int) -> Int in
			callCount += 1
			return value
		}
		let sorted = [3, 1, 2, 1].sorted(by: Sort.asc(extractor))
		#expect(sorted == [1, 1, 2, 3])
		#expect(callCount == 3)
	}

	@Test
	func memoize() {
		var callCount = 0
		let memoized = Extractor.memoize { (n: Int) -> Int in
			callCount += 1
			return n * 2
		}

		#expect(memoized(3) == 6)
		#expect(memoized(3) == 6)
		#expect(callCount == 1)
		_ = memoized(5)
		#expect(callCount == 2)
	}
}
