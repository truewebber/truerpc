import SwiftUI

struct FileManagementModule {
	static func makeFileListView() -> some View {
		let viewModel = FileListViewModel(fileManager: CustomFileManager())
		return FileListView(viewModel: viewModel)
	}
	
	static func makeFileContentView(viewModel: FileListViewModel) -> some View {
		FileContentView(viewModel: viewModel)
	}
}
