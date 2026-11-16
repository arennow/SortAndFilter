import SortAndFilter
import Testing

struct SendableSortTests {
	@Test
	func ascComparable() {
		let comparator = Sort.asc(\TestConstants.Person.age)
		let _: Sort.SendableComparator<TestConstants.Person> = comparator
		let sorted = TestConstants.people.sorted(by: comparator)
		#expect(sorted.map(\.age) == [22, 24, 35, 40, 50])
	}

	@Test
	func descComparable() {
		let comparator = Sort.desc(\TestConstants.Person.age)
		let _: Sort.SendableComparator<TestConstants.Person> = comparator
		let sorted = TestConstants.people.sorted(by: comparator)
		#expect(sorted.map(\.age) == [50, 40, 35, 24, 22])
	}

	@Test
	func ascOptionalComparable() {
		let comparator = Sort.asc(\TestConstants.Person.score)
		let _: Sort.SendableComparator<TestConstants.Person> = comparator
		let sorted = TestConstants.people.sorted(by: comparator)
		#expect(sorted.map(\.score) == [71, 78, 85, 92, nil])
	}

	@Test
	func descOptionalComparable() {
		let comparator = Sort.desc(\TestConstants.Person.score)
		let _: Sort.SendableComparator<TestConstants.Person> = comparator
		let sorted = TestConstants.people.sorted(by: comparator)
		#expect(sorted.map(\.score) == [92, 85, 78, 71, nil])
	}

	@Test
	func ascBool() {
		let comparator = Sort.asc(\TestConstants.Person.isTall)
		let _: Sort.SendableComparator<TestConstants.Person> = comparator
		let sorted = TestConstants.people.sorted(by: comparator)
		let notTall = Set(sorted.prefix(while: !\.isTall).map(\.name))
		#expect(notTall == ["Ethan", "Alfonso", "Susan"])
	}

	@Test
	func descBool() {
		let comparator = Sort.desc(\TestConstants.Person.isTall)
		let _: Sort.SendableComparator<TestConstants.Person> = comparator
		let sorted = TestConstants.people.sorted(by: comparator)
		let tall = Set(sorted.prefix(while: \.isTall).map(\.name))
		#expect(tall == ["Henrietta", "Jeff"])
	}

	@Test
	func ascOptionalBool() {
		let comparator = Sort.asc(\TestConstants.Person.isVerified)
		let _: Sort.SendableComparator<TestConstants.Person> = comparator
		let sorted = TestConstants.people.sorted(by: comparator)
		#expect(sorted.map(\.isVerified) == [false, true, true, nil, nil])
	}

	@Test
	func descOptionalBool() {
		let comparator = Sort.desc(\TestConstants.Person.isVerified)
		let _: Sort.SendableComparator<TestConstants.Person> = comparator
		let sorted = TestConstants.people.sorted(by: comparator)
		#expect(sorted.map(\.isVerified) == [true, true, false, nil, nil])
	}

	@Test
	func compoundBoolAndComparable() {
		let comparator = Sort.compose(Sort.desc(\TestConstants.Person.isTall), Sort.asc(\.name))
		let _: Sort.SendableComparator<TestConstants.Person> = comparator
		let sorted = TestConstants.people.sorted(by: comparator)
		#expect(sorted.map(\.name) == ["Henrietta", "Jeff", "Alfonso", "Ethan", "Susan"])
		#expect(!comparator(TestConstants.people[0], TestConstants.people[0]))
	}

	@Test
	func emptyCompose() {
		let comparator: Sort.SendableComparator<Int> = Sort.compose()
		#expect(!comparator(1, 2))
		#expect(!comparator(2, 1))
	}

	@Test
	func closureExtractor() {
		let offset = 5
		let comparator = Sort.asc { (value: Int) -> Int in value + offset }
		let _: Sort.SendableComparator<Int> = comparator
		#expect([3, 1, 2].sorted(by: comparator) == [1, 2, 3])
	}

	@Test
	func nonSendableElements() {
		class Item {
			var value: Int

			init(_ value: Int) { self.value = value }
		}

		let comparator = Sort.asc(\Item.value)
		let _: Sort.SendableComparator<Item> = comparator
		let sorted = [Item(3), Item(1), Item(2)].sorted(by: comparator)
		#expect(sorted.map(\.value) == [1, 2, 3])
	}

	@Test
	func sharedAcrossTasks() async {
		let comparator = Sort.compose(Sort.desc(\TestConstants.Person.isTall), Sort.asc(\.name))
		let _: Sort.SendableComparator<TestConstants.Person> = comparator
		let first = Task.detached { TestConstants.people.sorted(by: comparator).map(\.name) }
		let second = Task.detached { TestConstants.people.reversed().sorted(by: comparator).map(\.name) }

		#expect(await first.value == ["Henrietta", "Jeff", "Alfonso", "Ethan", "Susan"])
		#expect(await second.value == ["Henrietta", "Jeff", "Alfonso", "Ethan", "Susan"])
	}
}
