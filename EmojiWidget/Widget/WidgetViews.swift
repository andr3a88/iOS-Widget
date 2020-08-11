//
//  Widget.swift
//  Widget
//
//  Created by Andrea Stevanato on 08/07/2020.
//

import WidgetKit
import SwiftUI

struct WidgetEntryView: View {
    let entry: Provider.Entry

    @Environment(\.widgetFamily) var family

    @State private var mapSnapshot: Image = Image(systemName: "applelogo")

    @ViewBuilder
    var body: some View {
        Group {
            switch family {
            case .systemSmall:
                EmojiView(emoji: entry.emoji)

            case .systemMedium:
                HStack {
                    entry.image
                        .resizable()
                        .cornerRadius(10)

                    Spacer()
                    HStack(spacing: 30) {
                        EmojiView(emoji: entry.emoji)
                        Text(entry.emoji.name)
                            .font(.title2)
                    }
                }

            case .systemLarge:
                HStack {
                    VStack {
                        entry.image
                            .resizable()
                            .cornerRadius(10)
                        mapSnapshot
                        MapViewWidget(mapSnapshot: $mapSnapshot)
                            .padding(.all, 5.0)
                            .background(ContainerRelativeShape().fill(Color("AccentColor")))
                    }
                    Spacer()
                    VStack {
                        HStack(spacing: 10) {
                            EmojiView(emoji: entry.emoji)
                            Link(
                                entry.emoji.name,
                                destination: URL(string: "https://www.google.it")!
                            )
                        }
                        Text(entry.emoji.description)
                            .font(.title2)
                            .padding()
                    }
                }

            @unknown default:
                fatalError()
            }
        }
        .padding(.all)
        .background(Color("WidgetBackground"))
    }
}

// MARK: Previews

struct WidgetEntryViewSmall_Previews: PreviewProvider {

    static var previews: some View {
        let entry = EmojiEntry(emoji: Emoji(icon: "🤓",
                                            name: "Name",
                                            description: "Description"),
                               image: Image(systemName: "applelogo"))
        Group {
            WidgetEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .previewDisplayName("Small widget")
                .environment(\.colorScheme, .light)
            WidgetEntryView(entry: entry)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .previewDisplayName("Small widget dark")
                .environment(\.colorScheme, .dark)
        }


    }
}

struct WidgetEntryViewMedium_Previews: PreviewProvider {
    static var previews: some View {
        let entry = EmojiEntry(emoji: Emoji(icon: "🤓",
                                            name: "Name",
                                            description: "Description small"),
                               image: Image(systemName: "applelogo"))
        WidgetEntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("Medium widget")
            .environment(\.colorScheme, .light)
    }
}

struct WidgetEntryViewLarge_Previews: PreviewProvider {

    static var previews: some View {
        let entry = EmojiEntry(emoji: Emoji(icon: "🤓",
                                            name: "Name",
                                            description: "Description large"),
                               image: Image(systemName: "applelogo"))
        WidgetEntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .previewDisplayName("Large widget")
            .environment(\.colorScheme, .light)
    }
}
