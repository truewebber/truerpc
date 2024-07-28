import Foundation

enum ProtoParseError: Error {
	case protocNotFound
	case protoIncludeNotFound
	case protoReturnsNonZeroCode(output: String, command: String, returnCode: Int32)
	case bookmarkIsNotSet
}

extension ProtoParseError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .protocNotFound:
			return "protoc wasn't found"
		case .protoIncludeNotFound:
			return "proto include dir wasn't found"
		case .protoReturnsNonZeroCode(let output, let command, let returnCode):
			return "Command '\(command)' returned non-zero exit code: \(returnCode), output: \(output)"
		case .bookmarkIsNotSet:
			return "bookmark isn't set"
		}
	}
}
