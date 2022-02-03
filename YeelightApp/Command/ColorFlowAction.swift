import Foundation

/// The action taken after the flow is stopped.
public enum ColorFlowAction: Int {
	/// Smart LED recover to the state before the color flow started.
	case recover = 0

	/// Smart LED stay at the state when the flow is stopped.
	case stay = 1

	/// Turn off the smart LED after the flow is stopped.
	case turnOff = 2
}
