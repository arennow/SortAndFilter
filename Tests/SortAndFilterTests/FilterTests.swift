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
	func ordinaryBuilders() {
		typealias Person = TestConstants.Person
		let equal: (KeyPath<Person, Int>, Int) -> Filter.Predicate<Person> = Filter.equal
		let optionalEqual: (KeyPath<Person, Int>, Int?) -> Filter.Predicate<Person> = Filter.equal
		let notEqual: (KeyPath<Person, Int>, Int) -> Filter.Predicate<Person> = Filter.notEqual
		let greater: (KeyPath<Person, Int>, Int) -> Filter.Predicate<Person> = Filter.greaterThan
		let greaterOrEqual: (KeyPath<Person, Int>, Int) -> Filter.Predicate<Person> = Filter.greaterThanOrEqual
		let less: (KeyPath<Person, Int>, Int) -> Filter.Predicate<Person> = Filter.lessThan
		let lessOrEqual: (KeyPath<Person, Int>, Int) -> Filter.Predicate<Person> = Filter.lessThanOrEqual
		let isTrue: (KeyPath<Person, Bool>) -> Filter.Predicate<Person> = Filter.isTrue
		let isFalse: (KeyPath<Person, Bool>) -> Filter.Predicate<Person> = Filter.isFalse
		let isNil: (KeyPath<Person, Int?>) -> Filter.Predicate<Person> = Filter.isNil
		let contains: (KeyPath<Person, String>, String) -> Filter.Predicate<Person> = Filter.contains
		let optionalContains: (KeyPath<Person, String?>, String) -> Filter.Predicate<Person> = Filter.contains
		let jeff = TestConstants.people[0]
		#expect(equal(\.age, 24)(jeff))
		#expect(optionalEqual(\.age, 24)(jeff))
		#expect(notEqual(\.age, 35)(jeff))
		#expect(greater(\.age, 20)(jeff))
		#expect(greaterOrEqual(\.age, 24)(jeff))
		#expect(less(\.age, 30)(jeff))
		#expect(lessOrEqual(\.age, 24)(jeff))
		#expect(isTrue(\.isTall)(jeff))
		#expect(!isFalse(\.isTall)(jeff))
		#expect(!isNil(\.score)(jeff))
		#expect(contains(\.name, "JEFF")(jeff))
		#expect(optionalContains(\.nickname, "ref")(jeff))
	}

	@Test
	func mixedCompositionAndShortCircuiting() {
		var calls = 0
		let ordinary: Filter.Predicate<Int> = { calls += 1; return $0 > 0 }
		let yes: Filter.SendablePredicate<Int> = Filter.always()
		let no: Filter.SendablePredicate<Int> = Filter.never()
		#expect((ordinary && yes)(1))
		#expect((yes && ordinary)(1))
		#expect((ordinary || no)(1))
		#expect((no || ordinary)(1))
		#expect(!(!ordinary)(1))
		#expect(calls == 5)
		#expect((yes || ordinary)(1))
		#expect(!(no && ordinary)(1))
		#expect(calls == 5)
		#expect(Filter.and(ordinary, yes)(1))
		#expect(Filter.or(no, ordinary)(1))
		#expect(!Filter.not(ordinary)(1))
		#expect(calls == 8)
	}

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
