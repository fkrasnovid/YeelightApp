/// Device identification interface
public protocol DeviceIdentifiable: AnyObject {
	/// Used when sending a command
	var identifier: Int { get }
}
