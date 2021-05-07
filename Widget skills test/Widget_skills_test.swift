//
//  Widget_skills_test.swift
//  Widget skills test
//
//  Created by Nitanta Adhikari on 5/7/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct Widget_skills_testEntryView : View {
    var entry: Provider.Entry

    var backgroundImage: UIImage
    var weatherImage: String
    var location: String
    var body: some View {
        
        ZStack {
            Image(uiImage: getImageInFiles() ?? UIImage())
            
            VStack {
                
                Image(weatherImage)
                
                Text(location)
            }
        }
    }
    
    func getImageInFiles() -> UIImage? {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.lotuslabs.weatherapp") else { return nil }
        let imageFileURL = containerURL.appendingPathComponent("widgetbackground.jpg")
        do {
            let data = try Data(contentsOf: imageFileURL)
            return UIImage(data: data)
        } catch {
            debugPrint("Reading to files failed.", error.localizedDescription)
            return nil
        }
    }
}

@main
struct Widget_skills_test: Widget {
    let kind: String = "Widget_skills_test"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            Widget_skills_testEntryView(entry: entry, backgroundImage: UIImage(), weatherImage: "ic-cloudy", location: "Nepal")
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct Widget_skills_test_Previews: PreviewProvider {
    static var previews: some View {
        Widget_skills_testEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()), backgroundImage: UIImage(), weatherImage: "", location: "Nepal")
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
