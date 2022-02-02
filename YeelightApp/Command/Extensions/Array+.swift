import Foundation

extension Array {
	mutating func optionalAppend(_ newElement: Element?) -> Self {
		if let newElement = newElement { append(newElement) }
		return self
	}
}
