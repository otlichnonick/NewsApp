//
//  Data.swift
//  NewsApp
//
//  Created by Антон on 03.07.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import Foundation

class Data {
    static var itemOfNews: [ItemOfNews]?
    static var filteredItemOfNews: [ItemOfNews]?
    static var categories: Set<String>?
    static var filtered = "Все новости"
    // проперти для проверки не началась ли уже загрузка
    static var isDownloading = false
    // метод для загрузки в фоновом режиме
    static func downloadData(completion: @escaping () -> ()) {
        
        guard isDownloading == false else {
            return
        }
        isDownloading = true
        
        DispatchQueue.global(qos: .userInteractive).async {
            let parser = Parcer().initParcer("https://www.vesti.ru/vesti.rss")
            
            self.itemOfNews = parser.getNews()
            self.categories = parser.getCategories()
            
            if self.filtered == "Все новости" {
                self.filteredItemOfNews = self.itemOfNews
            } else {
                self.filteredItemOfNews = self.itemOfNews?.filter() {
                    $0.category == self.filtered
                }
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
