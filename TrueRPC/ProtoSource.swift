import SwiftData
import Foundation

@Model
class ProtoSource: Identifiable {
	var id: UUID = UUID()
	var source: String
	var workDir: String

	init(source: String, workDir: String) {
		self.source = source
		self.workDir = workDir
	}

	// Add a validation function for proto source
	func isValidProto() -> Bool {
		// Basic validation logic for a proto file
		// This can be replaced with more comprehensive checks
		return source.contains("syntax = \"proto") && source.contains("message")
	}
}
