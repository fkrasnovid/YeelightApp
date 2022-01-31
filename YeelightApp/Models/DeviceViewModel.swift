//
//  DeviceViewModel.swift
//  YeelightApp
//
//  Created by Filipp K on 31.01.2022.
//

import Combine

public final class DeviceViewModel {
	public let host: String
	public let port: UInt16

	public let id: String
	public let location: String
	@Published public var bright: Int
	@Published public var name: String
	@Published public var sat: Int
	@Published public var ct: Int
	public let model: String
	@Published public var hue: Int
	@Published public var power: Bool
	@Published public var rgb: Int
	public let fw_ver: String
	@Published public var color_mode: Int
	public let supportMethods: [Method]
	public let socketID: Int

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
		self.socketID = device.socketID
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
		let nextState: SetPower.State = power ? .off : .on
		receiver.sendCommand(SetPower(id: socketID, to: nextState, duration: .milliseconds(600)))
		power = nextState == .on ? true : false
	}
}
