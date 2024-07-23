import SwiftUI

struct FileListView: View {
	@ObservedObject var viewModel: FileListViewModel
	
	var body: some View {
		List {
			ForEach(viewModel.fileManager.files) { file in
				FileRowView(file: file) {
					viewModel.loadFileContent(file)
				}
			}
			.onDelete(perform: viewModel.deleteFiles)
		}
		.listStyle(SidebarListStyle())
		.frame(minWidth: 200)
		.toolbar {
			Button(action: viewModel.addFile) {
				Label("Add File", systemImage: "plus")
			}
		}
	}
}
