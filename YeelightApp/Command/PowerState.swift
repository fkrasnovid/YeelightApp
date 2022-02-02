import Foundation

public enum PowerState: String {
	case on
	case off

	init(_ flag: Bool) {
		self = flag ? .on : .off
	}
}
