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
		stack.axis = .vertical

		stack
			.add(to: view)
			.centerContainer()
			.pinHorizontally(offset: 25)
			.activate()

		let toggler = UISwitch()
		toggler.isOn = deviceViewModel.power
		toggler.addTarget(self, action: #selector(toggle), for: .valueChanged)
		stack.addArrangedSubview(toggler)

		let slider = UISlider()
		slider.minimumValue = 1
		slider.maximumValue = 100
		slider.isContinuous = false
		slider.value = Float(deviceViewModel.bright)
		slider.addTarget(self, action: #selector(sliderAction), for: .valueChanged)

		stack.addArrangedSubview(slider)
	}

	@objc func toggle() {
		deviceViewModel.togglePower()
	}

	@objc func sliderAction(sender: UISlider) {
		guard deviceViewModel.bright != Int(sender.value) else { return }
		print(Int(sender.value))
		deviceViewModel.setBright(Int(sender.value))
	}
}
