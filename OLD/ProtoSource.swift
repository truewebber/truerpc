import SwiftData
import Foundation

@Model
class ProtoSource: Identifiable {
	var id: UUID = UUID()

	var source: String
	var workDir: String

	private var sourceBookmarkData: Data?
	private var workDirBookmarkData: Data?

	init(source: String, workDir: String) {
		self.source = source
		self.workDir = workDir
		self.createBookmarks()
	}

	func createBookmarks() {
		let sourceURL = URL(fileURLWithPath: source, isDirectory: false)
		sourceBookmarkData = createBookmark(for: sourceURL)
		
		let workDirURL = URL(fileURLWithPath: workDir, isDirectory: true)
		workDirBookmarkData = createBookmark(for: workDirURL)
	}

	private func createBookmark(for url: URL) -> Data? {
		do {
			return try url.bookmarkData(options: .withSecurityScope,
										includingResourceValuesForKeys: nil,
										relativeTo: nil)
		} catch {
			print("Failed to create bookmark for \(url.path()): \(error)")
			return nil
		}
	}

	func resolveBookmarks() -> (sourceURL: URL?, workDirURL: URL?) {
		let sourceURL = URL(fileURLWithPath: source, isDirectory: false)
		let workDirURL = URL(fileURLWithPath: workDir, isDirectory: true)
		
		return (resolveBookmark(data: sourceBookmarkData, url: sourceURL),
				resolveBookmark(data: workDirBookmarkData, url: workDirURL))
	}

	private func resolveBookmark(data: Data?, url: URL) -> URL? {
		guard let data = data else { return nil }
		do {
			var isStale = false
			let url = try URL(resolvingBookmarkData: data,
							  options: .withSecurityScope,
							  relativeTo: nil,
							  bookmarkDataIsStale: &isStale)
			if isStale {
				print("Bookmark is stale for \(url.path())")
				return createBookmark(for: url).flatMap { resolveBookmark(data: $0, url: url) }
			}
			return url
		} catch {
			print("Failed to resolve bookmark for \(url.path()): \(error)")
			return nil
		}
	}

	func accessSecurityScopedResource(_ block: (URL, URL) -> Void) {
		let (sourceURL, workDirURL) = resolveBookmarks()
		guard let sourceURL = sourceURL, let workDirURL = workDirURL else {
			print("Failed to resolve bookmarks")
			return
		}

		let sourceAccessed = sourceURL.startAccessingSecurityScopedResource()
		let workDirAccessed = workDirURL.startAccessingSecurityScopedResource()

		defer {
			if sourceAccessed { sourceURL.stopAccessingSecurityScopedResource() }
			if workDirAccessed { workDirURL.stopAccessingSecurityScopedResource() }
		}

		block(sourceURL, workDirURL)
	}
}
