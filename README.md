# WeatherApp-Widget

Weather app demonstrating widgets.

Built using UIKit, SwiftUI, Combine

UIKit is used for the main target
SwiftUI is used for the weather widget
Combine for binding viewmodel with the viewcontroller
Codable for parsing data from the open weather api
Endpoint consumed:  "data/2.5/weather"

App requires: 
     Location access
     Camera and photos access
     
Project follows MVVM design pattern.
Combine binding.

Folder structure: 

Source in the main target consists of these groups: 

            Designs: Has the fonts folder, and the struct definig font name
            Managers: Consists of the location manager
            Extensions: Extends functionalities in class
            AppConstants: Consists Global.swift having api-keys and base url
            Network: Consists files handling API call, response parser classes, enums, service class.
            Modules: Consists the views, storyboards, viewcontrollers - make sure that the storyboards are not heavy.
                     Make sure that the modules are separated.
                     
            Assets.xcassests contains the assests for displaying the weather condition.

Widget target consists of a class for handling network resouces.

Also, some classes are shared across multiple targets.


For both the main app and the widget, data gets refreshed every 60 seconds.

Supports iOS 14 - for widget kit support
