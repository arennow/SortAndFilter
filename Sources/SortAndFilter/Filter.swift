public enum Filter {}

public extension Filter {
	typealias Predicate<T> = (T) -> Bool

	static func equal<T, V: Equatable>(_ kp: KeyPath<T, V>, _ value: V) -> Predicate<T> {
		{ $0[keyPath: kp] == value }
	}

	static func equal<T, V: Equatable>(_ kp: KeyPath<T, V>, _ value: V?) -> Predicate<T> {
		{ $0[keyPath: kp] == value }
	}

	static func notEqual<T, V: Equatable>(_ kp: KeyPath<T, V>, _ value: V) -> Predicate<T> {
		{ $0[keyPath: kp] != value }
	}
}

public extension Filter {
	static func isTrue<T>(_ kp: KeyPath<T, Bool>) -> Predicate<T> { self.equal(kp, true) }
	static func isFalse<T>(_ kp: KeyPath<T, Bool>) -> Predicate<T> { self.equal(kp, false) }

	static func allTrue<T>(_ kps: KeyPath<T, Bool>...) -> Predicate<T> {
		kps.reversed().reduce(Filter.always()) { (comp, kp) in
			Filter.and(Filter.isTrue(kp), comp)
		}
	}

	static func anyTrue<T>(_ kps: KeyPath<T, Bool>...) -> Predicate<T> {
		kps.reversed().reduce(Filter.never()) { (comp, kp) in
			Filter.or(Filter.isTrue(kp), comp)
		}
	}
}

public extension Filter {
	static func isNil<T>(_ kp: KeyPath<T, Optional<some Equatable>>) -> Predicate<T> { self.equal(kp, nil) }
}

public extension Filter {
	static func always<T>() -> Predicate<T> { { _ in true } }
	static func never<T>() -> Predicate<T> { { _ in false } }
}

public extension Filter {
	static func or<T>(_ a: @escaping Predicate<T>, _ b: @escaping Predicate<T>) -> Predicate<T> {
		{ a($0) || b($0) }
	}

	static func and<T>(_ a: @escaping Predicate<T>, _ b: @escaping Predicate<T>) -> Predicate<T> {
		{ a($0) && b($0) }
	}

	static func not<T>(_ p: @escaping Predicate<T>) -> Predicate<T> {
		{ !p($0) }
	}
}

public func || <T>(_ a: @escaping Filter.Predicate<T>, _ b: @escaping Filter.Predicate<T>) -> Filter.Predicate<T> { Filter.or(a, b) }
public func && <T>(_ a: @escaping Filter.Predicate<T>, _ b: @escaping Filter.Predicate<T>) -> Filter.Predicate<T> { Filter.and(a, b) }
public prefix func ! <T>(_ p: @escaping Filter.Predicate<T>) -> Filter.Predicate<T> { Filter.not(p) }

#if canImport(Foundation)

import Foundation

public extension Filter {
	static func contains<T>(_ kp: KeyPath<T, some StringProtocol>, _ fragment: some StringProtocol) -> Predicate<T> {
		{ $0[keyPath: kp].localizedCaseInsensitiveContains(fragment) }
	}

	static func contains<T>(_ kp: KeyPath<T, Optional<some StringProtocol>>, _ fragment: some StringProtocol) -> Predicate<T> {
		{ $0[keyPath: kp]?.localizedCaseInsensitiveContains(fragment) ?? false }
	}
}

#endif
