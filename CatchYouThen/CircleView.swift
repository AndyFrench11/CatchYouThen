import SwiftUI
import ConfettiSwiftUI

struct CircleView: View {
    @EnvironmentObject var store: Store
    @State private var imageRevealed = false
    @State private var counter: Int = 0
    
    var images = imageNames()
    
    @ViewBuilder
    private func imageView() -> some View {
        GeometryReader { reader in
            Image(uiImage: UIImage(named: images[store.getDaysRemaining()])!)
                .resizable()
                .scaledToFill()
                .frame(width: reader.size.width, height: reader.size.height)
                .clipShape(Circle())
       }
            
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if imageRevealed {
                VStack {
                    Text("Days remaining")
                        .font(.title)
                        .transition(.slide)

                    Text("\(store.getDaysRemaining())")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.green)
                    
                }
                .padding(.top, 32)
                .transition(.scale(scale: 4.0))
            }
            
            Button {
                withAnimation(.spring(response: 0.75, dampingFraction: 0.5, blendDuration: 4.0)) {
                    imageRevealed = true
                    counter += 1
                }
            } label: {
                ZStack {
                    // TODO: Different views
                    
                    if imageRevealed {
                        imageView()
                            .overlay(Circle().stroke(.white, lineWidth: 4))
                            .shadow(radius: 7)
                            .transition(.scale(scale: 2.0))
                    } else {
                        imageView()
                            .blur(radius: 50)
                    }
                    
                    if !imageRevealed {
                        Text("Tap to reveal days remaining...")
                            .foregroundColor(.white)
                            .bold()
                    }
                }
            }
            .confettiCannon(counter: $counter, num: 100, rainHeight: 1100, radius: 500)
            .padding(.horizontal, 16)
        }
    }
    
}

// TODO: Saving code for when state is changed
//Task {
//    do {
//        store.appData.lastOpened = Date()
//        try await Store.save(appData: store.appData)
//    } catch {
//        fatalError("Error saving app data.")
//    }
//}
