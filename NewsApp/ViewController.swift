//
//  ViewController.swift
//  NewsApp
//
//  Created by Антон on 03.07.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var itenOfNews = [ItemOfNews]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Data.downloadData() { [unowned self] in
            self.reloadTableView()
        }
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
    }
    
    func reloadTableView() {
        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        Data.isDownloading = false
    }
    
    
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let filteredNews = Data.filteredItemOfNews else {
            tableView.separatorColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
            return 0
        }
        tableView.separatorColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return filteredNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
        
        if let itemOfNews = Data.filteredItemOfNews?[indexPath.row] {
            cell.setupCell(itemOfNews: itemOfNews)
        }
        return cell
    }
    
}
