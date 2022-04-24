import SwiftUI

enum AppState {
    case imageRevealed
    case imageNotRevealed
}

func imageNames() -> [String] {
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    let items = try! fm.contentsOfDirectory(atPath: path)
    var pictures = [String]()

    for item in items {
        if item.hasSuffix("JPG") || item.hasSuffix("HEIC") {
            pictures.append(item)
        }
    }

    return pictures
}

struct CircleView: View {
    @EnvironmentObject var store: Store

    var images = imageNames()

    var body: some View {
        let daysRemaining = store.getDaysRemaining()

        return VStack {
            if store.appData.imageRevealed {
                Text("Days remaining")
                    .font(.largeTitle)

                Text("\(daysRemaining)")
                    .font(.title)
            }

            Button {
                withAnimation(.default) {
                    store.appData.imageRevealed = true
                    Task {
                        do {
                            store.appData.lastOpened = Date()
                            try await Store.save(appData: store.appData)
                        } catch {
                            fatalError("Error saving app data.")
                        }
                    }
                }
            } label: {
                if !store.appData.imageRevealed {
                    ZStack {
                        Image(uiImage: UIImage(named: images[daysRemaining])!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .blur(radius: 40, opaque: true)
                            .overlay(
                                Circle()
                                    .opacity(0.5)
                            )
                            .clipShape(Circle())

                        // TODO: Make the size of the circle always the same

                        Text("Tap to reveal days remaining...")
                            .foregroundColor(.white)
                    }
                } else {
                    ZStack {
                        Image(uiImage: UIImage(named: images[daysRemaining])!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                    }

                }

            }
        }

    }
}
