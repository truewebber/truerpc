import SwiftUI

struct ProtoSourceManagementModule {
	static func makeProtoSourceListView() -> some View {
		let viewModel = ProtoSourceListViewModel(manager: ProtoSourceManager())
		return ProtoSourceListView(viewModel: viewModel)
	}
	
	static func makeProtoSourceContentView(viewModel: ProtoSourceListViewModel) -> some View {
		ProtoSourceContentView(viewModel: viewModel)
	}
}
