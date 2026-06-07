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

	@Test
	func equal() {
		let filtered = TestConstants.people.filter(Filter.equal(\.name, "Jeff"))
		#expect(filtered.map(\.name) == ["Jeff"])
	}

	@Test
	func equalWithOptionalValue() {
		let searchAge: Int? = 24
		let filtered = TestConstants.people.filter(Filter.equal(\.age, searchAge))
		#expect(filtered.map(\.name) == ["Jeff"])
	}

	@Test
	func notEqual() {
		let filtered = TestConstants.people.filter(Filter.notEqual(\.name, "Jeff"))
		#expect(Set(filtered.map(\.name)) == ["Ethan", "Henrietta", "Alfonso", "Susan"])
	}

	@Test
	func isNil() {
		let filtered = TestConstants.people.filter(Filter.isNil(\.score))
		#expect(filtered.map(\.name) == ["Ethan"])
	}

	@Test
	func always() {
		let filtered = TestConstants.people.filter(Filter.always())
		#expect(filtered.count == TestConstants.people.count)
	}

	@Test
	func never() {
		let filtered = TestConstants.people.filter(Filter.never())
		#expect(filtered.isEmpty)
	}

	@Test
	func isTrue() {
		let filtered = TestConstants.people.filter(Filter.isTrue(\.isTall))
		#expect(Set(filtered.map(\.name)) == ["Jeff", "Henrietta"])
	}

	@Test
	func isFalse() {
		let filtered = TestConstants.people.filter(Filter.isFalse(\.isTall))
		#expect(Set(filtered.map(\.name)) == ["Ethan", "Alfonso", "Susan"])
	}

	@Test
	func allTrue() {
		let filtered = TestConstants.people.filter(Filter.allTrue(\.isTall))
		#expect(Set(filtered.map(\.name)) == ["Jeff", "Henrietta"])
	}

	@Test
	func anyTrue() {
		let filtered = TestConstants.people.filter(Filter.anyTrue(\.isTall))
		#expect(Set(filtered.map(\.name)) == ["Jeff", "Henrietta"])
	}

	@Test
	func or() {
		let filtered = TestConstants.people.filter(Filter.or(Filter.equal(\.name, "Jeff"), Filter.equal(\.name, "Ethan")))
		#expect(Set(filtered.map(\.name)) == ["Jeff", "Ethan"])
	}

	@Test
	func and() {
		let filtered = TestConstants.people.filter(Filter.and(Filter.greaterThan(\.age, 30), Filter.isFalse(\.isTall)))
		#expect(Set(filtered.map(\.name)) == ["Ethan", "Alfonso"])
	}

	@Test
	func not() {
		let filtered = TestConstants.people.filter(Filter.not(Filter.equal(\.name, "Jeff")))
		#expect(Set(filtered.map(\.name)) == ["Ethan", "Henrietta", "Alfonso", "Susan"])
	}

	@Test
	func orOperator() {
		let filtered = TestConstants.people.filter(Filter.equal(\.name, "Jeff") || Filter.equal(\.name, "Susan"))
		#expect(Set(filtered.map(\.name)) == ["Jeff", "Susan"])
	}

	@Test
	func andOperator() {
		let filtered = TestConstants.people.filter(Filter.greaterThan(\.age, 30) && Filter.isTrue(\.isTall))
		#expect(Set(filtered.map(\.name)) == ["Henrietta"])
	}

	@Test
	func notOperator() {
		let filtered = TestConstants.people.filter(!Filter.isTrue(\.isTall))
		#expect(Set(filtered.map(\.name)) == ["Ethan", "Alfonso", "Susan"])
	}

	@Test
	func contains() {
		let filtered = TestConstants.people.filter(Filter.contains(\.name, "jeff"))
		#expect(filtered.map(\.name) == ["Jeff"])
	}

	@Test
	func containsOptional() {
		let filtered = TestConstants.people.filter(Filter.contains(\.nickname, "hen"))
		#expect(filtered.map(\.name) == ["Henrietta"])
	}
}
