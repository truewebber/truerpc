import SwiftUI

struct FileContentView: View {
	@ObservedObject var viewModel: FileListViewModel
	
	var body: some View {
		if let errorMessage = viewModel.errorMessage {
			Text(errorMessage)
				.foregroundColor(.red)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		} else if viewModel.selectedFile != nil {
			Text(viewModel.fileContent)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		} else {
			Text("Select a file to view its content")
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		}
	}
}
