import Foundation

class TempFile {
	private let filePath: URL
	private let tempDir: URL

	func getFilePath() -> URL {
		return filePath
	}

	init() {
		self.tempDir = FileManager.default.temporaryDirectory
		self.filePath = self.tempDir.appendingPathComponent(UUID().uuidString)

		do {
			try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true, attributes: nil)
		} catch {
			print("Error creating temp directory: \(error.localizedDescription)")
		}
	}

	deinit {
		let fileManager = FileManager.default

		do {
			try fileManager.removeItem(at: filePath)
			try fileManager.removeItem(at: tempDir)
		} catch {
			print("Error deleting file: \(error.localizedDescription)")
		}
	}
}
