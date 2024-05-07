//
//  extension+UIImageView.swift
//  iOS Test
//
//  Created by Jose Jacob on 07/05/24.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()
    private let memoryCache = NSCache<NSString, UIImage>()
    private let diskCacheDirectory: URL
    
    private init() {
        diskCacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("ImageCache")
        try? FileManager.default.createDirectory(at: diskCacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }
    
    func getImage(forKey key: String) -> UIImage? {
        if let image = memoryCache.object(forKey: key as NSString) {
            return image
        }
        
        let fileURL = diskCacheDirectory.appendingPathComponent(key)
        if let data = try? Data(contentsOf: fileURL),
           let image = UIImage(data: data) {
            memoryCache.setObject(image, forKey: key as NSString)
            return image
        }
        return nil
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        memoryCache.setObject(image, forKey: key as NSString)
        let fileURL = diskCacheDirectory.appendingPathComponent(key)
        if let data = image.pngData() {
            try? data.write(to: fileURL)
        }
    }
}

class RemoteImageView: UIImageView{
    enum ImageType{
        case image;
        
        func defaultImage() -> UIImage{
            switch self{
            case .image :
                return UIImage(named: "placeholder")!
            }
        }
    }
    
    var dataTask:URLSessionDataTask?
    
    func LoadImage( _ urlString:String, cacheName:String, type:ImageType = .image, ratio: ((Double)->Void)? = nil){
        if let savedImage = ImageCache.shared.getImage(forKey: cacheName){
            print("imageFromCache", cacheName as NSString)
            ratio?(savedImage.size.height/savedImage.size.width)
            self.setImage(savedImage)
            return
        }
        let indicator = UIActivityIndicatorView()
        DispatchQueue(label: "imageFetcher").async{
            self.addLoader(indicator)
            if urlString.count == 0, urlString != "<null>"{
                self.removeLoader(indicator)
                self.setImage(type.defaultImage())
                return
            }
            
            guard let encodedStr = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encodedStr) else{
                self.removeLoader(indicator)
                self.setImage(type.defaultImage())
                return
            }

            debugPrint("loading new image from ", url.absoluteString)
            self.dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                self.removeLoader(indicator)
                if let data = data, let image = UIImage(data: data) {
                    ImageCache.shared.setImage(image, forKey: cacheName)
                    ratio?(image.size.height/image.size.width)
                    print("imagesave to Cache", url.absoluteString, cacheName as NSString)
                    self.setImage(image)
                } else {
                    self.setImage(type.defaultImage())
                    return
                }
            }
            self.dataTask?.resume()
        }
    }
    func stopLoading(){
        self.dataTask?.cancel()
    }
    
    private func setImage(_ image: UIImage){
        DispatchQueue.main.async {
            self.image = image
        }
    }
    private func addLoader(_ indicator: UIActivityIndicatorView){
        DispatchQueue.main.async {
            indicator.color = .label
            indicator.startAnimating()
            indicator.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
            self.addSubview(indicator)
        }
    }
    
    private func removeLoader(_ indicator: UIActivityIndicatorView){
        DispatchQueue.main.async {
            indicator.removeFromSuperview()
        }
    }
}
