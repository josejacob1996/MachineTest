//
//  GridViewController.swift
//  iOS Test
//
//  Created by Jose Jacob on 07/05/24.
//

import UIKit

class GridViewController: UIViewController {
    var gridData:[DataModel] = []
    
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var gridCollection: UICollectionView!
    let refreshControl = UIRefreshControl()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gridCollection.delegate = self
        gridCollection.dataSource = self
        refreshControl.tintColor = UIColor.label
        refreshControl.addTarget(self, action: #selector(loadApi), for: .valueChanged)
        gridCollection.addSubview(refreshControl)
        gridCollection.alwaysBounceVertical = true
        DispatchQueue.global().async {
            self.loadApi()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func loadApi(){
        ServiceManager.shared.fetch(endPoint: EndPoint("content/misc/media-coverages?limit=390", ApiMethod.GET, AcceptHeader.json), type: [DataModel].self) { result in
            self.loaderView.isHidden = true
            self.refreshControl.endRefreshing()
            switch result {
            case .success(let success):
                if (success.isEmpty){
                    self.showOKAlert("No data", "No is available for dispaying.")
                    self.gridCollection.isHidden = true
                }else{
                    self.gridData = success
                    self.gridCollection.isHidden = false
                    self.gridCollection.reloadData()
                }
            case .failure(let failure):
                self.showOKAlert("Data failure", failure.localizedDescription)
            }
        }

    }
}
extension GridViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "kGridImageCell", for: indexPath) as! GridImageCell
        item.initItem(with: gridData[indexPath.row])
        return item
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (collectionView.cellForItem(at: indexPath) as? GridImageCell)?.imageView?.stopLoading()
    }
}
extension GridViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.frame.width
        let itemWidth = (collectionWidth-40)/3
        return CGSize(width: itemWidth, height: itemWidth)
    }
}


extension GridViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC = storyboard?.instantiateViewController(withIdentifier: "kDetailsViewController") as! DetailsViewController
        detailsVC.model = gridData[indexPath.row]
        self.present(detailsVC, animated: true)
                                
    }
}
