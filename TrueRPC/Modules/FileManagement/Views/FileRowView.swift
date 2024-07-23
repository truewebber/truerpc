import SwiftUI

struct FileRowView: View {
	let file: CustomFile
	let action: () -> Void
	
	var body: some View {
		Text(file.name)
			.onTapGesture(perform: action)
	}
}
