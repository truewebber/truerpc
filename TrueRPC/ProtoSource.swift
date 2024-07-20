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

	func isValidProto() -> Bool {
		guard let fileContent = try? String(contentsOfFile: source, encoding: .utf8) else {
			return false
		}
		
		return fileContent.contains("syntax = \"proto") && fileContent.contains("message")
	}
}
