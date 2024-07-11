import SwiftData
import SwiftUI

struct ContentView: View {
	@Environment(\.modelContext) private var modelContext
	// main state
	@Query private var protoSources: [ProtoSource]
	// state to open modal window
	@State private var showAddProtoSourceView = false
	// state for modal window
	@State private var protoSource = ""
	@State private var workDir = ""

	var body: some View {
		NavigationView {
			List {
				ForEach(protoSources) { protoSource in
					NavigationLink {
						Text("Proto Source: \(protoSource.source)\nWork Dir: \(protoSource.workDir)")
					} label: {
						Text(protoSource.source)
							.transition(.slide)
					}
					.swipeActions(edge: .trailing, allowsFullSwipe: true) {
						Button {
							
						} label: {
							Label("Custom Action", systemImage: "pencil")
						}
						.tint(.blue)
						Button(role: .destructive) {
							withAnimation {
								deleteProtoSource(protoSource: protoSource)
							}
						} label: {
							Label("Delete", systemImage: "trash")
						}
					}
				}
			}
			.toolbar {
				ToolbarItem(placement: .automatic) {
					Button(action: toggleSidebar) {
						Label("Toggle Sidebar", systemImage: "sidebar.leading")
					}
				}
				ToolbarItem(placement: .automatic) {
					Button(action: {
						showAddProtoSourceView = true
					}) {
						Label("Add Proto Source", systemImage: "plus")
					}
				}
			}
			.sheet(isPresented: $showAddProtoSourceView) {
				AddProtoSourceView(protoSource: $protoSource, workDir: $workDir)
			}
		}
	}

	private func toggleSidebar() {
		NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
	}

	private func deleteProtoSource(protoSource: ProtoSource) {
		withAnimation {
			modelContext.delete(protoSource)
		}
	}

	private func deleteProtoSources(offsets: IndexSet) {
		withAnimation {
			for index in offsets {
				modelContext.delete(protoSources[index])
			}
		}
	}
}

#Preview {
	ContentView()
		.modelContainer(for: ProtoSource.self, inMemory: true)
}
