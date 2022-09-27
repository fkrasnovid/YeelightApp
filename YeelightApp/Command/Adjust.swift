// MARK: - Adjust

public struct Adjust {
    public let action: Action
    public let property: Property

    public var parameters: [Any] {
        [action.rawValue, property.rawValue]
    }

    public init(action: Action, property: Property) {
        self.action = action
        self.property = property
    }
}

// MARK: - Action

/// Target direction of the adjustment.
public extension Adjust {
    enum Action: String {
        case increase
        case decrease
        case circle
    }
}

// MARK: - Property

/// Target property to adjust.
public extension Adjust {
    enum Property: String {
        case bright
        case ct
        case color
    }
}
