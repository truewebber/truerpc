import SwiftUI

struct ProtoSourceContentView: View {
	@ObservedObject var viewModel: ProtoSourceListViewModel
	
	var body: some View {
		if let errorMessage = viewModel.errorMessage {
			Text(errorMessage)
				.foregroundColor(.red)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		} else if viewModel.selectedProtoSource != nil {
			Text(viewModel.protoContent)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		} else {
			Text("Select a proto source to view its content")
				.frame(maxWidth: .infinity, maxHeight: .infinity)
		}
	}
}
