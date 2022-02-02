import Foundation

public enum DeviceCommand {
	case set_power(state: PowerState, duration: Duration, effect: Effect = .smooth, mode: PowerMode? = nil)
	case set_default

	/// This method is used to change the brightness of a smart LED.
	/// brightness is a percentage instead of a absolute value. 100 means maximum brightness while 1 means the minimum brightness.
	case set_bright(brightness: Int, effect: Effect = .smooth, duration: Duration = .milliseconds(500))

	/// This method is used to name the device. The name will be stored on the device and reported in discovering response
	case set_name(name: String)

	/// This method is used to change the color of a smart LED.
	case set_rgb(rgb: Int, effect: Effect = .smooth, duration: Duration = .milliseconds(500))

	/// This method is used to change the color temperature of a smart LED.
	case set_ct_abx(ct: Int, effect: Effect = .smooth, duration: Duration = .milliseconds(500))

	public var data: Data {
		guard
			let jsonData = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted),
			let stringData = String(data: jsonData, encoding: .utf8)?.appending("\r\n"),
			let sendableData = stringData.data(using: .utf8)
		else { assertionFailure("can't create sendableData"); return Data() }

		return sendableData
	}

	private var body: [String: Any] {
		[
			"id": 1,
			"method": method,
			"params": params
		]
	}

	private var method: String {
		switch self {
		case .set_power: return "set_power"
		case .set_default: return "set_default"
		case .set_bright: return "set_bright"
		case .set_name: return "set_name"
		case .set_rgb: return "set_rgb"
		case .set_ct_abx: return "set_ct_abx"
		}
	}

	private var params: [Any] {
		switch self {
		case let .set_power(state, duration, effect, mode):
			var temp: [Any] = [state.rawValue, effect.rawValue, duration.value]
			return temp.optionalAppend(mode?.rawValue)
		case .set_default:
			return []
		case let .set_bright(brightness, effect, duration):
			return [brightness, effect.rawValue, duration.value]
		case let .set_name(name):
			return [name]
		case let .set_rgb(rgb, effect, duration):
			return [rgb, effect.rawValue, duration.value]
		case let .set_ct_abx(ct, effect, duration):
			return [ct, effect.rawValue, duration.value]
		}
	}
}
