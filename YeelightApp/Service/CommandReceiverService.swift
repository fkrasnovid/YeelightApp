import CocoaAsyncSocket

public protocol CommandReceiver: AnyObject {
	func connect(to host: String, port: UInt16, completion: ((Bool) -> Void)?)
	func disconnect()
	func sendCommand(_ command: DeviceCommand)
}

public final class CommandReceiverService: NSObject, GCDAsyncSocketDelegate {
	private let tcpSocket: GCDAsyncSocket

	public init(tcpSocket: GCDAsyncSocket) {
		self.tcpSocket = tcpSocket
		super.init()
		self.tcpSocket.synchronouslySetDelegate(self)
	}
}

extension CommandReceiverService: CommandReceiver {
	public func connect(to host: String, port: UInt16, completion: ((Bool) -> Void)?) {
		do {
			try tcpSocket.connect(toHost: host, onPort: port)
		} catch {
			completion?(false)
		}
		completion?(true)
	}

	public func disconnect() {
		tcpSocket.disconnect()
	}

	public func sendCommand(_ command: DeviceCommand) {
		tcpSocket.write(command.data, withTimeout: 3, tag: 0)
	}
}
