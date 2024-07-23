import SwiftUI

struct ContentView: View {
	@StateObject private var viewModel = FileListViewModel(fileManager: CustomFileManager())
	
	var body: some View {
		NavigationView {
			FileManagementModule.makeFileListView()
			FileManagementModule.makeFileContentView(viewModel: viewModel)
		}
	}
}
