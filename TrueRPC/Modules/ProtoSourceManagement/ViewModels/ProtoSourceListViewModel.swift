import SwiftUI
import UniformTypeIdentifiers
import SwiftProtobuf

class ProtoSourceListViewModel: ObservableObject {
	@Published var manager: ProtoSourceManager
	@Published var selectedProtoSource: ProtoSource?
	@Published var protoContent: Google_Protobuf_FileDescriptorSet?

	init(manager: ProtoSourceManager = ProtoSourceManager()) {
		self.manager = manager
	}
	
	enum ProtoSourceError: Error {
		case protoIsNotValid
	}

	func addProtoSource(from url: URL) throws {
		let workDir = url.deletingLastPathComponent().path

		do {
			_ = try manager.getProtoDiscriptors(url: url, workDir: workDir)
		} catch {
			throw ProtoSourceError.protoIsNotValid
		}

		let protoSource = ProtoSource(id: UUID(), sourceFile: url.path, workDir: workDir)
		manager.addProtoSource(protoSource)

		objectWillChange.send()
	}
	
	func deleteProtoSource(_ protoSource: ProtoSource) {
		if let index = manager.sources.firstIndex(where: { $0.id == protoSource.id }) {
			manager.removeProtoSources(at: IndexSet(integer: index))
			objectWillChange.send()
			if selectedProtoSource?.id == protoSource.id {
				selectedProtoSource = nil
				protoContent = nil
			}
		}
	}
	
	func readProtoContent(_ protoSource: ProtoSource) {
		protoContent = protoSource.discriptors
	}
}
