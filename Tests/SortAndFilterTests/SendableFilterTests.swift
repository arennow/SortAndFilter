import SortAndFilter
import Testing

struct SendableFilterTests {
	@Test
	func emptyBooleanPredicates() {
		let all: Filter.SendablePredicate<Int> = Filter.allTrue()
		let any: Filter.SendablePredicate<Int> = Filter.anyTrue()
		#expect(all(0))
		#expect(!any(0))
	}

	@Test
	func multipleBooleanKeyPaths() {
		struct Flags { let first: Bool; let second: Bool }
		let all = Filter.allTrue(\Flags.first, \.second)
		let any = Filter.anyTrue(\Flags.first, \.second)
		let _: Filter.SendablePredicate<Flags> = all
		let _: Filter.SendablePredicate<Flags> = any
		#expect(all(Flags(first: true, second: true)))
		#expect(!all(Flags(first: true, second: false)))
		#expect(any(Flags(first: false, second: true)))
		#expect(!any(Flags(first: false, second: false)))
	}

	@Test
	func sharedAcrossTasks() async {
		let predicate = Filter.greaterThan(\TestConstants.Person.age, 30) && !Filter.isTrue(\.isTall)
		let _: Filter.SendablePredicate<TestConstants.Person> = predicate
		let first = Task.detached { TestConstants.people.filter(predicate).map(\.name) }
		let second = Task.detached { TestConstants.people.filter(predicate).map(\.name) }
		#expect(await first.value == ["Ethan", "Alfonso"])
		#expect(await second.value == ["Ethan", "Alfonso"])
	}

	@Test
	func greaterThan() {
		let predicate = Filter.greaterThan(\TestConstants.Person.age, 35)
		let _: Filter.SendablePredicate<TestConstants.Person> = predicate
		let filtered = TestConstants.people.filter(predicate)
		#expect(Set(filtered.map(\.age)) == [40, 50])
	}

	@Test
	func greaterThanOrEqual() {
		let predicate = Filter.greaterThanOrEqual(\TestConstants.Person.age, 35)
		let _: Filter.SendablePredicate<TestConstants.Person> = predicate
		let filtered = TestConstants.people.filter(predicate)
		#expect(Set(filtered.map(\.age)) == [35, 40, 50])
	}

	@Test
	func lessThan() {
		let predicate = Filter.lessThan(\TestConstants.Person.age, 35)
		let _: Filter.SendablePredicate<TestConstants.Person> = predicate
		let filtered = TestConstants.people.filter(predicate)
		#expect(Set(filtered.map(\.age)) == [22, 24])
	}

	@Test
	func lessThanOrEqual() {
		let predicate = Filter.lessThanOrEqual(\TestConstants.Person.age, 35)
		let _: Filter.SendablePredicate<TestConstants.Person> = predicate
		let filtered = TestConstants.people.filter(predicate)
		#expect(Set(filtered.map(\.age)) == [22, 24, 35])
	}

	@Test
	func equal() {
		let predicate = Filter.equal(\TestConstants.Person.name, "Jeff")
		let _: Filter.SendablePredicate<TestConstants.Person> = predicate
		let filtered = TestConstants.people.filter(predicate)
		#expect(filtered.map(\.name) == ["Jeff"])
	}

	@Test
	func equalWithOptionalValue() {
		let searchAge: Int? = 24
		let predicate = Filter.equal(\TestConstants.Person.age, searchAge)
		let _: Filter.SendablePredicate<TestConstants.Person> = predicate
		let filtered = TestConstants.people.filter(predicate)
		#expect(filtered.map(\.name) == ["Jeff"])
	}

	@Test
	func notEqual() {
		let predicate = Filter.notEqual(\TestConstants.Person.name, "Jeff")
		let _: Filter.SendablePredicate<TestConstants.Person> = predicate
		let filtered = TestConstants.people.filter(predicate)
		#expect(Set(filtered.map(\.name)) == ["Ethan", "Henrietta", "Alfonso", "Susan"])
	}

	@Test
	func isNil() {
		let predicate = Filter.isNil(\TestConstants.Person.score)
		let _: Filter.SendablePredicate<TestConstants.Person> = predicate
		let filtered = TestConstants.people.filter(predicate)
		#expect(filtered.map(\.name) == ["Ethan"])
	}

	@Test
	func always() {
		let predicate: Filter.SendablePredicate<TestConstants.Person> = Filter.always()
		let filtered = TestConstants.people.filter(predicate)
		#expect(filtered.count == TestConstants.people.count)
	}

	@Test
	func never() {
		let predicate: Filter.SendablePredicate<TestConstants.Person> = Filter.never()
		let filtered = TestConstants.people.filter(predicate)
		#expect(filtered.isEmpty)
	}

	@Test
	func isTrue() {
		let predicate = Filter.isTrue(\TestConstants.Person.isTall)
		let _: Filter.SendablePredicate<TestConstants.Person> = predicate
		let filtered = TestConstants.people.filter(predicate)
		#expect(Set(filtered.map(\.name)) == ["Jeff", "Henrietta"])
	}

	@Test
	func isFalse() {
		let predicate = Filter.isFalse(\TestConstants.Person.isTall)
		let _: Filter.SendablePredicate<TestConstants.Person> = predicate
		let filtered = TestConstants.people.filter(predicate)
		#expect(Set(filtered.map(\.name)) == ["Ethan", "Alfonso", "Susan"])
	}

	@Test
	func allTrue() {
		let predicate = Filter.allTrue(\TestConstants.Person.isTall)
		let _: Filter.SendablePredicate<TestConstants.Person> = predicate
		let filtered = TestConstants.people.filter(predicate)
		#expect(Set(filtered.map(\.name)) == ["Jeff", "Henrietta"])
	}

	@Test
	func anyTrue() {
		let predicate = Filter.anyTrue(\TestConstants.Person.isTall)
		let _: Filter.SendablePredicate<TestConstants.Person> = predicate
		let filtered = TestConstants.people.filter(predicate)
		#expect(Set(filtered.map(\.name)) == ["Jeff", "Henrietta"])
	}

	@Test
	func or() {
		let predicate = Filter.or(Filter.equal(\TestConstants.Person.name, "Jeff"), Filter.equal(\.name, "Ethan"))
		let _: Filter.SendablePredicate<TestConstants.Person> = predicate
		let filtered = TestConstants.people.filter(predicate)
		#expect(Set(filtered.map(\.name)) == ["Jeff", "Ethan"])
	}

	@Test
	func and() {
		let predicate = Filter.and(Filter.greaterThan(\TestConstants.Person.age, 30), Filter.isFalse(\.isTall))
		let _: Filter.SendablePredicate<TestConstants.Person> = predicate
		let filtered = TestConstants.people.filter(predicate)
		#expect(Set(filtered.map(\.name)) == ["Ethan", "Alfonso"])
	}

	@Test
	func not() {
		let predicate = Filter.not(Filter.equal(\TestConstants.Person.name, "Jeff"))
		let _: Filter.SendablePredicate<TestConstants.Person> = predicate
		let filtered = TestConstants.people.filter(predicate)
		#expect(Set(filtered.map(\.name)) == ["Ethan", "Henrietta", "Alfonso", "Susan"])
	}

	@Test
	func orOperator() {
		let predicate = Filter.equal(\TestConstants.Person.name, "Jeff") || Filter.equal(\.name, "Susan")
		let _: Filter.SendablePredicate<TestConstants.Person> = predicate
		let filtered = TestConstants.people.filter(predicate)
		#expect(Set(filtered.map(\.name)) == ["Jeff", "Susan"])
	}

	@Test
	func andOperator() {
		let predicate = Filter.greaterThan(\TestConstants.Person.age, 30) && Filter.isTrue(\.isTall)
		let _: Filter.SendablePredicate<TestConstants.Person> = predicate
		let filtered = TestConstants.people.filter(predicate)
		#expect(Set(filtered.map(\.name)) == ["Henrietta"])
	}

	@Test
	func notOperator() {
		let predicate = !Filter.isTrue(\TestConstants.Person.isTall)
		let _: Filter.SendablePredicate<TestConstants.Person> = predicate
		let filtered = TestConstants.people.filter(predicate)
		#expect(Set(filtered.map(\.name)) == ["Ethan", "Alfonso", "Susan"])
	}

	@Test
	func contains() {
		let predicate = Filter.contains(\TestConstants.Person.name, "jeff")
		let _: Filter.SendablePredicate<TestConstants.Person> = predicate
		let filtered = TestConstants.people.filter(predicate)
		#expect(filtered.map(\.name) == ["Jeff"])
	}

	@Test
	func containsOptional() {
		let predicate = Filter.contains(\TestConstants.Person.nickname, "hen")
		let _: Filter.SendablePredicate<TestConstants.Person> = predicate
		let filtered = TestConstants.people.filter(predicate)
		#expect(filtered.map(\.name) == ["Henrietta"])
	}
}
