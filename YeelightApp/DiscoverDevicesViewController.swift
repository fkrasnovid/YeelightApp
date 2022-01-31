//
//  DiscoverDevicesViewController.swift
//  YeelightApp
//
//  Created by Filipp K on 31.01.2022.
//

import UIKit
import ChainableLayout

final class DiscoverDevicesPresenter {

}

final class DiscoverDevicesViewController: UIViewController {
	private let tableView = UITableView()
	private let service = ServiceFactory().discoverService
	var deviceViewModels: [DeviceViewModel] = []

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "Список девайсов"
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(DeviceTableViewCell.self, forCellReuseIdentifier: "DeviceTableViewCell")

		tableView
			.add(to: view)
			.pinContainer()


		service.didDiscoverDevice = { [unowned self] device in
			if self.deviceViewModels.contains(where: { $0.id == device.id }) { return }
			let viewModel = DeviceViewModel(with: device, receiver: CommandReceiverFactory().commandReceiver)
			deviceViewModels.append(viewModel)
		}

		UINavigationBar.appearance().backgroundColor = .systemBlue
		navigationItem.leftBarButtonItem = .init(title: "ПОдгрузить", style: .plain, target: self, action: #selector(leftAction))
	}

	var loading = false

	@objc func leftAction() {
		if !loading {
			service.discoverDevices()
			loading = true
			print("Загрузка")
			DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
				self.tableView.reloadData()
				self.loading.toggle()
				print("Закончил загрузку")
			}
		}
	}
}

extension DiscoverDevicesViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = DevicesViewController(deviceViewModel: deviceViewModels[indexPath.row])
		navigationController?.pushViewController(vc, animated: true)
	}
}

extension DiscoverDevicesViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return deviceViewModels.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: DeviceTableViewCell = tableView.dequeue(for: indexPath)
		cell.configure(with: deviceViewModels[indexPath.row])
		return cell
	}
}


extension UITableView {
	func dequeue<T: UITableViewCell>(for indexPath: IndexPath) -> T {
		return dequeueReusableCell(withIdentifier: "\(T.self)", for: indexPath) as! T
	}
}

protocol Configurable: AnyObject {
	associatedtype Item

	/// Производит настройку объекта на основе передаваемой модели
	/// - Parameter item: модель для настройки объекта
	func configure(with item: Item)
}


final class DeviceTableViewCell: UITableViewCell {
	private let label = UILabel()
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		label
			.add(to: contentView)
			.centerContainer()
			.activate()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension DeviceTableViewCell: Configurable {
	func configure(with item: DeviceViewModel) {
		label.text = item.name.isEmpty ? item.id : item.name
	}
}
