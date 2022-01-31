import CocoaAsyncSocket

public protocol DiscoverDevicesServiceProtocol: AnyObject {
	var didDiscoverDevice: ((Device) -> Void)? { get set }

	func discoverDevices()
}

final class DiscoverYeelightDevicesService: NSObject {
	private let host: String
	private let port: UInt16
	private let socket: GCDAsyncUdpSocket
	private var deviceSocketID = 1

	public var didDiscoverDevice: ((Device) -> Void)?

	public init(host: String, port: UInt16, onReceive queue: DispatchQueue) {
		self.host = host
		self.port = port
		self.socket = GCDAsyncUdpSocket(delegate: nil, delegateQueue: queue, socketQueue: queue)

		super.init()

		self.socket.setDelegate(self)
		self.setupSocket()
	}

	private func setupSocket() {
		try! socket.bind(toPort: port)
		try! socket.joinMulticastGroup(host)
		try! socket.beginReceiving()
	}

	private func convert(_ content: String) -> [String: String] {
		var temp: [String: String] = [:]

		content.components(separatedBy: "\r\n")
			.filter { $0.contains(": ") }
			.compactMap { $0.components(separatedBy: ": ") }
			.filter { !$0.contains("Server") && !$0.contains("Cache-Control") }
			.forEach { temp[$0[0].lowercased()] = $0[1] }

		return temp
	}
}

// MARK: - DiscoverDevicesServiceProtocol

extension DiscoverYeelightDevicesService: DiscoverDevicesServiceProtocol {
	func discoverDevices() {
		let data = "M-SEARCH * HTTP/1.1\r\nHOST: 239.255.255.250:1982\r\nMAN: \"ssdp:discover\"\r\nST: wifi_bulb".data(using: .utf8)!
		socket.send(data, toHost: host, port: port, withTimeout: 1000, tag: 0)
	}
}

// MARK: - GCDAsyncUdpSocketDelegate

extension DiscoverYeelightDevicesService: GCDAsyncUdpSocketDelegate {
	func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
		guard
			let content = String(data: data, encoding: .utf8),
			content.contains("id") && content.contains("yeelight://") && content.contains("model")
		else { return }

		didDiscoverDevice?(Device(with: convert(content), socketID: deviceSocketID))
		deviceSocketID += 1
	}
}
