import SwiftUI
import UniformTypeIdentifiers

struct CustomFileInputField: View {
	var title: String
	@Binding var text: String
	var allowsDirectories: Bool

	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			Text(title)
				.font(.caption)
				.foregroundColor(.secondary)
			HStack {
				TextField("", text: $text)
					.textFieldStyle(PlainTextFieldStyle())
				Button(action: openPanel) {
					Image(systemName: "folder")
						.foregroundColor(.blue)
				}
				.buttonStyle(PlainButtonStyle())
			}
			.padding(8)
			.background(Color(.textBackgroundColor))
			.cornerRadius(6)
		}
	}

	private func openPanel() {
		let panel = NSOpenPanel()

		panel.allowsMultipleSelection = false
		panel.canChooseDirectories = allowsDirectories
		panel.canChooseFiles = !allowsDirectories
		panel.allowedContentTypes = getAllowedContentTypes(allowsDirectories: allowsDirectories)

		if panel.runModal() == .OK {
			text = panel.url?.path ?? ""
		}
	}
	
	private func getAllowedContentTypes(allowsDirectories: Bool) -> [UTType] {
		if !allowsDirectories {
			return [.data]
		}
		
		return []
	}
}

#Preview {
	CustomFileInputField(
		title: "Sample Field",
		text: .constant(""),
		allowsDirectories: false
	)
	.padding()
}
