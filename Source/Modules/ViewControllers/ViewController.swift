//
//  ViewController.swift
//  Babel skills test
//
//  Created by Nitanta Adhikari on 5/7/21.
//

import UIKit
import Combine

enum ViewType: CaseIterable {
    case small
    case medium
    case large
    
    var containerSize: CGSize {
        switch self {
        case .small: return CGSize(width: 155, height: 155)
        case .medium:  return CGSize(width: 330, height: 155)
        case .large:  return CGSize(width: 330, height: 345)
        }
    }
    
    var imageSize: CGSize {
        switch self {
        case .small: return CGSize(width: 67, height: 67)
        case .medium:  return CGSize(width: 82, height: 82)
        case .large:  return CGSize(width: 155, height: 155)
        }
    }
    
    var imageLeading: CGFloat {
        switch self {
        case .small: return self.containerSize.width / 2 - self.imageSize.width / 2
        case .medium: return 16
        case .large:  return self.containerSize.width / 2 - self.imageSize.width / 2
        }
    }
    
    var imageTop: CGFloat {
        switch self {
        case .small: return 16
        case .medium: return 16
        case .large:  return 48
        }
    }
    
    var labelFontSize: CGFloat {
        switch self {
        case .small: return 18
        case .medium: return 24
        case .large:  return 32
        }
    }
}

class ViewController: UIViewController {

    let viewModel = ViewModel(service: WeatherService())
    private var bag = Set<AnyCancellable>()

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func changeClicked(_ sender: Any) {
        self.showPickerActionSheet()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        viewModel.getLocationAndWeather()
    }
    
    func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "WidgetCollectionviewCell", bundle: nil), forCellWithReuseIdentifier: "WidgetCollectionviewCell")
        
        changeButton.layer.cornerRadius = 8
        changeButton.clipsToBounds = true
        
        pageControl.numberOfPages = ViewType.allCases.count
        pageControl.isHidden = true
    }
    
    func bind() {
        viewModel.error.sink { [weak self] (error) in
            guard let self = self else { return }
            if error != nil {
                self.showAlert(message: error ?? "", buttonAction: nil)
            }
        }.store(in: &bag)
        
        viewModel.isLoading.sink { [weak self] (loading) in
            guard let self = self else { return }
            if loading {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }.store(in: &bag)
        
        viewModel.datasource.sink { [weak self] (data) in
            guard let self = self else { return }
            if data != nil {
                self.collectionView.reloadData()
            }
        }.store(in: &bag)
        
        Timer.publish(every: TimeInterval(60), on: .main, in: .default).autoconnect().sink { [weak self] (_) in
            guard let self = self else { return }
            self.viewModel.getLocationAndWeather()
        }.store(in: &bag)
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.isLoading.value {
            return 0
        }
        pageControl.isHidden = false
        return ViewType.allCases.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WidgetCollectionviewCell", for: indexPath) as? WidgetCollectionviewCell else {
            return UICollectionViewCell()
        }
        let type = ViewType.allCases[indexPath.row]
        cell.changeSize(type: type)
        cell.configure(weatherImage: self.getWeatherIcon(), location: self.viewModel.datasource.value!.name )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width - 40, height: self.collectionView.frame.height)
    }
    
    func getWeatherIcon() -> String {
        guard let weather = self.viewModel.datasource.value!.weather.first else { return "" }
        let image = WeatherType(rawValue: weather.main)?.imageName
        return image ?? ""
    }
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    private func openImagePicker(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        imagePicker.sourceType = source
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let imagePicked = info[.originalImage] as? UIImage else { return }
        self.saveImageInFiles(image: imagePicked)
        self.collectionView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveImageInFiles(image: UIImage) {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.lotuslabs.weatherapp") else { return }
        let imageFileURL = containerURL.appendingPathComponent("widgetbackground.jpg")
        let imageData = image.jpegData(compressionQuality: 0.5)
        do {
            try imageData?.write(to: imageFileURL)
        } catch {
            debugPrint("Writing to files failed.", error.localizedDescription)
        }
    }

}


extension ViewController {
    func showAlert(title: String = "Weather Widget", message: String, buttonAction: (() -> ())?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OKAY", style: .default) { (_) in
            buttonAction?()
        }
        
        alertController.addAction(okButton)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showPickerActionSheet() {
        let alertController = UIAlertController(title: "Weather Widget", message: nil, preferredStyle: .actionSheet)
        let cameraButton = UIAlertAction(title: "Camera", style: .default) { [weak self] (_) in
            guard let self = self else { return }
            self.openImagePicker(source: .camera)
        }
        let photoButton = UIAlertAction(title: "Photos", style: .default) { [weak self] (_) in
            guard let self = self else { return }
            self.openImagePicker(source: .photoLibrary)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(cameraButton)
        alertController.addAction(photoButton)
        alertController.addAction(cancelButton)
        self.present(alertController, animated: true, completion: nil)
    }
}
