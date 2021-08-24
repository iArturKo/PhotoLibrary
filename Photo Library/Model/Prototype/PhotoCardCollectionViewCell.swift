//
//  PhotoCardCollectionViewCell.swift
//  Photo Library
//
//  Created by Артур Кононович on 15.07.21.
//

import UIKit

class PhotoCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var isFavoriteButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    
    private var photoCard = PhotoCard(imageName: "")
    
    func configure(with object: PhotoCard) {
        self.isFavoriteButton.isSelected = object.isFavorite
        self.photoImageView.image = Manager.shared.loadImage(fileName: object.imageName)
        self.commentTextField.placeholder = "Comment...".localized
        self.commentTextField.text = object.comment
        self.photoCard = object
        self.commentTextField.delegate = self
    }
    
    @IBAction func isFavoriteButtonPressed(_ sender: UIButton) {
        self.photoCard.isFavorite = !self.photoCard.isFavorite
        Manager.shared.savePhotoCardArray()
        self.isFavoriteButton.isSelected = self.photoCard.isFavorite
    }
    
    func saveComment() {
        if let text = self.commentTextField.text {
            self.photoCard.comment = text
        }
        Manager.shared.savePhotoCardArray()
    }
}

extension PhotoCardCollectionViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        self.saveComment()
        return true
    }
}
