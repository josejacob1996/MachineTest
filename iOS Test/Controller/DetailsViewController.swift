//
//  DetailsViewController.swift
//  iOS Test
//
//  Created by Jose Jacob on 07/05/24.
//

import UIKit
import SafariServices

class DetailsViewController: UIViewController {
    var model:DataModel?
    
    
    @IBOutlet weak var shareOutlet: UIBarButtonItem!
    @IBOutlet weak var openBtnOutlet: UIButton!
    
    @IBOutlet weak var imageView: RemoteImageView!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var publishedOnLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let model else{
            self.showDismissAlert("Error", "Data is not available to display. Redirecting back...")
            return
        }
        self.imageView.LoadImage(model.thumbnail.getImageUrl(), cacheName: model.thumbnail.id) { ratio in
            self.imageHeight.constant = self.imageView.frame.width*ratio
            self.imageView.updateConstraints()
        }
        self.titleLabel.text = self.model?.title
        if let publishedOn = model.publishedAt, publishedOn.count>1{
            self.publishedOnLabel.text = publishedOn
            self.publishedOnLabel.isHidden=false
        }
        if let publishedBy = model.publishedBy, publishedBy.count>1{
            self.publisherLabel.text = publishedBy
            self.publisherLabel.isHidden=false
        }
        shareOutlet.isHidden = model.coverageURL.count == 0
        openBtnOutlet.isHidden = model.coverageURL.count == 0
    }
    
    @IBAction func shareAction(_ sender: UIBarButtonItem) {
        let activityViewController = UIActivityViewController(activityItems: [ model?.coverageURL ?? ""], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = []
        self.present(activityViewController, animated: true, completion: nil)
    }
    @IBAction func openButtonAction(_ sender: UIButton) {
        let safariVC = SFSafariViewController(url: URL(string: model?.coverageURL ?? "")!)
        self.present(safariVC, animated: true)
        
    }
}
