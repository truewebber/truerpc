import Foundation

enum FileError: Error {
	case urlFromBookmark(_ error: Error)
	case startAccessingSecurityScopedResource
}

extension FileError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .urlFromBookmark(let error):
			return "failed to get url from bookmarks`: \(error)"
		case .startAccessingSecurityScopedResource:
			return "start accessing security scoped resource"
		}
	}
}
