import Foundation
import SwiftProtobuf

class ProtoSourceManager: ObservableObject {
	@Published var sources: [ProtoSource] = []

	init() {
		loadProtoSources()
	}

	func addProtoSource(_ protoSource: ProtoSource) {
		let sourceFileURL = URL(fileURLWithPath: protoSource.sourceFile)
		var sourceFileBookmarkData: Data

		do {
			sourceFileBookmarkData = try sourceFileURL.bookmarkData(
				options: [.withSecurityScope, .securityScopeAllowOnlyReadAccess],
				includingResourceValuesForKeys: nil,
				relativeTo: nil
			)
		} catch {
			generalLog.error("Error creating bookmark: \(error)")
			return
		}

		protoSource.sourceFileBookmarkData = sourceFileBookmarkData

		sources.append(protoSource)
		saveProtoSources()
	}

	func removeProtoSources(at offsets: IndexSet) {
		sources.remove(atOffsets: offsets)
		saveProtoSources()
	}

	func getProtoDiscriptors(protoSource: ProtoSource) throws -> Google_Protobuf_FileDescriptorSet? {
		if protoSource.sourceFileBookmarkData == nil {
			throw ProtoParseError.bookmarkIsNotSet
		}

		let url = try getFileURLAndUnlock(bookmarkData: protoSource.sourceFileBookmarkData!)

		defer {
			lockFile(url: url)
		}

		return try getProtoDiscriptors(url: url, workDir: protoSource.workDir)
	}

	func getProtoDiscriptors(url: URL, workDir: String) throws -> Google_Protobuf_FileDescriptorSet? {
		let protoDescriptosFile = try TempFile()

		guard let protocPath = Bundle.main.path(forResource: "protoc", ofType: "") else {
			throw ProtoParseError.protocNotFound
		}

		guard let includePath = Bundle.main.path(forResource: "include", ofType: "") else {
			throw ProtoParseError.protoIncludeNotFound
		}

		let process = Process()
		process.executableURL = URL(fileURLWithPath: protocPath)
		process.arguments = [
			"-I", workDir,
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
		let returnCode = process.terminationStatus

		if returnCode != 0 {
			throw ProtoParseError.protoReturnsNonZeroCode(output: output, command: processCommandString(process), returnCode: returnCode)
		}

		let tempURL = URL(fileURLWithPath: protoDescriptosFile.getFilePath())
		let protobufBytes = try Data(contentsOf: tempURL)

		return try Google_Protobuf_FileDescriptorSet(serializedBytes: protobufBytes)
	}
	
	private func processCommandString(_ process: Process) -> String {
		let executable = process.executableURL?.path ?? ""
		let arguments = process.arguments?.joined(separator: " ") ?? ""

		return "\(executable) \(arguments)"
	}

	private func getFileURLAndUnlock(bookmarkData: Data) throws -> URL {
		var url: URL
		var isStale = false

		do {
			url = try URL(
				resolvingBookmarkData: bookmarkData,
				options: .withSecurityScope,
				relativeTo: nil,
				bookmarkDataIsStale: &isStale
			)
		} catch {
			throw FileError.urlFromBookmark(error)
		}

		if isStale {
			generalLog.warning("Bookmark is stale")
		}

		guard url.startAccessingSecurityScopedResource() else {
			throw FileError.startAccessingSecurityScopedResource
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
			
			do {
				let discriptors = try getProtoDiscriptors(protoSource: source)
				source.discriptors = discriptors
			} catch {
				return nil
			}

			return source
		}
	}
}
