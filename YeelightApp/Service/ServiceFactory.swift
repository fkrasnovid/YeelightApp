import CocoaAsyncSocket

public final class ServiceFactory {
	var discoverService: DiscoverDevicesServiceProtocol {
		DiscoverYeelightDevicesService(host: "239.255.255.250", port: 1982, onReceive: .main)
	}
	
}

public final class CommandReceiverFactory {
	var commandReceiver: CommandReceiver {
		CommandReceiverService(
			tcpSocket: GCDAsyncSocket(delegate: nil, delegateQueue: .main, socketQueue: .main)
		)
	}
}
