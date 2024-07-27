import SwiftUI

struct ContentView: View {
	@StateObject private var viewModel = ProtoSourceListViewModel()
	
	var body: some View {
		NavigationView {
			ProtoSourceListView(viewModel: viewModel)
			ProtoSourceContentView(viewModel: viewModel)
		}
	}
}

#Preview {
	return ContentView()
}
