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
    
    // настройка tableView
    func setupTableView() {
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handler), for: .valueChanged)
    }
    
    @objc func handler() {
        if tableView.isDragging {
            refreshData()
        }
    }
    
    // обновляем данные
    func refreshData() {
        Data.downloadData(completion: { [unowned self] in
            self.reloadTableView()
        })
        let deadLine = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadLine, execute: {
            self.tableView.refreshControl?.endRefreshing()
        })
    }
    
    // анимируем обновление данных
    func reloadTableView() {
        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        Data.isDownloading = false
    }
    
    // создаем действие для кнопки "Фильтр"
    @IBAction func filtered(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Раздел: \n\(Data.filtered)", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Все новости", style: .default, handler: { (action) in
            Data.filteredItemOfNews = Data.itemOfNews
            Data.filtered = "Все новости"
            self.tableView.reloadData()
        })
        alert.addAction(action)
        
        for category in Data.categories! {
            let action = UIAlertAction(title: category, style: .default, handler: { (action) in
                Data.filteredItemOfNews = Data.itemOfNews?.filter() {
                    $0.category == category
                }
                Data.filtered = category
                self.tableView.reloadData()
            })
            alert.addAction(action)
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    // указываем количество строк
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let filteredNews = Data.filteredItemOfNews else {
            return 0
        }
        return filteredNews.count
    }
    
    // создаем строку
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
        
        if let itemOfNews = Data.filteredItemOfNews?[indexPath.row] {
            cell.setupCell(itemOfNews: itemOfNews)
        }
        return cell
    }
    
    // переходим на 2й экран при нажатии на строку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FullNewsViewController") as! FullNewsViewController
        vc.itemOfNews = Data.filteredItemOfNews?[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
