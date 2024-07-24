import Foundation

class ProtoSourceManager: ObservableObject {
	@Published var sources: [ProtoSource] = []

	init() {
		loadProtoSources()
	}

	func addProtoSource(protoSource: ProtoSource) {
		do {
			let sourceFileURL = URL(fileURLWithPath: protoSource.sourceFile)
			var sourceFileBookmarkData = try sourceFileURL.bookmarkData(options: [.withSecurityScope, .securityScopeAllowOnlyReadAccess], includingResourceValuesForKeys: nil, relativeTo: nil)

			protoSource.sourceFileBookmarkData = sourceFileBookmarkData

			sources.append(protoSource)
			saveProtoSources()
		} catch {
			print("Error creating bookmark: \(error)")
		}
	}

	func removeFiles(at offsets: IndexSet) {
		sources.remove(atOffsets: offsets)
		saveProtoSources()
	}

	func readProtoContent(_ protoSource: ProtoSource) throws -> String {
		var isStale = false

		do {
			if protoSource.sourceFileBookmarkData == nil {
				throw NSError(domain: "ProtoSourceManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "proto source file bookmark data is nil"])
			}

			let url = try URL(resolvingBookmarkData: protoSource.sourceFileBookmarkData!,
							  options: .withSecurityScope,
							  relativeTo: nil,
							  bookmarkDataIsStale: &isStale)

			if isStale {
				print("Warning: Bookmark is stale")
			}

			guard url.startAccessingSecurityScopedResource() else {
				throw NSError(domain: "ProtoSourceManager", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to access security-scoped resource"])
			}

			defer {
				url.stopAccessingSecurityScopedResource()
			}

			let coordinator = NSFileCoordinator()
			var coordinatorError: NSError?
			var contents = ""

			coordinator.coordinate(readingItemAt: url, options: .forUploading, error: &coordinatorError) { (coordinatedURL) in
				do {
					contents = try String(contentsOf: coordinatedURL)
				} catch {
					print("Error reading file: \(error)")
					let localError = error as NSError
					DispatchQueue.main.async {
						coordinatorError = localError
					}
				}
			}

			if let error = coordinatorError {
				throw error
			}

			return contents
		} catch {
			throw error
		}
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
				  let workDir = fileInfo["workDir"] as? String else { return nil }

			guard let sourceFileBookmarkData = fileInfo["sourceFileBookmarkData"] as? Data,
				  let workDirBookmarkData = fileInfo["workDirBookmarkData"] as? Data else { return nil }

			let source = ProtoSource(
				id: UUID(uuidString: uuidString)!,
				sourceFile: sourceFile,
				workDir: workDir
			)
			
			source.sourceFileBookmarkData = sourceFileBookmarkData
			source.workDirBookmarkData = workDirBookmarkData
			
			return source
		}
	}
}

