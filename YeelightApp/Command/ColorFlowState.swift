import Foundation

/// The total number of visible state changing before color flow stopped.
public enum ColorFlowState {
	/// Infinite loop on the state changing.
	case infinite
	case count(Int)

	public var value: Int {
		switch self {
		case .infinite: return 0
		case let .count(count): return count
		}
	}
}
