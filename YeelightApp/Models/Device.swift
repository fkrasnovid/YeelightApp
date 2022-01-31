//
//  Device.swift
//  YeelightApp
//
//  Created by Filipp K on 28.01.2022.
//

import Foundation

public enum Method: String, Encodable {
	case get_prop
	case set_ct_abx
	case set_rgb
	case set_hsv
	case set_bright
	case set_power
	case toggle
	case set_default
	case start_cf
	case stop_cf
	case set_scene
	case cron_add
	case cron_get
	case cron_del
	case set_adjust
	case set_music
	case set_name
	case bg_set_rgb
	case bg_set_hsv
	case bg_set_ct_abx
	case bg_start_cf
	case bg_stop_cf
	case bg_set_scene
	case bg_set_default
	case bg_set_power
	case bg_set_bright
	case bg_set_adjust
	case bg_toggle
	case dev_toggle
	case adjust_bright
	case adjust_ct
	case adjust_color
	case bg_adjust_bright
	case bg_adjust_ct
	case bg_adjust_color
	case udp_sess_new
	case udp_sess_keep_alive
	case udp_chroma_sess_new
}

public final class Device: Equatable {
	public static func == (lhs: Device, rhs: Device) -> Bool {
		lhs.id == rhs.id
	}

	public let host: String
	public let port: UInt16

	public let id: String
	public let location: String
	public var bright: Int
	public var name: String
	public var sat: Int
	public var ct: Int
	public let model: String
	public var hue: Int
	public var power: Bool
	public var rgb: Int
	public let fw_ver: String
	public var color_mode: Int
	public let supportMethods: [Method]
	public let socketID: Int

	init(with dictionary: [String: String], socketID: Int) {
		self.socketID = socketID
		self.location = dictionary["location"] ?? ""

		let hostport = self.location
			.replacingOccurrences(of: "yeelight://", with: "")
			.components(separatedBy: ":")

		self.host = hostport[0]
		self.port = hostport[1].toUInt16 ?? 0

		self.id = dictionary["id"] ?? ""
		self.bright = dictionary["bright"]?.toInt ?? 0
		self.name = dictionary["name"] ?? ""
		self.sat = dictionary["sat"]?.toInt ?? 0
		self.ct = dictionary["ct"]?.toInt ?? 0
		self.model = dictionary["model"] ?? ""
		self.hue = dictionary["hue"]?.toInt ?? 0
		self.power = dictionary["power"] == "on" ? true : false
		self.rgb = dictionary["rgb"]?.toInt ?? 0
		self.fw_ver = dictionary["fw_ver"] ?? ""
		self.color_mode = dictionary["color_mode"]?.toInt ?? 0

		if let support = dictionary["support"] {
			self.supportMethods = support
				.components(separatedBy: " ")
				.compactMap { Method(rawValue: $0) }
		} else {
			self.supportMethods = []
		}
	}
}

extension String {
	var toInt: Int? { Int(self) }
	var toUInt16: UInt16? { UInt16(self) }
}
