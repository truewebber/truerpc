import Foundation
import SwiftData

class AddProtoSourceController: ObservableObject {
	@Published var protoSource: ProtoSource
	@Published var validationError: String?
	@Published var isEditing: Bool

	private var modelContext: ModelContext

	init(modelContext: ModelContext, protoSource: ProtoSource) {
		self.modelContext = modelContext
		self.protoSource = protoSource
		self.isEditing = !protoSource.source.isEmpty || !protoSource.workDir.isEmpty
	}

	func saveProtoSource() {
		if !isEditing {
			modelContext.insert(protoSource)
		}
	}

	func validate() -> Bool {
		if isValidProto() {
			validationError = nil
			return true
		} else {
			validationError = "Invalid proto source. Please ensure it is a valid proto file."
			return false
		}
	}

	private func isValidProto() -> Bool {
		let file = TempFile()
		print(file.getFilePath())
		print(file.getFilePath().formatted())
		
		return true
//		guard let protocPath = Bundle.main.path(forResource: "protoc", ofType: "") else {
//			validationError = "protoc binary not found in bundle."
//			return false
//		}
//		
//		let process = Process()
//		process.executableURL = URL(fileURLWithPath: protocPath)
//		process.arguments = ["--proto_path=\(protoSource.workDir)", protoSource.source]
//
//		let pipe = Pipe()
//		process.standardOutput = pipe
//		process.standardError = pipe
//
//		do {
//			try process.run()
//			process.waitUntilExit()
//			
//			let data = pipe.fileHandleForReading.readDataToEndOfFile()
//			let output = String(data: data, encoding: .utf8) ?? ""
//
//			if process.terminationStatus == 0 {
//				return true
//			} else {
//				validationError = "protoc failed: \(output)"
//				return false
//			}
//		} catch {
//			validationError = "Failed to run protoc: \(error.localizedDescription)"
//			return false
//		}
	}
}
