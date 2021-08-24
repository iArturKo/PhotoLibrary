//
//  MainViewController.swift
//  Photo Library
//
//  Created by Артур Кононович on 6.05.21.
//

import UIKit

class MainViewController: UIViewController {
     
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    @IBAction func addPhotoButtonPressed(_ sender: UIButton) {
        self.showPickerAlert()
    }
    
    @IBAction func photoGalleryButtonPressed(_ sender: UIButton) {
        if !Manager.shared.photoCardArray.isEmpty {
            self.showPhotoGallery(indexPath: IndexPath(row: 0, section: 0))
        }
    }
    
    func showPickerAlert() {
        let alert = UIAlertController(title: "Choose image source".localized, message: nil, preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "Photos".localized, style: .default) { (_) in
            self.showImagePicker(sourceType: .photoLibrary)
        }
        let camera = UIAlertAction(title: "Camera".localized, style: .default) { (_) in
            self.showImagePicker(sourceType: .camera)
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        imagePicker.modalPresentationStyle = .overCurrentContext
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func showPhotoGallery(indexPath: IndexPath) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "SliderViewController") as? SliderViewController else {
            return
        }
        controller.indexPath = indexPath
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (self.collectionView.frame.width - 5) / 2
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Manager.shared.photoCardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: Manager.shared.photoCardArray[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        return self.showPhotoGallery(indexPath: indexPath)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            Manager.shared.addPhotoCard(image: image)
            self.collectionView.reloadData()
            self.showPhotoGallery(indexPath: IndexPath(row: Manager.shared.photoCardArray.count - 1, section: 0))
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            Manager.shared.addPhotoCard(image: image)
            self.collectionView.reloadData()
            self.showPhotoGallery(indexPath: IndexPath(row: Manager.shared.photoCardArray.count - 1, section: 0))
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

