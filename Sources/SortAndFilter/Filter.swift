public enum Filter {
	public typealias Predicate<T> = (T) -> Bool
	public typealias SendablePredicate<T> = @Sendable (T) -> Bool
}

public extension Filter {
	@_disfavoredOverload
	static func equal<T, V: Equatable>(_ kp: KeyPath<T, V>, _ value: V) -> Predicate<T> {
		{ $0[keyPath: kp] == value }
	}

	static func equal<T, V: Equatable & Sendable>(_ kp: KeyPath<T, V> & Sendable, _ value: V) -> SendablePredicate<T> {
		{ $0[keyPath: kp] == value }
	}

	@_disfavoredOverload
	static func equal<T, V: Equatable>(_ kp: KeyPath<T, V>, _ value: V?) -> Predicate<T> {
		{ $0[keyPath: kp] == value }
	}

	static func equal<T, V: Equatable & Sendable>(_ kp: KeyPath<T, V> & Sendable, _ value: V?) -> SendablePredicate<T> {
		{ $0[keyPath: kp] == value }
	}

	@_disfavoredOverload
	static func notEqual<T, V: Equatable>(_ kp: KeyPath<T, V>, _ value: V) -> Predicate<T> {
		{ $0[keyPath: kp] != value }
	}

	static func notEqual<T, V: Equatable & Sendable>(_ kp: KeyPath<T, V> & Sendable, _ value: V) -> SendablePredicate<T> {
		{ $0[keyPath: kp] != value }
	}
}

public extension Filter {
	@_disfavoredOverload
	static func greaterThan<T, V: Comparable>(_ kp: KeyPath<T, V>, _ value: V) -> Predicate<T> {
		{ $0[keyPath: kp] > value }
	}

	static func greaterThan<T, V: Comparable & Sendable>(_ kp: KeyPath<T, V> & Sendable, _ value: V) -> SendablePredicate<T> {
		{ $0[keyPath: kp] > value }
	}

	@_disfavoredOverload
	static func greaterThanOrEqual<T, V: Comparable>(_ kp: KeyPath<T, V>, _ value: V) -> Predicate<T> {
		{ $0[keyPath: kp] >= value }
	}

	static func greaterThanOrEqual<T, V: Comparable & Sendable>(_ kp: KeyPath<T, V> & Sendable, _ value: V) -> SendablePredicate<T> {
		{ $0[keyPath: kp] >= value }
	}

	@_disfavoredOverload
	static func lessThan<T, V: Comparable>(_ kp: KeyPath<T, V>, _ value: V) -> Predicate<T> {
		{ $0[keyPath: kp] < value }
	}

	static func lessThan<T, V: Comparable & Sendable>(_ kp: KeyPath<T, V> & Sendable, _ value: V) -> SendablePredicate<T> {
		{ $0[keyPath: kp] < value }
	}

	@_disfavoredOverload
	static func lessThanOrEqual<T, V: Comparable>(_ kp: KeyPath<T, V>, _ value: V) -> Predicate<T> {
		{ $0[keyPath: kp] <= value }
	}

	static func lessThanOrEqual<T, V: Comparable & Sendable>(_ kp: KeyPath<T, V> & Sendable, _ value: V) -> SendablePredicate<T> {
		{ $0[keyPath: kp] <= value }
	}
}

public extension Filter {
	@_disfavoredOverload
	static func isTrue<T>(_ kp: KeyPath<T, Bool>) -> Predicate<T> { { $0[keyPath: kp] } }

	static func isTrue<T>(_ kp: KeyPath<T, Bool> & Sendable) -> SendablePredicate<T> { { $0[keyPath: kp] } }

	@_disfavoredOverload
	static func isFalse<T>(_ kp: KeyPath<T, Bool>) -> Predicate<T> { { !$0[keyPath: kp] } }

	static func isFalse<T>(_ kp: KeyPath<T, Bool> & Sendable) -> SendablePredicate<T> { { !$0[keyPath: kp] } }

	@_disfavoredOverload
	static func allTrue<T>(_ kps: KeyPath<T, Bool>...) -> Predicate<T> {
		{ value in kps.allSatisfy { value[keyPath: $0] } }
	}

	static func allTrue<T>(_ kps: (KeyPath<T, Bool> & Sendable)...) -> SendablePredicate<T> {
		{ value in kps.allSatisfy { value[keyPath: $0] } }
	}

	@_disfavoredOverload
	static func anyTrue<T>(_ kps: KeyPath<T, Bool>...) -> Predicate<T> {
		{ value in kps.contains { value[keyPath: $0] } }
	}

	static func anyTrue<T>(_ kps: (KeyPath<T, Bool> & Sendable)...) -> SendablePredicate<T> {
		{ value in kps.contains { value[keyPath: $0] } }
	}
}

public extension Filter {
	@_disfavoredOverload
	static func isNil<T>(_ kp: KeyPath<T, Optional<some Equatable>>) -> Predicate<T> { { $0[keyPath: kp] == nil } }

	static func isNil<T>(_ kp: KeyPath<T, Optional<some Equatable & Sendable>> & Sendable) -> SendablePredicate<T> { { $0[keyPath: kp] == nil } }
}

public extension Filter {
	@_disfavoredOverload
	static func always<T>() -> Predicate<T> { { _ in true } }

	static func always<T>() -> SendablePredicate<T> { { _ in true } }

	@_disfavoredOverload
	static func never<T>() -> Predicate<T> { { _ in false } }

	static func never<T>() -> SendablePredicate<T> { { _ in false } }
}

public extension Filter {
	@_disfavoredOverload
	static func or<T>(_ a: @escaping Predicate<T>, _ b: @escaping Predicate<T>) -> Predicate<T> {
		{ a($0) || b($0) }
	}

	static func or<T>(_ a: @escaping SendablePredicate<T>, _ b: @escaping SendablePredicate<T>) -> SendablePredicate<T> {
		{ a($0) || b($0) }
	}

	@_disfavoredOverload
	static func and<T>(_ a: @escaping Predicate<T>, _ b: @escaping Predicate<T>) -> Predicate<T> {
		{ a($0) && b($0) }
	}

	static func and<T>(_ a: @escaping SendablePredicate<T>, _ b: @escaping SendablePredicate<T>) -> SendablePredicate<T> {
		{ a($0) && b($0) }
	}

	@_disfavoredOverload
	static func not<T>(_ p: @escaping Predicate<T>) -> Predicate<T> {
		{ !p($0) }
	}

	static func not<T>(_ p: @escaping SendablePredicate<T>) -> SendablePredicate<T> {
		{ !p($0) }
	}
}

@_disfavoredOverload
public func || <T>(_ a: @escaping Filter.Predicate<T>, _ b: @escaping Filter.Predicate<T>) -> Filter.Predicate<T> { Filter.or(a, b) }

public func || <T>(_ a: @escaping Filter.SendablePredicate<T>, _ b: @escaping Filter.SendablePredicate<T>) -> Filter.SendablePredicate<T> { Filter.or(a, b) }

@_disfavoredOverload
public func && <T>(_ a: @escaping Filter.Predicate<T>, _ b: @escaping Filter.Predicate<T>) -> Filter.Predicate<T> { Filter.and(a, b) }

public func && <T>(_ a: @escaping Filter.SendablePredicate<T>, _ b: @escaping Filter.SendablePredicate<T>) -> Filter.SendablePredicate<T> { Filter.and(a, b) }

@_disfavoredOverload
public prefix func ! <T>(_ p: @escaping Filter.Predicate<T>) -> Filter.Predicate<T> { Filter.not(p) }

public prefix func ! <T>(_ p: @escaping Filter.SendablePredicate<T>) -> Filter.SendablePredicate<T> { Filter.not(p) }

#if canImport(Foundation)
	import Foundation

	public extension Filter {
		@_disfavoredOverload
		static func contains<T>(_ kp: KeyPath<T, some StringProtocol>, _ fragment: some StringProtocol) -> Predicate<T> {
			{ $0[keyPath: kp].localizedCaseInsensitiveContains(fragment) }
		}

		static func contains<T>(_ kp: KeyPath<T, some StringProtocol & Sendable> & Sendable, _ fragment: some StringProtocol & Sendable) -> SendablePredicate<T> {
			{ $0[keyPath: kp].localizedCaseInsensitiveContains(fragment) }
		}

		@_disfavoredOverload
		static func contains<T>(_ kp: KeyPath<T, Optional<some StringProtocol>>, _ fragment: some StringProtocol) -> Predicate<T> {
			{ $0[keyPath: kp]?.localizedCaseInsensitiveContains(fragment) ?? false }
		}

		static func contains<T>(_ kp: KeyPath<T, Optional<some StringProtocol & Sendable>> & Sendable, _ fragment: some StringProtocol & Sendable) -> SendablePredicate<T> {
			{ $0[keyPath: kp]?.localizedCaseInsensitiveContains(fragment) ?? false }
		}
	}
#endif
