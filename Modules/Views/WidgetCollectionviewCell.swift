//
//  WidgetCollectionviewCell.swift
//  Babel skills test
//
//  Created by Nitanta Adhikari on 5/7/21.
//

import UIKit

class WidgetCollectionviewCell: UICollectionViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var wrapperView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        layer.cornerRadius = 10
        clipsToBounds = true
        
        
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
    
    func configure(weatherImage: UIImage, location: String) {
        self.backgroundImageView.image = self.getImageInFiles()
        self.weatherImageView.image = weatherImage
        self.locationLabel.text = location
    }

}
