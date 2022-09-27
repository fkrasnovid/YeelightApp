import UIKit
import ChainableLayout
import Combine

final class DeviceSwitch: UISwitch {

    var valueChanged: ((Bool) -> Void)? {
        didSet { print("Set HERE") }
    }


	init() {
		super.init(frame: .zero)
		self.addTarget(self, action: #selector(isOnChanged), for: .valueChanged)
	}

	required init?(coder: NSCoder) { fatalError() }

	@objc private func isOnChanged(_ sender: UISwitch) {
		valueChanged?(sender.isOn)
	}
}

final class SwitchContainer: UIView {
	let deviceSwitch = DeviceSwitch()

	private let shevronImage = UIImageView(image: UIImage(named: "shevron_20pt"))

	init() {
		super.init(frame: .zero)
		shevronImage.contentMode = .center
		shevronImage.tintColor = .lightGray

		deviceSwitch
			.add(to: self)
			.left()
			.centerY(like: self)
			.activate()

		shevronImage
			.add(to: self)
			.right()
			.size(deviceSwitch.intrinsicContentSize.height / 2)
			.centerY(like: self)
			.activate()
	}

	override var intrinsicContentSize: CGSize {
		.init(
			width: deviceSwitch.intrinsicContentSize.width + 10 + deviceSwitch.intrinsicContentSize.height / 2,
			height: deviceSwitch.intrinsicContentSize.height
		)
	}

	required init?(coder: NSCoder) { fatalError() }
}

final class DeviceCollectionViewCell: UICollectionViewCell {

	private var bag = Set<AnyCancellable>()
	private let imageContainer = ImageContainer()
	private let brightnessView = BrightnessView()
	private let title = UILabel()
	private let switchContainer = SwitchContainer()

	override init(frame: CGRect) {
		super.init(frame: frame)

		contentView.backgroundColor = .white

		contentView.addSubviews(
			imageContainer, title, switchContainer, brightnessView
		)

		imageContainer
			.top(15)
			.left(15)
			.size(45)
			.activate()

		title
			.left(to: imageContainer, offset: 15)
			.right(to: switchContainer, offset: 15, priority: .defaultHigh)
			.centerY(like: imageContainer)
			.activate()

		switchContainer
			.centerY(like: imageContainer)
			.right(15)
			.activate()

		brightnessView
			.bottom(15)
			.pinHorizontally(offset: 22.5)
			.activate()

		title.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		contentView.layer.cornerRadius = 15
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

}

// MARK: - Configurable

extension DeviceCollectionViewCell: Configurable {
	func configure(with item: DeviceViewModel) {
		weak var wSelf = self

		item.$bright
			.sink { wSelf?.brightnessView.setSliderValue($0) }
			.store(in: &bag)

		item.$power
			.sink { print($0) }
			.store(in: &bag)

		title.font = UIFont(name: "AvenirNext-Medium", size: 17)
		title.text = item.name.isEmpty ? item.id : item.name
		brightnessView.setSliderValue(item.bright)
		imageContainer.setImage(UIImage(named: "bulb_24pt"))
		imageContainer.imageView.tintColor = .systemOrange
		imageContainer.backgroundColor = .systemOrange.withAlphaComponent(0.3)
		switchContainer.deviceSwitch.isOn = false//item.power

        let duration: Int = 60000 / 120
        let cf = ColorFlow(state: .infinite, action: .recover, exp: [
            .color(rgb: 0xE0F7FA, brightness: 100, duration: .seconds(1)),
            .color(rgb: 0xB2EBF2, brightness: 100, duration: .seconds(1)),
            .color(rgb: 0x80DEEA, brightness: 100, duration: .seconds(1)),
            .color(rgb: 0x4DD0E1, brightness: 100, duration: .seconds(1)),
            .color(rgb: 0x26C6DA, brightness: 100, duration: .seconds(1)),
            .color(rgb: 0x00BCD4, brightness: 100, duration: .seconds(1)),
            .color(rgb: 0x00ACC1, brightness: 100, duration: .seconds(1)),
            .color(rgb: 0x0097A7, brightness: 100, duration: .seconds(1)),
            .color(rgb: 0x00838F, brightness: 100, duration: .seconds(1)),
            .color(rgb: 0x006064, brightness: 100, duration: .seconds(1))
        ])

        switchContainer.deviceSwitch.valueChanged = { [weak item] in
            if $0 {
                //item?.setRgb(0xFB8C00)//FB8C00 251,140,0
                item?.setRgb(251 * 65536 + 150 * 256 + 0)

                //item?.setCF(cf)
            } else {
                //item?.stopCF()
            }
            //item?.setPower($0 == true ? .on : .off)
        }



		brightnessView.valueChanged = { [weak item] _ in
			//item?.setBright($0)
			//item?.getCron()
		}

//		switchContainer.deviceSwitch.valueChanged = { [weak item] _ in
//			//item?.connect()
//			// Optional("{\"id\":25,\"result\":[{\"type\": 0, \"delay\": 15, \"mix\": 0}]}\r\n")
//			// Optional("{\"id\":25,\"result\":[\"ok\"]}\r\n")
//			item?.deleteCron()
//			//item?.getCron()
//			//item?.togglePower()
//		}



	}

    
     /*










      */
}



public struct CommandResponse: Decodable {
	public enum ResponseType: Decodable {
		public struct ErrorResponse: Decodable {
			public let code: Int
			public let message: String
		}

		public struct CronResponse: Decodable {
			public let type: Int
			public let delay: Int
			public let mix: Int

			public init(type: Int, delay: Int, mix: Int) {
				self.type = type
				self.delay = delay
				self.mix = mix
			}
		}

		case ok
		case cron(CronResponse)
		case property([String])
		case undefined(String)
		case failed(ErrorResponse)

		public init(from decoder: Decoder) throws {
			let containter = try decoder.singleValueContainer()
			if let cronResponse = try? containter.decode([CronResponse].self).first {
				self = .cron(cronResponse)
				return
			}

			guard let values = try? containter.decode([String].self), !values.isEmpty else {
				self = .undefined("can't find array values")
				return
			}

			if values.count == 1, values[0] == "ok" {
				self = .ok
				return
			} else {
				self = .property(values)
				return
			}
		}
	}

	public let id: Int
	public let type: ResponseType

	private enum CodingKeys: String, CodingKey {
		case id, result, error
	}

	public init(id: Int, type: ResponseType) {
		self.id = id
		self.type = type
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decode(Int.self, forKey: .id)

		if let error = try? container.decode(ResponseType.ErrorResponse.self, forKey: .error) {
			self.type = .failed(error)
		} else {
			self.type = try container.decode(ResponseType.self, forKey: .result)
		}
	}
}


final class ImageContainer: UIView {
	let imageView = UIImageView()

	func setImage(_ image: UIImage?) {
		imageView.image = image
	}

	init() {
		super.init(frame: .zero)
		imageView.contentMode = .center
		imageView
			.add(to: self)
			.pinContainer()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = frame.height / 2
	}

	required init?(coder: NSCoder) { fatalError() }
}

final class BrightnessView: UIView {
	private let slider: UISlider = {
		let sl = UISlider()
		sl.isContinuous = false
		sl.maximumValue = 100
		sl.minimumValue = 1
		sl.minimumTrackTintColor = .systemOrange
		sl.maximumTrackTintColor = .lightGray
		return sl
	}()

	var valueChanged: ((Int) -> Void)?

	init() {
		super.init(frame: .zero)
		slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
		let sun = UIImageView(image: UIImage(named: "sun_18pt"))
		let sunrise = UIImageView(image: UIImage(named: "sunrise_18pt"))
		sun.tintColor = .lightGray
		sun.contentMode = .center
		sunrise.tintColor = .lightGray
		sunrise.contentMode = .center

		addSubviews(sun, slider, sunrise)

		sunrise
			.left()
			.centerY(like: self)
			.size(30)
			.activate()

		sun
			.right()
			.centerY(like: self)
			.size(30)
			.activate()

		slider
			.centerY(like: self)
			.left(to: sunrise, offset: 10)
			.right(to: sun, offset: 10)
			.activate()
	}

	required init?(coder: NSCoder) {
		fatalError()
	}

	override var intrinsicContentSize: CGSize {
		return .init(width: UIView.noIntrinsicMetric, height: 30)
	}

	func setSliderValue(_ value: Int) {
		slider.setValue(Float(value), animated: false)
	}
}

// MARK: - Actions

private extension BrightnessView {
	@objc func sliderValueChanged(_ slider: UISlider) {
		valueChanged?(Int(slider.value))
	}
}
