//
//  SearchController.swift
//  Collect
//
//  Created by Patrick Ortell on 1/22/21.
//

import UIKit


private let reuseIdentifier = "UserCell"

class SearchController: UITableViewController {
    private var users = [User] ()
    private var filterUsers = [User] ()
    private let searchController = UISearchController(searchResultsController: nil)
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
     override func viewDidLoad() {
        super.viewDidLoad()
        configureSeachController()
        configureTableView()
        fetchUsers()
    }

    func fetchUsers() {
        UserService.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
    //MARK: --Helpers
    
    func configureTableView(){
        view.backgroundColor = .white
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 64
    }
    
    func configureSeachController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for your cliqe'"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
}

//MARK: UI table view src
extension SearchController {
    
    override func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filterUsers.count :  users.count
    }
    override func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
    UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        let user = inSearchMode ? filterUsers[indexPath.row] : users[indexPath.row]
        cell.viewModel = UserCellViewModel(user:user)
        return cell
        
        }
    
}
extension SearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filterUsers[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filterUsers = users.filter({
          $0.username.contains(searchText) ||
            $0.fullname.lowercased().contains(searchText)
        })
        self.tableView.reloadData()
    }
}
