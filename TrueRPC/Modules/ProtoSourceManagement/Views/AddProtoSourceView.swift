import SwiftUI

struct AddProtoSourceView: View {
	@Binding var isPresented: Bool
	@ObservedObject var viewModel: ProtoSourceListViewModel
	@State private var selectedProtoFileURL: URL?
	@State private var selectedWorkDirURL: URL?
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

				if let url = selectedProtoFileURL {
					Text("Selected proto file: \(url.lastPathComponent)")
				} else {
					Text("No file selected")
				}

				if let url = selectedWorkDirURL {
					Text("Selected work dir: \(url.lastPathComponent)")
				} else {
					Text("No dir selected")
				}
			}

			FileSelectionView(
				selectedFileURL: $selectedProtoFileURL,
				onFileSelected: {
					errorMessage = nil
				},
				title: "proto file",
				selectType: FileSelectionView.SelectTypeEnum.Proto
			)

			FileSelectionView(
				selectedFileURL: $selectedWorkDirURL,
				onFileSelected: {
					errorMessage = nil
				},
				title: "work dir",
				selectType: FileSelectionView.SelectTypeEnum.Directory
			)

			HStack(spacing: 20) {
				Button("Save") {
					saveProtoSource()
				}
				.disabled(selectedProtoFileURL == nil || selectedWorkDirURL == nil)

				Button("Cancel") {
					selectedProtoFileURL = nil
					isPresented = false
				}
			}
		}
		.padding()
		.frame(width: 300, height: 300)
	}

	private func saveProtoSource() {
		guard let url = selectedProtoFileURL else { return }

		do {
			try viewModel.addProtoSource(from: url)
			isPresented = false
		} catch ProtoSourceListViewModel.ProtoSourceError.protoIsNotValid {
			errorMessage = "chosen file isn't a valid proto"
		} catch {
			errorMessage = "unknown error occurred"
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
