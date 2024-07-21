import Foundation

class TempFile {
	private let filePath: URL
	private let tempDir: URL
	
	enum TempFileError: Error {
		case fileCreationFailed
	}

	func getFilePath() -> String {
		return filePath.path
	}

	init() throws {
		self.tempDir = FileManager.default.temporaryDirectory
		self.filePath = self.tempDir.appendingPathComponent(UUID().uuidString)

		if !FileManager.default.createFile(atPath: filePath.path, contents: nil) {
			throw TempFileError.fileCreationFailed
		}
	}

//	deinit {
//		let fileManager = FileManager.default
//
//		do {
//			try fileManager.removeItem(at: filePath)
//		} catch {
//			generalLog.error("Error deleting temp file: \(error)")
//		}
//	}
}
