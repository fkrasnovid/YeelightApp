import Foundation

public enum DeviceProperty: String, CaseIterable {
	/// on: smart LED is turned on / off: smart LED is turned off
	case power

	/// Brightness percentage. Range 1 ~ 100
	case bright

	/// Color temperature. Range 1700 ~ 6500(k)
	case ct

	/// Color. Range 1 ~ 16777215
	case rgb

	/// Hue. Range 0 ~ 359
	case hue

	/// Saturation. Range 0 ~ 100
	case sat

	/// 1: rgb mode / 2: color temperature mode / 3: hsv mode
	case color_mode

	/// 0: no flow is running / 1:color flow is running
	case flowing

	/// The remaining time of a sleep timer. Range 1 ~ 60 (minutes)
	case delayoff

	/// Current flow parameters (only meaningful when 'flowing' is 1)
	case flow_params

	/// 1: Music mode is on / 0: Music mode is off
	case music_on

	/// The name of the device set by “set_name” command Background light power status
	case name

	/// Background light power status
	case bg_power

	/// Background light is flowing
	case bg_flowing

	/// Current flow parameters of background light
	case bg_flow_params

	/// Color temperature of background light
	case bg_ct

	/// 1: rgb mode / 2: color temperature mode / 3: hsv mode
	case bg_lmode

	/// Brightness percentage of background light
	case bg_bright

	/// Color of background light
	case bg_rgb

	/// Hue of background light
	case bg_hue

	/// Saturation of background light
	case bg_sat

	/// Brightness of night mode light
	case nl_br

	/// 0: daylight mode / 1: moonlight mode (ceiling light only)
	case active_mode
}
