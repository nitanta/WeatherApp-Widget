//
//  ViewController.swift
//  Babel skills test
//
//  Created by Nitanta Adhikari on 5/7/21.
//

import UIKit
import Combine

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
    @IBAction func pageControlChange(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        viewModel.getLocationAndWeather()
    }
    
    
    /// Handling UI setup and cell registration
    func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "WidgetCollectionviewCell", bundle: nil), forCellWithReuseIdentifier: "WidgetCollectionviewCell")
        
        changeButton.layer.cornerRadius = 8
        changeButton.clipsToBounds = true
        
        pageControl.numberOfPages = ViewType.allCases.count
    }
    
    /// Handles showing and hiding views
    /// - Parameters:
    ///   - hide: true/false - hiding or unding a array of views
    ///   - views: lists of views to hide
    func hideShowView(hide: Bool, views: [UIView]) {
        views.forEach {
            $0.isHidden = hide
        }
    }
    
    /// Bind viewmode with the controller
    func bind() {
        viewModel.error.sink { [weak self] (error) in
            guard let self = self else { return }
            if error != nil {
                self.showAlert(message: error ?? "", buttonAction: nil)
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
            debugPrint("Refreshing weather data")
            self.viewModel.getLocationAndWeather()
        }.store(in: &bag)
    }
    
}

// MARK: - Collection view handlers
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ViewType.allCases.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WidgetCollectionviewCell", for: indexPath) as? WidgetCollectionviewCell else {
            return UICollectionViewCell()
        }
        let type = ViewType.allCases[indexPath.row]
        cell.changeSize(type: type)
        cell.configure(weatherImage: self.getWeatherIcon(), location: self.getLocationName())
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    
    /// Get name of the icon from the response
    /// - Returns: icon name
    func getWeatherIcon() -> String {
        if viewModel.isLoading.value {
            return ""
        }
        guard let weather = self.viewModel.datasource.value!.weather.first else { return "" }
        let image = WeatherType(raw: weather.main, desc: weather.weatherDescription).imageName
        return image
    }
    
    /// Get the location for which the weather is reached.
    /// - Returns: location
    func getLocationName() -> String {
        if viewModel.isLoading.value {
            return "Loading ..."
        }
        return self.viewModel.datasource.value!.name + ", " + self.viewModel.datasource.value!.sys.country
    }
}

// MARK: - Image picker
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

// MARK: - Pickers and alerts
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
