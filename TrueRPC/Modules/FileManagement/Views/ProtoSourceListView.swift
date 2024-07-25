import SwiftUI

struct ProtoSourceListView: View {
	@ObservedObject var viewModel: ProtoSourceListViewModel
	
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
			Button(action: viewModel.addProtoSource) {
				Label("Add File", systemImage: "plus")
			}
		}
	}
}
