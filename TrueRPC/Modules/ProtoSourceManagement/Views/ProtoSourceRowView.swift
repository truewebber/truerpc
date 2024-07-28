import SwiftUI

struct ProtoSourceRowView: View {
	let protoSource: ProtoSource
	let action: () -> Void

	var body: some View {
		Text(protoSource.sourceFile)
			.onTapGesture(perform: action)
	}
}

#Preview {
	let protoSource = ProtoSource(id:UUID(), sourceFile: "file", workDir: "dir")

	return ProtoSourceRowView(protoSource: protoSource, action: {})
}
