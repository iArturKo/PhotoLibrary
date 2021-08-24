//
//  CollectionViewCell.swift
//  Photo Library
//
//  Created by Артур Кононович on 3.06.21.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var isFavoriteImageVIew: UIImageView!
    
    func configure(with object: PhotoCard) {
        self.imageView.image = Manager.shared.loadImage(fileName: object.imageName)
        self.isFavoriteImageVIew.isHidden = !object.isFavorite
    }
}
