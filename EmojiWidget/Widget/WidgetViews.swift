//
//  Widget.swift
//  Widget
//
//  Created by Andrea Stevanato on 08/07/2020.
//

import WidgetKit
import SwiftUI

struct PlaceholderView: View {
    var body: some View {
        EmojiView(emoji: Emoji(icon: "🤓", name: "", description: ""))
    }
}

struct WidgetEntryView: View {
    let entry: Provider.Entry

    @Environment(\.widgetFamily) var family

    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            EmojiView(emoji: entry.emoji)

        case .systemMedium:
            HStack {
                Image(uiImage: entry.image)
                HStack(spacing: 30) {
                    EmojiView(emoji: entry.emoji)
                    Text(entry.emoji.name)
                        .font(.largeTitle)
                }
            }

        default:
            HStack {
                Image(uiImage: entry.image)
                VStack(spacing: 30) {
                    EmojiView(emoji: entry.emoji)
                    Text(entry.emoji.name)
                        .font(.largeTitle)
                }
                Text(entry.emoji.description)
                    .font(.title2)
                    .padding()
            }
        }
    }
}

// MARK: Previews

struct WidgetEntryViewSmall_Previews: PreviewProvider {
    static var previews: some View {
        WidgetEntryView(entry: EmojiEntry(emoji: Emoji(icon: "🤓",
                                                       name: "Name",
                                                       description: "Description")))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Small widget")
            .environment(\.colorScheme, .light)
    }
}

struct WidgetEntryViewMedium_Previews: PreviewProvider {
    static var previews: some View {
        WidgetEntryView(entry: EmojiEntry(emoji: Emoji(icon: "🤓",
                                                       name: "Name",
                                                       description: "Description")))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("Medium widget")
            .environment(\.colorScheme, .light)
    }
}

struct WidgetEntryViewLarge_Previews: PreviewProvider {
    static var previews: some View {
        WidgetEntryView(entry: EmojiEntry(emoji: Emoji(icon: "🤓",
                                                       name: "Name",
                                                       description: "Description")))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .previewDisplayName("Large widget")
            .environment(\.colorScheme, .light)
    }
}
