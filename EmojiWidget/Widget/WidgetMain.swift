//
//  Provider.swift
//  WidgetExtension
//
//  Created by Andrea Stevanato on 15/07/2020.
//

import CoreLocation
import Foundation
import UIKit
import WidgetKit
import SwiftUI

@main
struct iOS14Widgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        EmojiWidget()
    }
}

struct EmojiWidget: Widget {
    private let kind = "com.as.ios14.widget.iOS14-Widget.Widget"
    private let backgroundDataProvider = BackgroundDataProvider()

    /**
     Kind -> A unique identifier for the widget. You can fill in any identifier you want. You need this identifier if you want to reload your widget from code.
     Provider -> The provider is needed to determine the timeline for refreshing your widget.
     Placeholder -> This is a view which is displayed to the user before your is loaded with content
     Content closure -> The content closure contains the widget view that needs to be displayed to the user (for all sizes).
     */
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) { entry in
            WidgetEntryView(entry: entry)
        }
        .onBackgroundURLSessionEvents(matching: { (identifier: String) -> Bool in
            identifier == "widget_image_downloader"
        }, { (identifier: String, completion: @escaping () -> ()) in
            self.backgroundDataProvider.performRequest()
            self.backgroundDataProvider.completionHandler = completion
            print("onBackgroundURLSessionEvents")
        })
        .configurationDisplayName("Emoji Widget")
        .description("Displays emoji")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct EmojiEntry: TimelineEntry {
    let date = Date()
    let emoji: Emoji
    var image: Image
    var map: Image
}

struct Provider: TimelineProvider {

    @ObservedObject var locationProvider: LocationProvider = LocationProvider()

    @AppStorage("emoji", store: UserDefaults(suiteName: "group.com.as.ios14.widget.iOS14-Widget"))
    var emojiData: Data = Data()

    func getSnapshot(in context: Context, completion: @escaping (EmojiEntry) -> ()) {
        guard let emoji = try? JSONDecoder().decode(Emoji.self, from: emojiData) else { return }
        print("snapshot")

        ImageService.getImage(text: "\(Date().toString())", client: NetworkClient()) { image in

            locationProvider.getMap { map in
                let entry = EmojiEntry(emoji: emoji, image: Image(uiImage: image), map: map)
                completion(entry)
            }
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<EmojiEntry>) -> ()) {
        guard let emoji = try? JSONDecoder().decode(Emoji.self, from: emojiData) else { return }

        locationProvider.setup()

        print("Last location \(locationProvider.lastLocation.debugDescription)")

        ImageService.getImage(text: "\(Date().toString())", client: NetworkClient()) { image in

            locationProvider.getMap { map in
                let entry = EmojiEntry(emoji: emoji, image: Image(uiImage: image), map: map)

                // Refresh the data
                let expiryDate = Calendar.current.date(byAdding: .minute, value: 5, to: Date()) ?? Date()
                let timeline = Timeline(entries: [entry], policy: .after(expiryDate))
                completion(timeline)
            }
        }
    }

    func placeholder(in with: Context) -> EmojiEntry {
        EmojiEntry(emoji: Emoji(icon: "🤓", name: "Name", description: "Description"),
                   image: Image(systemName: "applelogo"), map: Image(systemName: "map.fill"))
    }
}
