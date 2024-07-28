import SwiftUI
import UniformTypeIdentifiers

struct AddProtoSourceView: View {
	@Binding var isPresented: Bool
	@ObservedObject var viewModel: ProtoSourceListViewModel
	@State private var selectedFileURL: URL?
	
	var body: some View {
		VStack(spacing: 20) {
			Text("Add New Proto Source")
				.font(.headline)
			
			if let url = selectedFileURL {
				Text("Selected file: \(url.lastPathComponent)")
			} else {
				Text("No file selected")
			}
			
			Button("Select File") {
				selectFile()
			}
			
			HStack(spacing: 20) {
				Button("Save") {
					if let url = selectedFileURL {
						viewModel.addProtoSource(from: url)
						isPresented = false
					}
				}
				.disabled(selectedFileURL == nil)
				
				Button("Cancel") {
					selectedFileURL = nil
					isPresented = false
				}
			}
		}
		.padding()
		.frame(width: 300, height: 200)
	}
	
	private func selectFile() {
		let panel = NSOpenPanel()
		panel.allowsMultipleSelection = false
		panel.canChooseDirectories = false
		panel.allowedContentTypes = [UTType.text]
		if panel.runModal() == .OK {
			selectedFileURL = panel.urls.first
		}
	}
}

#Preview {
	@State var isPresented = true
	let viewModel = ProtoSourceListViewModel()
	
	return AddProtoSourceView(isPresented: $isPresented, viewModel: viewModel)
}
