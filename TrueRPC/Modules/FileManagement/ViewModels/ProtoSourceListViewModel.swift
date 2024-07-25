import SwiftUI
import UniformTypeIdentifiers

class ProtoSourceListViewModel: ObservableObject {
	@Published var manager: ProtoSourceManager
	@Published var selectedProtoSource: ProtoSource?
	@Published var protoContent: String = ""
	@Published var errorMessage: String?

	init(manager: ProtoSourceManager = ProtoSourceManager()) {
		self.manager = manager
	}

	func addProtoSource() {
		let panel = NSOpenPanel()
		panel.allowsMultipleSelection = false
		panel.canChooseDirectories = false
		panel.allowedContentTypes = [UTType.text]
		if panel.runModal() == .OK {
			if let url = panel.urls.first {
				let protoSource = ProtoSource(id: UUID(), sourceFile: url.path(), workDir: url.deletingLastPathComponent().path())

				manager.addProtoSource(protoSource: protoSource)
				objectWillChange.send()  // Notify observers of change
			}
		}
	}
	
	func deleteProtoSources(at offsets: IndexSet) {
		manager.removeProtoSources(at: offsets)
		if selectedProtoSource != nil && !manager.sources.contains(where: { $0.id == selectedProtoSource!.id }) {
			selectedProtoSource = nil
			protoContent = ""
		}
	}
	
	func deleteProtoSource(_ protoSource: ProtoSource) {
		if let index = manager.sources.firstIndex(where: { $0.id == protoSource.id }) {
			manager.removeProtoSources(at: IndexSet(integer: index))
			objectWillChange.send()
			if selectedProtoSource?.id == protoSource.id {
				selectedProtoSource = nil
				protoContent = ""
			}
		}
	}
	
	func readProtoContent(_ protoSource: ProtoSource) {
		do {
			let content = try manager.readProtoContent(protoSource)
			protoContent = content
			selectedProtoSource = protoSource
			errorMessage = nil
		} catch {
			print("Error reading file: \(error)")
			errorMessage = "Error loading file content: \(error.localizedDescription)"
			protoContent = ""
			selectedProtoSource = nil
		}
	}
}
