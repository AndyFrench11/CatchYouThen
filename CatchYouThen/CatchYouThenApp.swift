import SwiftUI

@main
struct CatchYouThenApp: App {
    @StateObject var store = Store()

    var body: some Scene {
        WindowGroup {
            CircleView()
                .edgesIgnoringSafeArea([.top, .bottom])
                .environmentObject(store)
                .preferredColorScheme(.dark)
        }
    }
}

// TODO: If we ever want loading in the state, add in the following
//.task {
//    do {
//        store.appData = try await Store.load()
//
//        // Reset imageRevealed on new day
//        if Calendar.current.isDateInYesterday(store.appData.lastOpened) {
//            store.appData.imageRevealed = false
//        }
//
//    } catch {
//        fatalError("Error loading app data.")
//    }
//}
