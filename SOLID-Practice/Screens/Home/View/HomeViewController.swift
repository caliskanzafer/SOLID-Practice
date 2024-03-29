//
//  HomeViewController.swift
//  SOLID-Practice
//
//  Created by Zafer Çalışkan on 24.02.2024.
//

import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func reloadTableView()
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        viewModel.delegate = self
        reloadAllData()
//        viewModel.deleteAllJokes()
    }
    
}

private extension HomeViewController {
    func configureTableView() {
        tableView.register(cell: FavoriteJokeTableViewCell.self)
        tableView.register(cell: SimpleJokeTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func reloadAllData() {
        
        viewModel.getRemoteJoke()
        viewModel.getFavoriteJoke()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            switch viewModel.jokes[safe: 1] {
            case .favorite(let jokes):
                return jokes?.count ?? 0
            default:
                return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModel.jokes[indexPath.section]
        
        switch cellType {
        case .remote(let joke):
            let cell = tableView.dequeueReusableCell(withIdentifier: SimpleJokeTableViewCell.identifier) as! SimpleJokeTableViewCell
            cell.delegate = self
            cell.joke = joke
            return cell
        case .favorite(let jokes):
            let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteJokeTableViewCell.identifier) as! FavoriteJokeTableViewCell
            cell.delegate = self
            let joke = jokes?[safe: indexPath.row]
            cell.joke = joke
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch viewModel.jokes[safe: indexPath.section] {
        case .remote(let joke):
            if let joke {
                viewModel.saveFavoriteJoke(item: joke)
            }
        default:
            print("")
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Şaka"
        }else if section == 1 {
            return "Favoriler"
        }else {
            return nil
        }
    }
}

extension HomeViewController: HomeViewControllerDelegate {
    
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension HomeViewController: HomeCellDelegate {
    func getJoke(id: String) -> JokeModel? {
        return viewModel.getJoke(id: id)
    }
    
    func saveJoke(item: JokeModel) {
        viewModel.saveFavoriteJoke(item: item)
    }
    
    func deleteJoke(item: JokeModel) {
        viewModel.deleteJoke(item: item)
    }
    
    func updateTableView() {
        viewModel.getFavoriteJoke()
    }
    
    func updateJoke() {
        viewModel.getRemoteJoke()
    }
}
