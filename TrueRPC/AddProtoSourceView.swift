import SwiftUI

struct AddProtoSourceView: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var modelContext
	@Binding var protoSource: String
	@Binding var workDir: String
	@State private var isSelectingProtoSource = false
	@State private var isSelectingWorkDir = false

	var body: some View {
		VStack(spacing: 10) { // Reduced spacing between elements
			Text("Add New Proto Source")
				.font(.headline)
				.padding(.top, 10) // Small top padding

			Form {
				HStack {
					Text("Proto Source:")
					Spacer()
					TextField("Select Proto Source", text: $protoSource)
						.disabled(true)
						.textFieldStyle(PlainTextFieldStyle())
						.frame(maxWidth: 250)
					Button("Browse") {
						isSelectingProtoSource.toggle()
					}
				}
				.padding(.horizontal)
				.fileImporter(
					isPresented: $isSelectingProtoSource,
					allowedContentTypes: [.data],
					allowsMultipleSelection: false
				) { result in
					switch result {
					case .success(let urls):
						if let url = urls.first {
							protoSource = url.path
						}
					case .failure(let error):
						print("Failed to pick proto source: \(error.localizedDescription)")
					}
				}

				HStack {
					Text("Work Directory:")
					Spacer()
					TextField("Select Work Directory", text: $workDir)
						.disabled(true)
						.textFieldStyle(PlainTextFieldStyle())
						.frame(maxWidth: 250)
					Button("Browse") {
						isSelectingWorkDir.toggle()
					}
				}
				.padding(.horizontal)
				.fileImporter(
					isPresented: $isSelectingWorkDir,
					allowedContentTypes: [.folder],
					allowsMultipleSelection: false
				) { result in
					switch result {
					case .success(let urls):
						if let url = urls.first {
							workDir = url.path
						}
					case .failure(let error):
						print("Failed to pick work directory: \(error.localizedDescription)")
					}
				}
			}
			.padding(.horizontal)

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
			.padding([.horizontal, .bottom])
		}
		.frame(width: 400, height: 200)
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
}

#Preview {
	AddProtoSourceView(protoSource: .constant(""), workDir: .constant(""))
		.modelContainer(for: ProtoSource.self, inMemory: true)
}
