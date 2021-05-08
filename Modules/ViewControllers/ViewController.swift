//
//  ViewController.swift
//  Babel skills test
//
//  Created by Nitanta Adhikari on 5/7/21.
//

import UIKit

enum ViewType: CaseIterable {
    case small
    case medium
    case large
}

class ViewController: UIViewController {

    let viewModel = ViewModel(service: WeatherService())

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func changeClicked(_ sender: Any) {
        self.showPickerActionSheet()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.getWeatherData(finished: nil)
    }
    
    func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "WidgetCollectionviewCell", bundle: nil), forCellWithReuseIdentifier: "WidgetCollectionviewCell")
        
        changeButton.layer.cornerRadius = 8
        changeButton.clipsToBounds = true
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ViewType.allCases.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WidgetCollectionviewCell", for: indexPath) as? WidgetCollectionviewCell else {
            return UICollectionViewCell()
        }
        cell.configure(weatherImage: #imageLiteral(resourceName: "ic-sunny"), location: "Nepal")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width - 40, height: self.collectionView.frame.height)
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
