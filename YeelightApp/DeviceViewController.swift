//
//  DeviceViewController.swift
//  YeelightApp
//
//  Created by Filipp K on 31.01.2022.
//

import UIKit
import ChainableLayout

final class DevicesViewController: UIViewController {
	private let deviceViewModel: DeviceViewModel
	init(deviceViewModel: DeviceViewModel) {
		self.deviceViewModel = deviceViewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		title = deviceViewModel.name.isEmpty ? deviceViewModel.id : deviceViewModel.name
		deviceViewModel.connect()
		
		let stack = UIStackView()

		stack
			.add(to: view)
			.centerContainer()
			.activate()

		let toggler = UISwitch()
		toggler.isOn = deviceViewModel.power
		toggler.addTarget(self, action: #selector(toggle), for: .valueChanged)
		stack.addArrangedSubview(toggler)
	}

	@objc func toggle() {
		deviceViewModel.togglePower()
	}

}
