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
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageLeadingContstraint: NSLayoutConstraint!
    @IBOutlet weak var imageTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
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
    
    func configure(weatherImage: String, location: String) {
        let background = self.getImageInFiles()
        self.locationLabel.textColor = background != nil ? .white : .black
        self.backgroundImageView.image = self.getImageInFiles()
        self.weatherImageView.image = UIImage(named: weatherImage)
        self.locationLabel.text = location
    }
    
    func changeSize(type: ViewType) {
        self.imageHeightConstraint.constant = type.imageSize.height
        self.widthConstraint.constant = type.containerSize.width
        self.heightConstraint.constant = type.containerSize.height
        self.imageLeadingContstraint.constant = type.imageLeading
        self.imageTopConstraint.constant = type.imageTop
        self.locationLabel.font = UIFont(name: FontName.fontRoundedBold, size: type.labelFontSize)
        
        self.layoutIfNeeded()
        
        backgroundImageView.layer.cornerRadius = 22
        shadowView.dropShadow(cornerRadius: 22)
    }

}
