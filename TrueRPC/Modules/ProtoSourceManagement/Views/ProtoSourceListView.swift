import SwiftUI

struct ProtoSourceListView: View {
	@ObservedObject var viewModel: ProtoSourceListViewModel
	@State private var isAddingProtoSource = false
	
	var body: some View {
		List {
			ForEach(viewModel.manager.sources) { protoSource in
				ProtoSourceRowView(protoSource: protoSource) {
					viewModel.readProtoContent(protoSource)
				}
				.swipeActions(edge: .trailing, allowsFullSwipe: true) {
					Button(role: .destructive) {
						viewModel.deleteProtoSource(protoSource)
					} label: {
						Label("Delete", systemImage: "trash")
					}
				}
			}
		}
		.listStyle(SidebarListStyle())
		.frame(minWidth: 200)
		.toolbar {
			Button(action: { isAddingProtoSource = true }) {
				Label("Add File", systemImage: "plus")
			}
		}
		.sheet(isPresented: $isAddingProtoSource) {
			AddProtoSourceView(isPresented: $isAddingProtoSource, viewModel: viewModel)
		}
	}
}

#Preview {
	let viewModel = ProtoSourceListViewModel()
	viewModel.manager.sources = [
		ProtoSource(sourceFile: "file1", workDir: ""),
		ProtoSource(sourceFile: "file2", workDir: ""),
		ProtoSource(sourceFile: "file3", workDir: ""),
		ProtoSource(sourceFile: "file4", workDir: "")
	]

	return ProtoSourceListView(viewModel: viewModel)
}
