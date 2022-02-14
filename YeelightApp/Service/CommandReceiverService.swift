import CocoaAsyncSocket

public protocol CommandReceiver: AnyObject {
	func connect(to host: String, port: UInt16, completion: ((Bool) -> Void)?)
	func disconnect()
	func sendCommand(_ command: DeviceCommand, identifiable: DeviceIdentifiable)
}

public final class CommandReceiverService: NSObject, GCDAsyncSocketDelegate {
	private let tcpSocket: GCDAsyncSocket
	private var socketHostPort: (String, UInt16)?

	public init(tcpSocket: GCDAsyncSocket) {
		self.tcpSocket = tcpSocket
		super.init()
		self.tcpSocket.synchronouslySetDelegate(self)
	}

	public func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
		guard
			let string = String(data: data, encoding: .utf8),
			let data = string.replacingOccurrences(of: "\r\n", with: "").data(using: .utf8),
			let encoded = try? JSONDecoder().decode(CommandResponse.self, from: data)
		else { return }

		print(encoded)
	}

	public func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
		tcpSocket.readData(withTimeout: -1, tag: 0)
	}

	public func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
		print(err?.localizedDescription ?? "empty error")
		if let (host, port) = socketHostPort {
			connect(to: host, port: port) { result in
				result ? print("success reconnect") : print("failed reconnect")
			}
		}
	}
}

extension CommandReceiverService: CommandReceiver {
	public func connect(to host: String, port: UInt16, completion: ((Bool) -> Void)?) {
		do {
			socketHostPort = (host, port)
			try tcpSocket.connect(toHost: host, onPort: port)
		} catch {
			completion?(false)
		}
		completion?(true)
	}

	public func disconnect() {
		tcpSocket.disconnect()
	}

	public func sendCommand(_ command: DeviceCommand, identifiable: DeviceIdentifiable) {
		tcpSocket.write(command.data(with: identifiable), withTimeout: 3, tag: 0)
	}
}
