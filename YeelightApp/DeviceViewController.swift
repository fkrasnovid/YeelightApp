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

		let labelbrt = UILabel()
		labelbrt.text = "bright"
		stack.addArrangedSubview(labelbrt)
		stack.addArrangedSubview(slider)


		let view3 = UIView()
		view3.backgroundColor = .brown
		view3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setRgb)))
		stack.addArrangedSubview(view3)

		let labelct = UILabel()
		labelct.text = "ct"
		stack.addArrangedSubview(labelct)

		let slider2 = UISlider()
		slider2.minimumValue = 1700
		slider2.maximumValue = 6500
		slider2.isContinuous = false
		slider2.value = Float(deviceViewModel.ct)
		slider2.addTarget(self, action: #selector(sliderAction2), for: .valueChanged)
		stack.addArrangedSubview(slider2)

	}

	@objc func toggle() {
		deviceViewModel.togglePower()
	}

	@objc func sliderAction(sender: UISlider) {
		guard deviceViewModel.ct != Int(sender.value) else { return }
		print(Int(sender.value))
		deviceViewModel.setBright(Int(sender.value))
	}

	@objc func sliderAction2(sender: UISlider) {
		guard deviceViewModel.ct != Int(sender.value) else { return }
		print(Int(sender.value))
		deviceViewModel.setCt(Int(sender.value))
	}

	@objc func setRgb() {
		deviceViewModel.setRgb(0xAF94E1)
	}
}
