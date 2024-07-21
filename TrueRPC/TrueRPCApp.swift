import SwiftData
import SwiftUI
import os

// Global logger instances
let generalLog = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "general")
let grpcCallLog = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "grpc_call")

@main
struct TrueRPCApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ProtoSource.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
			MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}
