//import SwiftUI
//import UniformTypeIdentifiers
//
//struct CustomFileInputField: View {
//	var title: String
//	@Binding var text: String
//	var allowsDirectories: Bool
//	@State private var showValidationAlert = false
//
//	var body: some View {
//		VStack(alignment: .leading, spacing: 4) {
//			Text(title)
//				.font(.caption)
//				.foregroundColor(.secondary)
//			HStack {
//				TextField("", text: $text)
//					.textFieldStyle(PlainTextFieldStyle())
//					.onSubmit(validateAndRequestAccess)
//				Button(action: openPanel) {
//					Image(systemName: "folder")
//						.foregroundColor(.blue)
//				}
//				.buttonStyle(PlainButtonStyle())
//			}
//			.padding(8)
//			.background(Color(.textBackgroundColor))
//			.cornerRadius(6)
//		}
//		.alert("Access Denied", isPresented: $showValidationAlert) {
//			Button("Use File Picker") {
//				openPanel()
//			}
//			Button("Cancel", role: .cancel) {}
//		} message: {
//			Text("Unable to access the specified path. Please use the file picker to select the file/directory.")
//		}
//	}
//
//	private func validateAndRequestAccess() {
//		let url = URL(fileURLWithPath: text)
//		if FileManager.default.fileExists(atPath: url.path) {
//			if !url.startAccessingSecurityScopedResource() {
//				showValidationAlert = true
//			}
//		} else {
//			showValidationAlert = true
//		}
//	}
//
//	private func openPanel() {
//		let panel = NSOpenPanel()
//		panel.allowsMultipleSelection = false
//		panel.canChooseDirectories = allowsDirectories
//		panel.canChooseFiles = !allowsDirectories
//		panel.allowedContentTypes = getAllowedContentTypes(allowsDirectories: allowsDirectories)
//
//		if panel.runModal() == .OK {
//			text = panel.url?.path ?? ""
//			_ = panel.url?.startAccessingSecurityScopedResource()
//		}
//	}
//
//	private func getAllowedContentTypes(allowsDirectories: Bool) -> [UTType] {
//		if !allowsDirectories {
//			return [.data]
//		}
//		return []
//	}
//}
