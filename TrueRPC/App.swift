import SwiftUI
import os

// Global logger instances
let generalLog = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "general")
let grpcCallLog = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "grpc_call")

@main
struct TrueRPCApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
		}
	}
}
