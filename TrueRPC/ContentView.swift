import SwiftUI

struct ContentView: View {
	@StateObject private var viewModel = FileListViewModel()
	
	var body: some View {
		NavigationView {
			FileListView(viewModel: viewModel)
			FileContentView(viewModel: viewModel)
		}
	}
}
