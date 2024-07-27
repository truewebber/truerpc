import Foundation
import SwiftProtobuf

class ProtoSourceManager: ObservableObject {
	@Published var sources: [ProtoSource] = []

	init() {
		loadProtoSources()
	}

	func addProtoSource(protoSource: ProtoSource) {
		do {
			let sourceFileURL = URL(fileURLWithPath: protoSource.sourceFile)
			let sourceFileBookmarkData = try sourceFileURL.bookmarkData(options: [.withSecurityScope, .securityScopeAllowOnlyReadAccess], includingResourceValuesForKeys: nil, relativeTo: nil)

			protoSource.sourceFileBookmarkData = sourceFileBookmarkData

			sources.append(protoSource)
			saveProtoSources()
		} catch {
			print("Error creating bookmark: \(error)")
		}
	}

	func removeProtoSources(at offsets: IndexSet) {
		sources.remove(atOffsets: offsets)
		saveProtoSources()
	}

	func readProtoContent(_ protoSource: ProtoSource) throws -> String {
		if protoSource.sourceFileBookmarkData == nil {
			throw NSError(domain: "ProtoSourceManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "proto source file bookmark data is nil"])
		}

		var url: URL

		do {
			url = try getFileURLAndUnlock(bookmarkData: protoSource.sourceFileBookmarkData!)
		} catch {
			throw error
		}

		defer {
			lockFile(url: url)
		}

		let contents = try String(contentsOf: url)

		return contents
	}

	func getProtoDiscriptors(_ protoSource: ProtoSource) throws -> Google_Protobuf_FileDescriptorSet? {
		if protoSource.sourceFileBookmarkData == nil {
			throw NSError(domain: "ProtoSourceManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "proto source file bookmark data is nil"])
		}

		var url: URL

		do {
			url = try getFileURLAndUnlock(bookmarkData: protoSource.sourceFileBookmarkData!)
		} catch {
			throw error
		}

		defer {
			lockFile(url: url)
		}
		
		var fileDescriptorSet: Google_Protobuf_FileDescriptorSet

		do {
			let protoDescriptosFile = try TempFile()

			guard let protocPath = Bundle.main.path(forResource: "protoc", ofType: "") else {
				generalLog.error("protoc doesn't exist in app bundle")

				return nil
			}

			guard let includePath = Bundle.main.path(forResource: "include", ofType: "") else {
				generalLog.error("include dir doesn't exist in app bundle")

				return nil
			}

			let process = Process()
			process.executableURL = URL(fileURLWithPath: protocPath)
			process.arguments = [
				"-I", protoSource.workDir,
				"-I", includePath,
				"-o", protoDescriptosFile.getFilePath(),
				url.path(),
			]

			let pipe = Pipe()
			process.standardOutput = pipe
			process.standardError = pipe

			try process.run()
			process.waitUntilExit()

			let data = pipe.fileHandleForReading.readDataToEndOfFile()
			let output = String(data: data, encoding: .utf8) ?? ""

			if process.terminationStatus != 0 {
				generalLog.error("faied to execute protoc, process: \(process), output: \(output)")

				return nil
			}

			let tempURL = URL(fileURLWithPath: protoDescriptosFile.getFilePath())
			let protobufBytes = try Data(contentsOf: tempURL)

			fileDescriptorSet = try Google_Protobuf_FileDescriptorSet(serializedBytes: protobufBytes)
		} catch TempFile.TempFileError.fileCreationFailed {
			generalLog.error("faied to create temp file")

			return nil
		} catch {
			generalLog.error("faied validate proto: \(error)")

			return nil
		}

		return fileDescriptorSet
	}
	
	private func getFileURLAndUnlock(bookmarkData: Data) throws -> URL {
		var url: URL
		var isStale = false

		do {
			url = try URL(resolvingBookmarkData: bookmarkData,
							  options: .withSecurityScope,
							  relativeTo: nil,
							  bookmarkDataIsStale: &isStale)
		} catch {
			throw error
		}

		if isStale {
			print("Warning: Bookmark is stale")
		}

		guard url.startAccessingSecurityScopedResource() else {
			throw NSError(domain: "ProtoSourceManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to access security-scoped resource"])
		}
		
		return url
	}
	
	private func lockFile(url: URL) {
		url.stopAccessingSecurityScopedResource()
	}

	private func saveProtoSources() {
		let protoData = sources.map { [
			"uuid": $0.id.uuidString,
			"sourceFile": $0.sourceFile,
			"workDir": $0.workDir,
			"sourceFileBookmarkData": $0.sourceFileBookmarkData ?? "",
			"workDirBookmarkData": $0.workDirBookmarkData ?? "",
		] }
		UserDefaults.standard.set(protoData, forKey: "savedProtoSources")
	}

	private func loadProtoSources() {
		guard let protoData = UserDefaults.standard.array(forKey: "savedProtoSources") as? [[String: Any]] else { return }

		sources = protoData.compactMap { fileInfo in
			guard let uuidString = fileInfo["uuid"] as? String,
				  let sourceFile = fileInfo["sourceFile"] as? String,
				  let workDir = fileInfo["workDir"] as? String else {
				return nil
			}

			let source = ProtoSource(
				id: UUID(uuidString: uuidString)!,
				sourceFile: sourceFile,
				workDir: workDir
			)

			if let sourceFileBookmarkData = fileInfo["sourceFileBookmarkData"] as? Data {
				source.sourceFileBookmarkData = sourceFileBookmarkData
			}

			if let workDirBookmarkData = fileInfo["workDirBookmarkData"] as? Data {
				source.workDirBookmarkData = workDirBookmarkData
			}

			return source
		}
	}
}
