import SwiftUI
import SwiftProtobuf

struct ProtoSourceContentView: View {
	@ObservedObject var viewModel: ProtoSourceListViewModel

	var body: some View {
		VStack {
			if let protoContent = viewModel.protoContent {
				ScrollView {
					Text(formatProtoContent(protoContent))
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.padding()
				}
			} else {
				Text("Select a proto source to view its content")
					.frame(maxWidth: .infinity, maxHeight: .infinity)
			}
		}
	}

	private func formatProtoContent(_ protoContent: Google_Protobuf_FileDescriptorSet) -> String {
			var content = ""

			for fileDescriptor in protoContent.file {
				content += "File: \(fileDescriptor.name)\n"
				for service in fileDescriptor.service {
					content += "  Service: \(service.name)\n"
					for method in service.method {
						content += "    Method: \(method.name)\n"
					}
				}
			}

			return content
		}
}

#Preview {
	let viewModel = ProtoSourceListViewModel()
	viewModel.selectedProtoSource = ProtoSource(id:UUID(), sourceFile: "file", workDir: "dir")
	viewModel.protoContent = nil

	return ProtoSourceContentView(viewModel: viewModel)
}
