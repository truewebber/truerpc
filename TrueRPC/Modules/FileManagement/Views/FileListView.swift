import SwiftUI

struct FileListView: View {
	@ObservedObject var viewModel: FileListViewModel
	
	var body: some View {
		List {
			ForEach(viewModel.fileManager.files) { file in
				FileRowView(file: file) {
					viewModel.loadFileContent(file)
				}
				.swipeActions(edge: .trailing, allowsFullSwipe: true) {
					Button(role: .destructive) {
						viewModel.deleteFile(file)
					} label: {
						Label("Delete", systemImage: "trash")
					}
				}
			}
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
