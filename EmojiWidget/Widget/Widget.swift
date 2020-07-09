//
//  Widget.swift
//  Widget
//
//  Created by Andrea Stevanato on 08/07/2020.
//

import WidgetKit
import SwiftUI

struct EmojiEntry: TimelineEntry {
    let date = Date()
    let emoji: Emoji
}

struct Provider: TimelineProvider {

    @AppStorage("emoji", store: UserDefaults(suiteName: "group.com.as.ios14.widget.iOS14-Widget"))
    var emojiData: Data = Data()

    func snapshot(with context: Context, completion: @escaping (EmojiEntry) -> ()) {
        guard let emoji = try? JSONDecoder().decode(Emoji.self, from: emojiData) else { return }

        let entry = EmojiEntry(emoji: emoji)
        completion(entry)
    }

    func timeline(with context: Context, completion: @escaping (Timeline<EmojiEntry>) -> ()) {
        guard let emoji = try? JSONDecoder().decode(Emoji.self, from: emojiData) else { return }

        let entry = EmojiEntry(emoji: emoji)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }

}

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
            HStack(spacing: 30) {
                EmojiView(emoji: entry.emoji)
                Text(entry.emoji.name)
                    .font(.largeTitle)
            }

        default:
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

@main
struct iOS14Widgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        EmojiWidget()
    }
}

struct EmojiWidget: Widget {
    private let kind = "com.as.ios14.widget.iOS14-Widget.Widget"

    /**
     Kind -> A unique identifier for the widget. You can fill in any identifier you want. You need this identifier if you want to reload your widget from code.
     Provider -> The provider is needed to determine the timeline for refreshing your widget.
     Placeholder -> This is a view which is displayed to the user before your is loaded with content
     Content closure -> The content closure contains the widget view that needs to be displayed to the user (for all sizes).
     */
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider(),
            placeholder: PlaceholderView()
        ) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Emoji Widget")
        .description("Displays emoji")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
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
