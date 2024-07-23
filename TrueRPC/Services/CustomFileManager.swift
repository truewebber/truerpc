import Foundation

class CustomFileManager: ObservableObject {
	@Published var files: [CustomFile] = []
	
	init() {
		loadFiles()
	}
	
	func addFile(url: URL) {
		do {
			let bookmarkData = try url.bookmarkData(options: [.withSecurityScope, .securityScopeAllowOnlyReadAccess],
													includingResourceValuesForKeys: nil,
													relativeTo: nil)
			let file = CustomFile(name: url.lastPathComponent, bookmarkData: bookmarkData)
			files.append(file)
			saveFiles()
		} catch {
			print("Error creating bookmark: \(error)")
		}
	}
	
	func removeFiles(at offsets: IndexSet) {
		files.remove(atOffsets: offsets)
		saveFiles()
	}
	
	func readFileContent(_ file: CustomFile) throws -> String {
		var isStale = false
		do {
			let url = try URL(resolvingBookmarkData: file.bookmarkData,
							  options: .withSecurityScope,
							  relativeTo: nil,
							  bookmarkDataIsStale: &isStale)
			
			if isStale {
				print("Warning: Bookmark is stale")
			}
			
			guard url.startAccessingSecurityScopedResource() else {
				throw NSError(domain: "FileManagerError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to access security-scoped resource"])
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
	
	private func saveFiles() {
		let fileData = files.map { ["name": $0.name, "bookmarkData": $0.bookmarkData] }
		UserDefaults.standard.set(fileData, forKey: "savedFiles")
	}
	
	private func loadFiles() {
		guard let savedFiles = UserDefaults.standard.array(forKey: "savedFiles") as? [[String: Any]] else { return }
		
		files = savedFiles.compactMap { fileInfo in
			guard let name = fileInfo["name"] as? String,
				  let bookmarkData = fileInfo["bookmarkData"] as? Data else { return nil }
			return CustomFile(name: name, bookmarkData: bookmarkData)
		}
	}
}
