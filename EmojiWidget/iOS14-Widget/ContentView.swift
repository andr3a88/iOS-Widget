//
//  ContentView.swift
//  iOS14-Widget
//
//  Created by Andrea Stevanato on 08/07/2020.
//

import MapKit
import SwiftUI
import WidgetKit

struct ContentView: View {

    @AppStorage("emoji", store: UserDefaults(suiteName: "group.com.as.ios14.widget.iOS14-Widget"))
    var emojiData: Data = Data()

    let emojis = [
        Emoji(icon: "😃", name: "Happy", description: "The user is happy"),
        Emoji(icon: "😐", name: "Stare", description: "The user is stare"),
        Emoji(icon: "🤬", name: "Heated", description: "The user is not happy"),
    ]

    var body: some View {
        VStack(spacing: 30) {
            ForEach(emojis) { emoji in
                EmojiView(emoji: emoji)
                    .onTapGesture {
                        save(emoji)
                    }
            }
            Text("Countdown")
            Text(Date().addingTimeInterval(60), style: .offset)
                .font(.title2)
                .multilineTextAlignment(.center)
            MapView()
                .padding(.all, 5.0)
                .background(ContainerRelativeShape().fill(Color("AccentColor")))
        }
    }

    func save(_ emoji: Emoji) {
        guard let emojiData = try? JSONEncoder().encode(emoji) else { return }
        self.emojiData = emojiData
        print("save \(emoji)")
        WidgetCenter.shared.reloadTimelines(ofKind: "com.as.ios14.widget.iOS14-Widget.Widget")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



