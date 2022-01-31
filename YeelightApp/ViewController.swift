//
//  ViewController.swift
//  YeelightApp
//
//  Created by Filipp K on 28.01.2022.
//

import UIKit

class ViewController: UIViewController {

	private let viewModel: DeviceViewModel

	init(viewModel: DeviceViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
		self.view.backgroundColor = .white
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		let button = UIButton(type: .custom)
		button.setTitle("Включить выключить", for: .normal)
		button.backgroundColor = .cyan
		view.addSubview(button)
		button.frame = .init(x: 0, y: 0, width: 200, height: 200)
		button.center = view.center

		button.addTarget(self, action: #selector(tap), for: .touchUpInside)
	}


	@objc func tap() {
		if !viewModel.connected {
			viewModel.connect()
			toggleLight()
		} else {
			toggleLight()
		}
	}

	var connnected: Bool = false

	func toggleLight() {
		viewModel.togglePower()
	}
}

enum Effect: String {
	case sudden
	case smooth
}

public protocol AbstractCommand {
	var id: Int { get }
	var method: Method { get }
	var params: [Any] { get }
}

extension AbstractCommand {
	var toData: Data {
		let jsonData = try! JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
		let str = String(data: jsonData, encoding: .utf8)?.appending("\r\n")
		return str?.data(using: .utf8) ?? Data()
	}

	private var body: [String: Any] {
		[
			"id": id,
			"method": method.rawValue,
			"params": params
		]
	}
}

enum Duration {
	case milliseconds(Int)
	case seconds(Int)

	var value: Int {
		switch self {
		case let .milliseconds(duration):
			return duration
		case let .seconds(duration):
			return duration * 1000
		}
	}
}

struct SetPower: AbstractCommand {
	enum State: String {
		case on
		case off

		init(_ flag: Bool) {
			self = flag ? .on : .off
		}
	}

	/*
	0: Normal turn on operation (default value)
	1: Turn on and switch to CT mode.
	2: Turn on and switch to RGB mode.
	3: Turn on and switch to HSV mode.
	4: Turn on and switch to color flow mode.
	5: Turn on and switch to Night light mode. (Ceiling light only).
	*/
	enum Mode: Int {
		case normal = 0
		case ct = 1
		case rgb = 2
		case csv = 3
		case colorFlow = 4
		case nightLight = 5
	}

	public let id: Int
	public let method: Method = .set_power
	public let params: [Any]

	public init(id: Int, to state: State, duration: Duration, effect: Effect = .smooth, mode: Mode? = nil) {
		self.id = id
		var temp: [Any] = [state.rawValue, effect.rawValue, duration.value]
		if let mode = mode { temp.append(mode) }
		self.params = temp
	}
}

struct SetDefault: AbstractCommand {
	public let id: Int
	public let method: Method = .set_default
	public let params: [Any] = []

	public init(id: Int) {
		self.id = id
	}
}
