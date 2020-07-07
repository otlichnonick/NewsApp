//
//  FullNewViewController.swift
//  NewsApp
//
//  Created by Антон on 03.07.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit

class FullNewsViewController: UIViewController {
    
    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var titleNews: UILabel!
    @IBOutlet weak var descriptionNews: UILabel!
    
    var itemOfNews: ItemOfNews?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleNews.text = itemOfNews?.title
        self.descriptionNews.text = itemOfNews?.description
        
        if itemOfNews?.image != "" {
            getImage(urlToImage: itemOfNews!.image)
        }
    }
    
    // загрузка картинки в фоне
    func getImage(urlToImage: String) {
        DispatchQueue.global(qos: .userInteractive).async {
            let url = URL(string: urlToImage)
            let data = NSData(contentsOf: url! as URL)
            let image = UIImage(data: data! as Foundation.Data)
            DispatchQueue.main.async {
                self.imageNews.image = image
                UIView.animate(withDuration: 1, animations: {
                    self.imageNews.alpha = 1
                })
            }
        }
    }

}
