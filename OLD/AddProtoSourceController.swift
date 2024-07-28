//import Foundation
//import SwiftData
//
//class AddProtoSourceController: ObservableObject {
//	@Published var protoSource: ProtoSource
//	@Published var validationError: String?
//	@Published var isEditing: Bool
//
//	private var modelContext: ModelContext
//
//	init(modelContext: ModelContext, protoSource: ProtoSource) {
//		self.modelContext = modelContext
//		self.protoSource = protoSource
//		self.isEditing = !protoSource.source.isEmpty || !protoSource.workDir.isEmpty
//	}
//
//	func saveProtoSource() {
//		if !isEditing {
//			modelContext.insert(protoSource)
//		}
//		
//		protoSource.createBookmarks()
//	}
//
//	func validate() -> Bool {
//		guard FileManager.default.fileExists(atPath: protoSource.source) else {
//			validationError = "Source file wasn't found"
//			return false
//		}
//		
//		guard FileManager.default.fileExists(atPath: protoSource.workDir) else {
//			validationError = "Working directory wasn't found"
//			return false
//		}
//		
//		if isValidSourceFile() {
//			validationError = nil
//			return true
//		} else {
//			validationError = "Invalid proto source. Please ensure it is a valid proto file"
//			return false
//		}
//	}
//
//	private func isValidSourceFile() -> Bool {
//		var isValid = false
//		
//		protoSource.accessSecurityScopedResource { sourceURL, workDirURL in
//			do {
//				let protoData = try String(contentsOf: URL(fileURLWithPath: protoSource.source))
//
//				print(protoData)
//
//				isValid = true
//
//				return
//
//				let protoDescriptosFile = try TempFile()
//
//				guard let protocPath = Bundle.main.path(forResource: "protoc", ofType: "") else {
//					generalLog.error("protoc doesn't exist in app bundle")
//
//					return
//				}
//
//				guard let includePath = Bundle.main.path(forResource: "include", ofType: "") else {
//					generalLog.error("include dir doesn't exist in app bundle")
//
//					return
//				}
//
//				let process = Process()
//				process.executableURL = URL(fileURLWithPath: protocPath)
//				process.arguments = [
//					"-I", protoSource.workDir,
//					"-I", includePath,
//					"-o", protoDescriptosFile.getFilePath(),
//					protoSource.source,
//				]
//
//				let pipe = Pipe()
//				process.standardOutput = pipe
//				process.standardError = pipe
//
//				try process.run()
//				process.waitUntilExit()
//
//				let data = pipe.fileHandleForReading.readDataToEndOfFile()
//				let output = String(data: data, encoding: .utf8) ?? ""
//
//				if process.terminationStatus != 0 {
//					generalLog.error("faied to execute protoc, process: \(process), output: \(output)")
//
//					return
//				}
//			} catch TempFile.TempFileError.fileCreationFailed {
//				generalLog.error("faied to create temp file")
//
//				return
//			} catch {
//				generalLog.error("faied validate proto: \(error)")
//
//				return
//			}
//
//			isValid = true
//		}
//
//		return isValid
//	}
//}
