public enum Duration {
	case milliseconds(Int)
	case seconds(Int)

	var value: Int {
		switch self {
		case let .milliseconds(duration):
			return duration
		case let .seconds(duration):
			return duration * 1000
		}
	}
}
