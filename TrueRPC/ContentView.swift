import SwiftData
import SwiftUI

struct ContentView: View {
	@Environment(\.modelContext) private var modelContext
	@Query private var protoSources: [ProtoSource]
	@State private var isSidebarVisible = true
	@State private var showAddProtoSourceView = false
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
							// Your custom action here
						} label: {
							Label("Custom Action", systemImage: "pencil")
						}
						.tint(.blue) // Customize the button color
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

	private func addProtoSource() {
		withAnimation {
			let newProtoSource = ProtoSource(source: protoSource, workDir: workDir)
			modelContext.insert(newProtoSource)
			// Clear input fields after adding
			protoSource = ""
			workDir = ""
		}
	}

	private func deleteProtoSource(protoSource: ProtoSource) {
		withAnimation {
			modelContext.delete(protoSource)
		}
		// Assuming you have a method to commit changes; call it here if necessary.
		// e.g., try? modelContext.save()
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
