import Foundation

/// The expressions of the state changing series.
public struct ColorFlowExpression: ExpressibleByArrayLiteral {
	public enum Expression {
		case color(_ rgb: Int, brightness: Int, duration: Duration)
		case ct(_ ct: Int, brightness: Int, duration: Duration)
		case sleep(_ duration: Duration)

		// "duration, mode, value, brightness"
		public var toFormat: String {
			switch self {
			case let .color(rgb, brightness, duration):
				return "\(duration.value), 1, \(rgb), \(brightness)"
			case let .ct(ct, brightness, duration):
				return "\(duration.value), 2, \(ct), \(brightness)"
			case let .sleep(duration):
				return "\(duration.value), 7, 0, 0"
			}
		}
	}

	public let expressions: [Expression]

	public init(arrayLiteral elements: Expression...) {
		self.expressions = elements
	}

	public var toFormat: String {
		expressions.map(\.toFormat).joined(separator: ", ")
	}
}
