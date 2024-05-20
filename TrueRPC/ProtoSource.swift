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
}
