//
//  Parcer.swift
//  NewsApp
//
//  Created by Антон on 03.07.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import Foundation

class Parcer: NSObject {
    private var itemsOfNews: [ItemOfNews] = []
    private var categories: Set<String> = []
    private var currentElement = ""
    private var currentImage = ""
    private var currentTitle = ""
    private var currentDescription = ""
    private var currentCategory = "" {
        didSet {
            if currentCategory != "" {
                categories.insert(currentCategory)
            }
        }
    }
    private var currentPubData = ""
    
    //инициализируем парсер
    func initParcer(_ url: String) -> Parcer {
        parseNews(url: url)
        return self
    }
    
    func parseNews(url: String) {
        let parser = XMLParser(contentsOf: URL(string: url)!)!
        parser.delegate = self
        parser.parse()
    }
    
    func getNews() -> [ItemOfNews] {
        return itemsOfNews
    }
    
    func getCategories() -> Set<String> {
        return categories
    }
}

extension Parcer: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentPubData = ""
            currentCategory = ""
            currentDescription = ""
        } else if currentElement == "enclouser" {
            if let urlString = attributeDict["url"] {
                currentImage = urlString
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title": currentTitle += string
        case "pubDate": currentPubData += string
        case "category": currentCategory += string
        case "yandex:full-text": currentDescription += string
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let itemOfNews = ItemOfNews(title: currentTitle, pubDate: currentPubData, category: currentCategory, image: currentImage, description: currentDescription)
            itemsOfNews.append(itemOfNews)
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
