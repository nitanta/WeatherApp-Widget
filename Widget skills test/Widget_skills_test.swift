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
        WeatherDataEntry(isLoading: true, backgroundImage: getImageInFiles())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (WeatherDataEntry) -> ()) {
        let entry = WeatherDataEntry(isLoading: true, backgroundImage: getImageInFiles())
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        locationManager.fetchLocation { (location) in
            switch location {
            case .success(let coord):
                weatherManager.fetchData(location: coord) { (response) in
                    var iconName: String = ""
                    let locationName: String = response.name + ", " + response.sys.country
                    if let weather = response.weather.first {
                        iconName = WeatherType(rawValue: weather.main)?.imageName ?? ""
                    }
                    let backgroundImage = getImageInFiles()
                    let entries = [
                        WeatherDataEntry(backgroundImage: backgroundImage, weatherImage: iconName, location: locationName)
                    ]
                    let timeline = Timeline(entries: entries, policy: .after(Date(timeIntervalSinceNow: 10)))
                    completion(timeline)
                }
            case .failure(let error):
                let backgroundImage = getImageInFiles()
                let entries = [
                    WeatherDataEntry(errorMessage: error.localizedDescription, backgroundImage: backgroundImage)
                ]
                let timeline = Timeline(entries: entries, policy: .after(Date(timeIntervalSinceNow: 10)))
                completion(timeline)
            }
        }
    }
    
}

struct WeatherDataEntry: TimelineEntry {
    var isLoading: Bool = false
    var errorMessage: String = ""
    var backgroundImage: UIImage = UIImage()
    var weatherImage: String = ""
    var location: String = ""
    let date: Date = Date()
    
    init(isLoading: Bool, backgroundImage: UIImage) {
        self.isLoading = false
        self.backgroundImage = backgroundImage
    }
    
    init(errorMessage: String, backgroundImage: UIImage) {
        self.errorMessage = errorMessage
        self.backgroundImage = backgroundImage
    }
    
    init(backgroundImage: UIImage, weatherImage: String, location: String) {
        self.backgroundImage = backgroundImage
        self.weatherImage = weatherImage
        self.location = location
    }
}

struct Widget_skills_testEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        
        ZStack {
            
            Image(uiImage: entry.backgroundImage)
            
            if entry.isLoading {
                
                Text("Loading ...")
                    .font(.custom(FontName.fontRoundedBold, size: 18))

            } else if !entry.errorMessage.isEmpty {
                Text(entry.errorMessage)
                    .font(.custom(FontName.fontRoundedBold, size: 18))
            } else {
                
                HStack {
                    if family != .systemMedium {
                        Spacer()
                    }
                    
                    VStack(alignment: self.getContainerAlignment()) {
                        
                        Image(entry.weatherImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: self.getIconSize(), height: self.getIconSize())
                        
                        Spacer()
                            .frame(height: 10)
                        
                        Text(entry.location)
                            .font(.custom(FontName.fontRoundedBold, size: self.getFontSize()))
                            .foregroundColor(self.getColor())
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                        
                        
                    }
                    .padding(16)
                    
                    Spacer()
                }
                
            }
            
        }
    }
    
    func getFontSize() -> CGFloat {
        switch family {
        case .systemSmall: return 18
        case .systemMedium: return 24
        case .systemLarge: return 32
        @unknown default: return 18
        }
    }
    
    func getColor() -> Color {
        if entry.backgroundImage != UIImage() {
            return .white
        } else {
            return .black
        }
    }
    
    func getIconSize() -> CGFloat {
        switch family {
        case .systemSmall: return 67
        case .systemMedium: return 82
        case .systemLarge: return 155
        @unknown default: return 67
        }
    }
    
    func getContainerAlignment() -> HorizontalAlignment {
        switch family {
        case .systemSmall: return .center
        case .systemMedium: return .leading
        case .systemLarge: return .center
        @unknown default: return .center
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
        Widget_skills_testEntryView(entry: WeatherDataEntry(backgroundImage: UIImage(), weatherImage: "ic-cloudy", location: "Bharatpur, Chitwan, NP"))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
