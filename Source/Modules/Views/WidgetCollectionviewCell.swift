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
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupUI() {
        backgroundImageView.layer.cornerRadius = 22
        shadowView.addShadow(with: 22)
    }
    
    /// Get the image saved in the app group
    /// Image is saved in app group so that it can be accessed by both the app and the widget
    /// - Returns: Image saved in the container
    func getImageInFiles() -> UIImage? {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Global.containerName) else { return nil }
        let imageFileURL = containerURL.appendingPathComponent(Global.backgroundImageName)
        do {
            let data = try Data(contentsOf: imageFileURL)
            return UIImage(data: data)
        } catch {
            debugPrint("Reading to files failed.", error.localizedDescription)
            return nil
        }
    }
    
    /// Populates the cell with the data
    /// - Parameters:
    ///   - weatherImage: Icon for the current weather
    ///   - location: Location for the user
    func configure(weatherImage: String, location: String) {
        let background = self.getImageInFiles()
        self.locationLabel.textColor = background != nil ? .white : .black
        self.backgroundImageView.image = self.getImageInFiles()
        self.weatherImageView.image = UIImage(named: weatherImage)
        self.locationLabel.text = location
    }
    
    /// Changes the view according to the view type
    /// - Parameter type: View type eg: small, medium, large
    func changeSize(type: ViewType) {
        self.imageHeightConstraint.constant = type.imageSize.height
        self.widthConstraint.constant = type.containerSize.width
        self.heightConstraint.constant = type.containerSize.height
        self.imageLeadingContstraint.constant = type.imageLeading
        self.imageTopConstraint.constant = type.imageTop
        self.locationLabel.font = UIFont(name: FontName.fontRoundedBold, size: type.labelFontSize)
        
        self.setNeedsLayout()
    }

}
