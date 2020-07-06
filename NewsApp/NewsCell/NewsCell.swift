//
//  NewsCell.swift
//  NewsApp
//
//  Created by Антон on 03.07.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDate: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(itemOfNews: ItemOfNews) {
        self.newsTitle.text = itemOfNews.title
        self.newsDate.text = itemOfNews.pubDate
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
