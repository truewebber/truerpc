import SwiftUI
import SwiftData

struct AddProtoSourceView: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var modelContext

	@State private var protoSource: ProtoSource
	@State private var isEditing: Bool
	@State private var validationError: String?

	init(protoSource: ProtoSource? = nil) {
		if let protoSource = protoSource {
			self._protoSource = State(initialValue: protoSource)
			self.isEditing = true
		} else {
			self._protoSource = State(initialValue: ProtoSource(source: "", workDir: ""))
			self.isEditing = false
		}
	}

	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			Text(isEditing ? "Edit Proto Source" : "Add New Proto Source")
				.font(.headline)
				.padding(.top, 10)

			CustomFileInputField(
				title: "Proto Source:",
				text: $protoSource.source,
				allowsDirectories: false
			)

			if let validationError = validationError {
				Text(validationError)
					.foregroundColor(.red)
			}

			CustomFileInputField(
				title: "Working directory:",
				text: $protoSource.workDir,
				allowsDirectories: true
			)

			Spacer().frame(height: 15)

			HStack {
				Button("Cancel") {
					dismiss()
				}
				Spacer()
				Button("Save") {
					if protoSource.isValidProto() {
						saveProtoSource()
						dismiss()
					} else {
						validationError = "Invalid proto source. Please ensure it is a valid proto file."
					}
				}
				.disabled(protoSource.source.isEmpty || protoSource.workDir.isEmpty)
			}
		}
		.padding()
		.frame(minWidth: 500, idealWidth: 600, maxWidth: .infinity, minHeight: 150, idealHeight: 250, maxHeight: .infinity)
		.background(Color(.windowBackgroundColor))
	}

	private func saveProtoSource() {
		if !isEditing {
			modelContext.insert(protoSource)
		}
	}
}

#Preview {
	do {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: ProtoSource.self, configurations: config)

		let sampleProtoSource = ProtoSource(source: "/path/to/sample.proto", workDir: "/path/to/work/dir")
		container.mainContext.insert(sampleProtoSource)

		return AddProtoSourceView(protoSource: sampleProtoSource)
			.modelContainer(container)
	} catch {
		return Text("Failed to create preview: \(error.localizedDescription)")
	}
}
