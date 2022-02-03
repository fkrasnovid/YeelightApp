import Foundation

public enum DeviceCommand {

	/// This method is used to switch on or off the smart LED
	/// - Parameters:
	///   - state: Target state value.
	///   - effect: Target transition effect. Default value .smooth
	///   - duration: Specifies the total time of the gradual changing. The minimum support duration is 30 milliseconds. Default value .milliseconds(500)
	///   - mode: Target mode value(optional). Default value nil
	case set_power(state: PowerState, duration: Duration, effect: Effect = .smooth, mode: PowerMode? = nil)

	/// This method is used to save current state of smart LED in persistent memory
	case set_default

	/// This method is used to change the brightness of a smart LED.
	/// - Parameters:
	///   - brightness: Target percentage brightness. It's range is 1 to 100.
	///   - effect: Target transition effect. Default value .smooth
	///   - duration: Specifies the total time of the gradual changing. The minimum support duration is 30 milliseconds. Default value .milliseconds(500)
	case set_bright(brightness: Int, effect: Effect = .smooth, duration: Duration = .milliseconds(500))

	/// This method is used to name the device. The name will be stored on the device and reported in discovering response.
	/// - Parameters:
	///   - name: Target name of the device.
	case set_name(name: String)

	/// This method is used to change the color of a smart LED.
	/// - Parameters:
	///   - rgb: Target color. It's range is 0 to 16777215.
	///   - effect: Target transition effect. Default value .smooth
	///   - duration: Specifies the total time of the gradual changing. The minimum support duration is 30 milliseconds. Default value .milliseconds(500)
	case set_rgb(rgb: Int, effect: Effect = .smooth, duration: Duration = .milliseconds(500))

	/// This method is used to change the color temperature of a smart LED.
	/// - Parameters:
	///   - ct: Target color temperature. It's range is 1700 to 6500.
	///   - effect: Target transition effect. Default value .smooth
	///   - duration: Specifies the total time of the gradual changing. The minimum support duration is 30 milliseconds. Default value .milliseconds(500)
	case set_ct_abx(ct: Int, effect: Effect = .smooth, duration: Duration = .milliseconds(500))

	/// This method is used to change the color of a smart LED.
	/// - Parameters:
	///   - hue: Target hue value. It's range is 0 to 359.
	///   - sat: Target saturation value. It's range is 0 to 100.
	///   - effect: Target transition effect. Default value .smooth
	///   - duration: Specifies the total time of the gradual changing. The minimum support duration is 30 milliseconds. Default value .milliseconds(500)
	case set_hsv(hue: Int, sat: Int, effect: Effect = .smooth, duration: Duration = .milliseconds(500))

	/// This method is used to toggle the smart LED.
	/// This method is defined because sometimes user may just want to flip the state without knowing the current state.
	case toggle

	/// This method is used to start a timer job on the smart LED.
	/// - Parameters:
	///   - type: Currently can only be 0. (means power off)
	///   - value: Target the length of the timer. (in minutes)
	case cron_add(type: Int = 0, value: Int)

	/// This method is used to retrieve the setting of the current cron job of the specified type.
	/// - Parameters:
	///   - type: Currently can only be 0. (means power off)
	case cron_get(type: Int = 0)

	/// This method is used to stop the specified cron job.
	/// - Parameters:
	///   - type: Currently can only be 0. (means power off)
	case cron_del(type: Int = 0)

	/// This method is used to change brightness, CT or color of a smart LED without knowing the current value, it's main used by controllers.
	/// When property is color, the action can only be circle, otherwise, it will be deemed as invalid request.
	/// - Parameters:
	///   - action: Target direction of the adjustment.
	///   - property: Target property to adjust.
	case set_adjust(action: AdjustAction, property: AdjustProperty)

	/// This method is used to start or stop music mode on a device.
	/// - Parameters:
	///   - state: Target state value.
	///   - host: Target host value(Optional). Default value nil
	///   - port: Target post value(Optional). Default value nil
	case set_music(state: MusicState, host: String? = nil, port: Int? = nil)

	/// This method is used to adjust the brightness by specified percentage within specified duration.
	///   - percentage: Target percentage to be adjusted. It's range is -100 to 100.
	///   - duration: Specifies the total time of the gradual changing. The minimum support duration is 30 milliseconds. Default value .milliseconds(500)
	case adjust_bright(percentage: Int, duration: Duration = .milliseconds(500))

	/// This method is used to adjust the color temperature by specified percentage within specified duration.
	///   - percentage: Target percentage to be adjusted. It's range is -100 to 100.
	///   - duration: Specifies the total time of the gradual changing. The minimum support duration is 30 milliseconds. Default value .milliseconds(500)
	case adjust_ct(percentage: Int, duration: Duration = .milliseconds(500))

	/// This method is used to adjust the color within specified duration.
	///   - percentage: Target percentage to be adjusted. It's range is -100 to 100.
	///   - duration: Specifies the total time of the gradual changing. The minimum support duration is 30 milliseconds. Default value .milliseconds(500)
	case adjust_color(percentage: Int, duration: Duration = .milliseconds(500))

	/// This method is used to start a color flow.
	/// Color flow is a series of smart LED visible state changing. It can be brightness changing, color changing or color temperature changing.
	case start_cf(state: ColorFlowState, action: ColorFlowAction, exp: ColorFlowExpression)

	/// This method is used to stop a running color flow.
	case stop_cf

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
		case .set_hsv: return "set_hsv"
		case .toggle: return "toggle"
		case .cron_add: return "cron_add"
		case .cron_get: return "cron_get"
		case .cron_del: return "cron_del"
		case .set_adjust: return "set_adjust"
		case .set_music: return "set_music"
		case .adjust_bright: return "adjust_bright"
		case .adjust_ct: return "adjust_ct"
		case .adjust_color: return "adjust_color"
		case .start_cf: return "start_cf"
		case .stop_cf: return "stop_cf"
		}
	}

	private var params: [Any] {
		switch self {
		case let .set_power(state, duration, effect, mode):
			var temp: [Any] = [state.rawValue, effect.rawValue, duration.value]
			return temp.optionalAppend(mode?.rawValue)
		case .set_default, .toggle, .stop_cf:
			return []
		case let .set_bright(brightness, effect, duration):
			return [brightness, effect.rawValue, duration.value]
		case let .set_name(name):
			return [name]
		case let .set_rgb(rgb, effect, duration):
			return [rgb, effect.rawValue, duration.value]
		case let .set_ct_abx(ct, effect, duration):
			return [ct, effect.rawValue, duration.value]
		case let .set_hsv(hue, sat, effect, duration):
			return [hue, sat, effect.rawValue, duration.value]
		case let .cron_add(type, value):
			return [type, value]
		case let .cron_get(type), let .cron_del(type):
			return [type]
		case let .set_adjust(action, property):
			return [action.rawValue, property.rawValue]
		case let .set_music(state, host, port):
			var temp: [Any] = [state.rawValue]
			if let host = host, let port = port { temp.append(contentsOf: [host, port]) }
			return temp
		case let .adjust_bright(percentage, duration), let .adjust_ct(percentage, duration), let .adjust_color(percentage, duration):
			return [percentage, duration.value]
		case let .start_cf(state, action, exp):
			return [state.value, action.rawValue, exp.toFormat]
		}
	}
}
