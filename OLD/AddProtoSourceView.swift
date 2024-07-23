import SwiftUI
import SwiftData

struct AddProtoSourceView: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var modelContext
	@StateObject private var controller: AddProtoSourceController

	init(protoSource: ProtoSource, modelContext: ModelContext) {
		_controller = StateObject(wrappedValue: AddProtoSourceController(modelContext: modelContext, protoSource: protoSource))
	}

	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			Text(controller.isEditing ? "Edit Proto Source" : "Add New Proto Source")
				.font(.headline)
				.padding(.top, 10)

			CustomFileInputField(
				title: "Proto Source:",
				text: $controller.protoSource.source,
				allowsDirectories: false
			)

			if let validationError = controller.validationError {
				Text(validationError)
					.foregroundColor(.red)
			}

			CustomFileInputField(
				title: "Working directory:",
				text: $controller.protoSource.workDir,
				allowsDirectories: true
			)

			Spacer().frame(height: 15)

			HStack {
				Button("Cancel") {
					dismiss()
				}
				Spacer()
				Button("Save") {
					if controller.validate() {
						controller.saveProtoSource()
						dismiss()
					}
				}
				.disabled(controller.protoSource.source.isEmpty || controller.protoSource.workDir.isEmpty)
			}
		}
		.padding()
		.frame(minWidth: 500, idealWidth: 600, maxWidth: .infinity, minHeight: 150, idealHeight: 250, maxHeight: .infinity)
		.background(Color(.windowBackgroundColor))
	}
}

#Preview {
	do {
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: ProtoSource.self, configurations: config)

		let sampleProtoSource = ProtoSource(source: "/path/to/sample.proto", workDir: "/path/to/work/dir")
		container.mainContext.insert(sampleProtoSource)

		return AddProtoSourceView(protoSource: sampleProtoSource, modelContext: container.mainContext)
			.modelContainer(container)
	} catch {
		return Text("Failed to create preview: \(error.localizedDescription)")
	}
}
