//
//  FilterTests.swift
//  SortAndFilter
//
//  Created by Aaron Rennow on 2025-02-23.
//

import SortAndFilter
import Testing

struct FilterTests {
	@Test
	func greaterThan() {
		let filtered = TestConstants.people.filter(Filter.greaterThan(\.age, 35))
		#expect(Set(filtered.map(\.age)) == [40, 50])
	}

	@Test
	func greaterThanOrEqual() {
		let filtered = TestConstants.people.filter(Filter.greaterThanOrEqual(\.age, 35))
		#expect(Set(filtered.map(\.age)) == [35, 40, 50])
	}

	@Test
	func lessThan() {
		let filtered = TestConstants.people.filter(Filter.lessThan(\.age, 35))
		#expect(Set(filtered.map(\.age)) == [22, 24])
	}

	@Test
	func lessThanOrEqual() {
		let filtered = TestConstants.people.filter(Filter.lessThanOrEqual(\.age, 35))
		#expect(Set(filtered.map(\.age)) == [22, 24, 35])
	}
}
