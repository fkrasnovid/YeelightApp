public enum PowerMode: Int {
	/// Normal turn on operation (default value).
	case normal = 0

	/// Turn on and switch to CT mode.
	case ct = 1

	/// Turn on and switch to RGB mode.
	case rgb = 2

	/// Turn on and switch to HSV mode.
	case csv = 3

	/// Turn on and switch to color flow mode.
	case colorFlow = 4

	/// Turn on and switch to Night light mode. (Ceiling light only).
	case nightLight = 5
}
