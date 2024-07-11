import SwiftUI

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
	CustomFileInputField(title: "Sample Field", text: .constant(""), action: {})
		.padding()
}

