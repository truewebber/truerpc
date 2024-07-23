import Foundation

struct CustomFile: Identifiable {
	let id = UUID()
	let name: String
	let bookmarkData: Data
}
