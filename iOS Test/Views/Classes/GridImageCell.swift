//
//  GridImageCell.swift
//  iOS Test
//
//  Created by Jose Jacob on 07/05/24.
//

import UIKit

class GridImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: RemoteImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    func initItem(with model:DataModel){
        self.titleLabel.text = model.title
        self.imageView?.LoadImage(model.thumbnail.getImageUrl(), cacheName: model.thumbnail.id)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.stopLoading()
        self.imageView.image = nil
        self.titleLabel.text = ""
    }

}
