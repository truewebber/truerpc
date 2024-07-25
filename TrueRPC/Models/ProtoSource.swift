import Foundation

class ProtoSource: Identifiable {
	var id = UUID()

	var sourceFile: String
	var workDir: String

	var sourceFileBookmarkData: Data?
	var workDirBookmarkData: Data?
	
	init(id: UUID, sourceFile: String, workDir: String) {
		self.id = id
		self.sourceFile = sourceFile
		self.workDir = workDir
	}
}
