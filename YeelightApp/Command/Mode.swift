import Foundation

/*
 0: Normal turn on operation (default value)
 1: Turn on and switch to CT mode.
 2: Turn on and switch to RGB mode.
 3: Turn on and switch to HSV mode.
 4: Turn on and switch to color flow mode.
 5: Turn on and switch to Night light mode. (Ceiling light only).
 */
public enum PowerMode: Int {
	case normal = 0
	case ct = 1
	case rgb = 2
	case csv = 3
	case colorFlow = 4
	case nightLight = 5
}
