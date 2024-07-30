import SwiftUI
import UniformTypeIdentifiers

struct FileSelectionView: View {
	@Binding var selectedFileURL: URL?
	let onFileSelected: () -> Void
	let title: String
	let selectType: SelectTypeEnum
	

	enum SelectTypeEnum {
		case Proto
		case Directory
	}

	var body: some View {
		Button(title) {
			selectFile()
		}
	}
	
	private func selectFile() {
		let panel = NSOpenPanel()

		panel.allowsMultipleSelection = false
		panel.canChooseDirectories = canChooseDirectories()
		panel.canChooseFiles = !canChooseDirectories()
		panel.allowedContentTypes = allowedContentTypes()

		if panel.runModal() == .OK {
			selectedFileURL = panel.urls.first
			onFileSelected()
		}
	}

	private func canChooseDirectories() -> Bool {
		switch (selectType) {
		case SelectTypeEnum.Directory:
			return true
		case SelectTypeEnum.Proto:
			return false
		}
	}

	private func allowedContentTypes() -> [UTType] {
		switch (selectType) {
		case SelectTypeEnum.Directory:
			return []
		case SelectTypeEnum.Proto:
			return [UTType.text]
		}
	}
}

#Preview {
	@State var selectedFileURL: URL?

	return FileSelectionView(
		selectedFileURL: $selectedFileURL,
		onFileSelected: {},
		title: "test",
		selectType: FileSelectionView.SelectTypeEnum.Directory
	)
}
