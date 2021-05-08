//
//  DataExtension.swift
//  Babel skills test
//
//  Created by Nitanta Adhikari on 5/7/21.
//

import Foundation

extension Data {
    /// Converts the data into a raw string format
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
