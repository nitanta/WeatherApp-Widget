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
    
    var locationManager = LocationManager()
    var weatherManager = WidgetNetworkManager(service: WeatherService())
    
    func getImageInFiles() -> UIImage {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.lotuslabs.weatherapp") else { return UIImage() }
        let imageFileURL = containerURL.appendingPathComponent("widgetbackground.jpg")
        do {
            let data = try Data(contentsOf: imageFileURL)
            return UIImage(data: data) ?? UIImage()
        } catch {
            debugPrint("Reading to files failed.", error.localizedDescription)
            return UIImage()
        }
    }
    
    func placeholder(in context: Context) -> WeatherDataEntry {
        WeatherDataEntry(isLoading: true, backgroundImage: UIImage(), weatherImage: "", location: "", date: Date())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (WeatherDataEntry) -> ()) {
        let entry = WeatherDataEntry(isLoading: true, backgroundImage: getImageInFiles(), weatherImage: "", location: "", date: Date())
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        locationManager.fetchLocation { (location) in
            switch location {
            case .success(let coord):
                weatherManager.fetchData(location: coord) { (response) in
                    let entries = [WeatherDataEntry(isLoading: false, backgroundImage: getImageInFiles(), weatherImage: "", location: response.name, date: Date())]
                    let timeline = Timeline(entries: entries, policy: .after(Date(timeIntervalSinceNow: 60)))
                    completion(timeline)
                }
            case .failure:
                let entries = [WeatherDataEntry(isLoading: true, backgroundImage: getImageInFiles(), weatherImage: "", location: "", date: Date())]
                let timeline = Timeline(entries: entries, policy: .after(Date(timeIntervalSinceNow: 60)))
                completion(timeline)
            }
        }
    }
    
}

struct WeatherDataEntry: TimelineEntry {
    let isLoading: Bool
    var backgroundImage: UIImage
    var weatherImage: String
    var location: String
    let date: Date
}

struct Widget_skills_testEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        
        ZStack {
            Image(uiImage: entry.backgroundImage)
            
            if entry.isLoading {
                Text("Loading ...")
            } else {
                VStack {
                    
                    Image(entry.weatherImage)
                    
                    Text(entry.location)
                }
            }
        }
    }
}

@main
struct Widget_skills_test: Widget {
    let kind: String = "Widget_skills_test"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            Widget_skills_testEntryView(entry: entry)
        }
        .configurationDisplayName("Weather Widget")
        .description("Widget app for weather.")
    }
}

struct Widget_skills_test_Previews: PreviewProvider {
    static var previews: some View {
        Widget_skills_testEntryView(entry: WeatherDataEntry(isLoading: true, backgroundImage: UIImage(), weatherImage: "", location: "", date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
