public enum Scene {
	/// Change the smart LED to specified color and brightness.
	case color(rgb: Int, brightness: Int)

	/// Change the smart LED to specified color and brightness.
	case hsv(hue: Int, sat: Int, brightness: Int)

	/// Change the smart LED to specified ct and brightness.
	case ct(ct: Int, brightness: Int)

	/// Start a color flow in specified fashion.
	/// ref: DeviceCommand.start_cf
    case cf(ColorFlow)

	/// Turn on the smart LED to specified brightness and start a sleep timer to turn off the light after the specified minutes.
	case delay(brightness: Int, value: Int)

    /// Parameters
	public var parameters: [Any] {
		switch self {
		case let .color(rgb, brightness):
			return ["color", rgb, brightness]
		case let .hsv(hue, sat, brightness):
			return ["hsv", hue, sat, brightness]
		case let .ct(ct, brightness):
			return ["ct", ct, brightness]
		case let .cf(flow):
            return ["cf"] + flow.parameters
		case let .delay(brightness, value):
			return ["auto_delay_off", brightness, value]
		}
	}
}
