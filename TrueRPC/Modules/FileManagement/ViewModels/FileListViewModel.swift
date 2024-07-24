import SwiftUI
import UniformTypeIdentifiers

class FileListViewModel: ObservableObject {
	@Published var fileManager: CustomFileManager
	@Published var selectedFile: CustomFile?
	@Published var fileContent: String = ""
	@Published var errorMessage: String?
	
	init(fileManager: CustomFileManager = CustomFileManager()) {
		self.fileManager = fileManager
	}
	
	func addFile() {
		let panel = NSOpenPanel()
		panel.allowsMultipleSelection = false
		panel.canChooseDirectories = false
		panel.allowedContentTypes = [UTType.text]
		if panel.runModal() == .OK {
			if let url = panel.urls.first {
				fileManager.addFile(url: url)
				objectWillChange.send()  // Notify observers of change
			}
		}
	}
	
	func deleteFiles(at offsets: IndexSet) {
		fileManager.removeFiles(at: offsets)
		if selectedFile != nil && !fileManager.files.contains(where: { $0.id == selectedFile!.id }) {
			selectedFile = nil
			fileContent = ""
		}
	}
	
	func deleteFile(_ file: CustomFile) {
		if let index = fileManager.files.firstIndex(where: { $0.id == file.id }) {
			fileManager.removeFiles(at: IndexSet(integer: index))
			objectWillChange.send()
			if selectedFile?.id == file.id {
				selectedFile = nil
				fileContent = ""
			}
		}
	}
	
	func loadFileContent(_ file: CustomFile) {
		do {
			let content = try fileManager.readFileContent(file)
			fileContent = content
			selectedFile = file
			errorMessage = nil
		} catch {
			print("Error reading file: \(error)")
			errorMessage = "Error loading file content: \(error.localizedDescription)"
			fileContent = ""
			selectedFile = nil
		}
	}
}
