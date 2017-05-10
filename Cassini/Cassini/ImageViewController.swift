//
//  ImageViewController.swift
//  Cassini
//
//  Created by Youmeiyi Pan on 4/26/17.
//  Copyright © 2017 Youmeiyi Pan. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    // MARK: Model
    var imageURL: URL? {
        didSet {
            image = nil
            if view.window != nil { //if not in screen
                  fetchImage()      // then fetch the image
            }
          
        }
    }
    @IBOutlet weak var spinner: UIActivityIndicatorView!
  
    
    // MARK: private Implementation
    private func fetchImage() {
        if let url = imageURL {
            // this next line of code can throw an erro
            // and it alsowill block the UI entirely while access the network
            // we really should be doing it in a separeate thread
            spinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                
                if let imageData = urlContents, url == self?.imageURL {
                    DispatchQueue.main.async {
                        self?.image = UIImage(data: imageData)
                    
                    }
                    
                }
                
            }
        }
    }
    
    
    // MARK: View Controller Lifecycle
    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        imageURL = DemoURL.stanford  // for testing only
//    }
//    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {  // we're about to appear on screen so, if needed,
            fetchImage()  // fetch image
        }
        
    }
    
    // MARK: User Interface
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
            
            //most important thing to set in UIScrollview is contentSize
            scrollView.contentSize = imageView.frame.size
            scrollView.addSubview(imageView)
        }
    }
    
    
    
    
    fileprivate var imageView = UIImageView()
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
    }

}

extension ImageViewController : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
