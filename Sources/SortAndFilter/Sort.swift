public enum Sort {
	public typealias Comparator<T> = (T, T) -> Bool

	public static func compose<R>(_ comparators: Comparator<R>...) -> Comparator<R> {
		{ (lhs, rhs) in
			for comp in comparators {
				if comp(lhs, rhs) { return true }
				if comp(rhs, lhs) { return false }
			}

			return false
		}
	}

	public static func asc<V>(_ extractor: @escaping (V) -> some Comparable) -> Comparator<V> {
		{ extractor($0) < extractor($1) }
	}

	public static func asc<V>(_ extractor: @escaping (V) -> Optional<some Comparable>) -> Comparator<V> {
		{
			switch (extractor($0), extractor($1)) {
				case (let .some(l), .some(let r)): return l < r
				case (.none, .some): return false
				case (.some, .none): return true
				case (.none, .none): return false
			}
		}
	}

	public static func asc<V>(_ extractor: @escaping (V) -> Bool) -> Comparator<V> {
		{
			switch (extractor($0), extractor($1)) {
				case (false, true): return true
				default: return false
			}
		}
	}

	public static func desc<V>(_ extractor: @escaping (V) -> some Comparable) -> Comparator<V> {
		{ extractor($0) > extractor($1) }
	}

	public static func desc<V>(_ extractor: @escaping (V) -> Bool) -> Comparator<V> {
		{
			switch (extractor($0), extractor($1)) {
				case (true, false): return true
				default: return false
			}
		}
	}
}

public enum Extractor {
	public static func memoize<V: Hashable, R>(_ extractor: @escaping (V) -> R) -> (V) -> R {
		var storage = Dictionary<V, R>()

		return { v in
			if let existing = storage[v] {
				return existing
			} else {
				let new = extractor(v)
				storage[v] = new
				return new
			}
		}
	}
}
