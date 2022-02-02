//
//  DeviceViewModel.swift
//  YeelightApp
//
//  Created by Filipp K on 31.01.2022.
//

import Combine

public final class DeviceViewModel {
	@Published public var bright: Int
	@Published public var name: String
	@Published public var sat: Int
	@Published public var ct: Int
	@Published public var hue: Int
	@Published public var power: Bool
	@Published public var rgb: Int
	@Published public var color_mode: Int

	public let host: String
	public let port: UInt16
	public let id: String
	public let location: String
	public let model: String
	public let fw_ver: String
	public let supportMethods: [Method]

	public var receiver: CommandReceiver
	public var connected = false

	public init(with device: Device, receiver: CommandReceiver) {
		self.host = device.host
		self.port = device.port
		self.id = device.id
		self.location = device.location
		self.bright = device.bright
		self.name = device.name
		self.sat = device.sat
		self.ct = device.ct
		self.model = device.model
		self.hue = device.hue
		self.power = device.power
		self.rgb = device.rgb
		self.fw_ver = device.fw_ver
		self.color_mode = device.color_mode
		self.supportMethods = device.supportMethods

		self.receiver = receiver
	}
}


// MARK: - Commands

extension DeviceViewModel {
	func connect() {
		receiver.connect(to: host, port: port) { [weak self] in
			self?.connected = $0
		}
	}

	func togglePower() {
		let nextState: PowerState = power ? .off : .on
		receiver.sendCommand(.set_power(state: nextState, duration: .milliseconds(600)))
		power = nextState == .on ? true : false
	}

	func setBright(_ bright: Int) {
		receiver.sendCommand(.set_bright(brightness: bright))
		self.bright = bright
	}

	func setName(_ name: String) {
		receiver.sendCommand(.set_name(name: name))
		self.name = name
	}

	func setRgb(_ rgb: Int) {
		receiver.sendCommand(.set_rgb(rgb: rgb))
		self.rgb = rgb
	}

	func setCt(_ ct: Int) {
		receiver.sendCommand(.set_ct_abx(ct: ct))
		self.ct = ct
	}
}
