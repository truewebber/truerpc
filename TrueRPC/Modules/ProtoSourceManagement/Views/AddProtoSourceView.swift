import SwiftUI
import UniformTypeIdentifiers

struct AddProtoSourceView: View {
	@Binding var isPresented: Bool
	@ObservedObject var viewModel: ProtoSourceListViewModel
	@State private var selectedFileURL: URL?
	@State private var errorMessage: String?
	
	var body: some View {
		VStack(spacing: 20) {
			Text("Add New Proto Source")
				.font(.headline)
			
			VStack(alignment: .leading, spacing: 5) {
				Text(errorMessage ?? "")
					.font(.caption)
					.foregroundColor(.red)
					.frame(height: 20)
				
				if let url = selectedFileURL {
					Text("Selected file: \(url.lastPathComponent)")
				} else {
					Text("No file selected")
				}
			}
			
			Button("Select File") {
				selectFile()
			}
			
			HStack(spacing: 20) {
				Button("Save") {
					saveProtoSource()
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
			errorMessage = nil
		}
	}
	
	private func saveProtoSource() {
		guard let url = selectedFileURL else { return }

		do {
			try viewModel.addProtoSource(from: url)
			isPresented = false
		} catch {
			errorMessage = error.localizedDescription
		}
	}
}

#Preview {
	struct PreviewWrapper: View {
		@State var isPresented = true
		@StateObject var viewModel = ProtoSourceListViewModel()
		
		var body: some View {
			AddProtoSourceView(isPresented: $isPresented, viewModel: viewModel)
		}
	}
	
	return PreviewWrapper()
}
