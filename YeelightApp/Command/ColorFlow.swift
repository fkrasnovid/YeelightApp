import Foundation

// MARK: - ColorFlow

public struct ColorFlow {
    public let state: State
    public let action: Action
    // max 9
    public let expressions: [Expression]

    public var parameters: [Any] {
        [state.value, action.rawValue, expressions.map(\.stringValue).joined(separator: ", ")]
    }

    public init(state: State, action: Action, exp: [Expression]) {
        self.state = state
        self.action = action
        self.expressions = exp
    }
}

// MARK: - State

public extension ColorFlow {
    /// The total number of visible state changing before color flow stopped.
    enum State {
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
}

// MARK: - Action

public extension ColorFlow {
    /// The action taken after the flow is stopped.
    enum Action: Int {
        /// Smart LED recover to the state before the color flow started.
        case recover = 0

        /// Smart LED stay at the state when the flow is stopped.
        case stay = 1

        /// Turn off the smart LED after the flow is stopped.
        case turnOff = 2
    }
}


// MARK: - Action

public extension ColorFlow {
    /// The expressions of the state changing series.
    enum Expression {
        case color(rgb: Int, brightness: Int, duration: Duration)
        case hsv(hue: Int, sat: Int, brightness: Int, duration: Duration)
        case ct(ct: Int, brightness: Int, duration: Duration)
        case sleep(duration: Duration)

        // "duration, mode, value, brightness"
        public var stringValue: String {
            switch self {
            case let .color(rgb, brightness, duration):
                return "\(duration.value), 1, \(rgb), \(brightness)"
            case let .hsv(hue, saturation, brightness, duration):
                return "\(duration.value), 1, \(hsvToRgb(h: hue, s: saturation)), \(brightness)"
            case let .ct(ct, brightness, duration):
                return "\(duration.value), 2, \(ct), \(brightness)"
            case let .sleep(duration):
                return "\(duration.value), 7, 0, 0"
            }
        }
    }
}

extension ColorFlow.Expression {
    func hsvToRgb(h: Int, s: Int, v: Int = 1) -> Int {
        if s == 0 { return 1 }

        let angle = (h >= 360 ? 0 : h)
        let sector = angle / 60 // Sector
        let i = Int(floor(Double(sector)))
        let f = sector - i // Factorial part of h

        let p = v * (1 - s)
        let q = v * (1 - (s * f))
        let t = v * (1 - (s * (1 - f)))

        let red: Int
        let green: Int
        let blue: Int

        switch(i) {
        case 0:
            red = v
            green = t
            blue = p
        case 1:
            red = q
            green = v
            blue = p
        case 2:
            red = p
            green = v
            blue = t
        case 3:
            red = p
            green = q
            blue = v
        case 4:
            red = t
            green = p
            blue = v
        default:
            red = v
            green = p
            blue = q
        }

        return red * 65536 + green * 256 + blue
    }
}
