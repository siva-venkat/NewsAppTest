//
//  ViewController.swift
//  NewsAppTest
//
//  Created by Sivaranjani Venkatesh on 22/1/22.
//

import UIKit
import SafariServices

class ViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    var user: User?
    
    private let tableView:UITableView = {
        let table = UITableView()
        table.backgroundColor = .black
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    private var articles = [Article]()
    private var viewModel = [NewsTableViewCellViewModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        view.backgroundColor = .black
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        //Add pull to Refresh
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        APIConnection.shared.getTopStories { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModel = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title ?? "" ,
                                               subtitle: $0.description ?? "No description",
                                               imageURL: URL(string: $0.urlToImage ?? ""))
                    
                
                    
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
              
            case .failure(let error):
                print(error)
            }
        }
    
    }
    @objc private func didPullToRefresh(){
        DispatchQueue.main.async {
            print("start to pull refresh")
            self.tableView.refreshControl?.endRefreshing()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard  let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {
          
           fatalError()
        }
        cell.contentView.backgroundColor = .systemBackground
        cell.configure(with: viewModel[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        guard let url = URL(string: article.url ?? "") else {
            return
        }
        let vc = SFSafariViewController(url:url)
        present(vc, animated:true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

