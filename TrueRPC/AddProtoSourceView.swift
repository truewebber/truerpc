import SwiftUI

struct AddProtoSourceView: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var modelContext
	@Binding var protoSource: String
	@Binding var workDir: String
	@State private var isSelectingProtoSource = false
	@State private var isSelectingWorkDir = false

	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			Text("Add New Proto Source")
				.font(.headline)
				.padding(.top, 10)

			CustomFileInputField(
				title: "Proto Source:",
				text: $protoSource,
				action: { isSelectingProtoSource.toggle() }
			)
			.fileImporter(
				isPresented: $isSelectingProtoSource,
				allowedContentTypes: [.data],
				allowsMultipleSelection: false
			) { result in
				if case .success(let urls) = result, let url = urls.first {
					protoSource = url.path
				}
			}

			CustomFileInputField(
				title: "Working directory:",
				text: $workDir,
				action: { isSelectingWorkDir.toggle() }
			)
			.fileImporter(
				isPresented: $isSelectingWorkDir,
				allowedContentTypes: [.folder],
				allowsMultipleSelection: false
			) { result in
				if case .success(let urls) = result, let url = urls.first {
					workDir = url.path
				}
			}

			HStack {
				Button("Cancel") {
					dismiss()
				}
				Spacer()
				Button("Save") {
					addProtoSource()
					dismiss()
				}
				.disabled(protoSource.isEmpty || workDir.isEmpty)
			}
		}
		.padding()
		.background(Color(.windowBackgroundColor))
	}

	private func addProtoSource() {
		withAnimation {
			let newProtoSource = ProtoSource(source: protoSource, workDir: workDir)
			modelContext.insert(newProtoSource)
			protoSource = ""
			workDir = ""
		}
	}
}

struct CustomFileInputField: View {
	let title: String
	@Binding var text: String
	let action: () -> Void

	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			Text(title)
				.font(.caption)
				.foregroundColor(.secondary)
			HStack {
				TextField("", text: $text)
					.textFieldStyle(PlainTextFieldStyle())
				HStack(spacing: 0) {
					Button(action: action) {
						Image(systemName: "plus")
							.foregroundColor(.blue)
					}
					.buttonStyle(PlainButtonStyle())
					Button(action: action) {
						Image(systemName: "folder")
							.foregroundColor(.blue)
					}
					.buttonStyle(PlainButtonStyle())
				}
			}
			.padding(8)
			.background(Color(.textBackgroundColor))
			.cornerRadius(6)
		}
	}
}

#Preview {
	AddProtoSourceView(protoSource: .constant(""), workDir: .constant(""))
		.modelContainer(for: ProtoSource.self, inMemory: true)
}
