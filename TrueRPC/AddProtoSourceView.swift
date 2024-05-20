import SwiftUI

struct AddProtoSourceView: View {
	@Environment(\.dismiss) private var dismiss
	@Binding var protoSource: String
	@Binding var workDir: String

	var body: some View {
		VStack {
			Text("Add New Proto Source")
				.font(.headline)
				.padding()

			Form {
				TextField("Proto Source", text: $protoSource)
					.padding()
				TextField("Work Directory", text: $workDir)
					.padding()
			}
			.padding()

			HStack {
				Button("Cancel") {
					dismiss()
				}
				.padding()

				Spacer()

				Button("Save") {
					// Save the new proto source and work directory
					// You can add your save logic here
					dismiss()
				}
				.padding()
				.disabled(protoSource.isEmpty || workDir.isEmpty)
			}
			.padding()
		}
		.frame(width: 400, height: 200)
	}
}

#Preview {
	AddProtoSourceView(protoSource: .constant(""), workDir: .constant(""))
}

