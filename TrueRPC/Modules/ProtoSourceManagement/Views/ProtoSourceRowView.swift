import SwiftUI

struct ProtoSourceRowView: View {
	let protoSource: ProtoSource
	let action: () -> Void

	var body: some View {
		DisclosureGroup() {
			ForEach(protoSource.getServices(), id: \.self) { service in
				Text(service)
			}
		} label: {
			Text(protoSource.sourceFile)
				.font(.subheadline)
				.fontWeight(.semibold)
		}
		.onTapGesture(perform: action)
	}
}

#Preview {
	let protoSource = ProtoSource(id:UUID(), sourceFile: "file", workDir: "dir")

	return ProtoSourceRowView(protoSource: protoSource, action: {})
}
