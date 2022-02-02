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
