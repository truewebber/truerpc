import SwiftData
import SwiftUI

struct MainView: View {
	@Environment(\.modelContext) private var modelContext
	@Query private var protoSources: [ProtoSource]
	@State private var selectedProtoSource: ProtoSource? = nil

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
							editNewProtoSource(protoSource: protoSource)
						} label: {
							Label("Edit", systemImage: "pencil")
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
					Button(action: addNewProtoSource) {
						Label("Add Proto Source", systemImage: "plus")
					}
				}
			}
			.sheet(item: $selectedProtoSource) { protoSource in
				AddProtoSourceView(protoSource: protoSource, modelContext: modelContext)
			}
		}
	}

	private func toggleSidebar() {
		NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
	}

	private func addNewProtoSource() {
		selectedProtoSource = ProtoSource(source: "", workDir: "")
	}

	private func editNewProtoSource(protoSource: ProtoSource) {
		selectedProtoSource = protoSource
	}

	private func deleteProtoSource(protoSource: ProtoSource) {
		withAnimation {
			modelContext.delete(protoSource)
		}
	}
}

#Preview {
	do {
		let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: ProtoSource.self, configurations: configuration)
		let context = ModelContext(container)
		let protoSources = [
			ProtoSource(source: "Example Source 1", workDir: "/example/dir1"),
			ProtoSource(source: "Example Source 2", workDir: "/example/dir2")
		]

		for protoSource in protoSources {
			context.insert(protoSource)
		}

		return MainView().environment(\.modelContext, context)
	} catch {
		fatalError("Failed to create model container: \(error)")
	}
}
