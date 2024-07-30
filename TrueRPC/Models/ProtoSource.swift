import Foundation
import SwiftProtobuf

class ProtoSource: Identifiable {
	var id = UUID()

	// truth
	var sourceFileBookmarkData: Data?
	var workDirBookmarkData: Data?

	// cache
	var sourceFile: String
	var workDir: String
	var discriptors: Google_Protobuf_FileDescriptorSet?

	init(id: UUID = UUID(), sourceFile: String, workDir: String) {
		self.id = id
		self.sourceFile = sourceFile
		self.workDir = workDir
	}

	func getServices() -> [String] {
		if discriptors == nil {
			return []
		}

		var servicesToReturn: [String] = []

		for fileDescriptor in discriptors!.file {
			for service in fileDescriptor.service {
				servicesToReturn.append("\(fileDescriptor.package).\(service.name)")
			}
		}

		return servicesToReturn
	}
}
