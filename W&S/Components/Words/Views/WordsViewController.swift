//
//  ViewController.swift
//  W&S
//
//  Created by Adis Mulabdic on 27.07.2021.
//

import UIKit

class WordsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noWordsView: UIView!
    
    var viewModel: WordsViewModel
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = Constants.searchWord
        sc.definesPresentationContext = true
        return sc
    }()
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        viewModel = WordsViewModel.build()
        viewModel.words = Word.getDummyData()
        super.init(coder: coder)
    }
    
    private func setupView() {
        addGradientBg()
    }
    
    private func setupTableView() {
        tableView.registerCell(ofType: WordCell.self)
        let bgView = UIView()
        bgView.backgroundColor = .clear
        tableView.backgroundView = bgView
        tableView.estimatedRowHeight = 1000.0
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupNavigationBar() {
        navigationItem.searchController = searchController
    }
    
    private func showEmptyStatus(_ array: [Word]) {
        if array.isEmpty {
            noWordsView.showViewWithSubviews()
        } else {
            noWordsView.hideViewWithSubviews()
        }
    }
    
    @IBAction func addWordTap(_ sender: UIBarButtonItem) {
        viewModel.resetState()
        viewModel.screenMode = .add
        callAddWordScreen()
    }
    
    private func callAddWordScreen() {
        let addWordVC: AddWordViewController = UIStoryboard.storyboard(.AddWord).instantiateViewController()
        addWordVC.viewModel = viewModel
        navigationController?.pushViewController(addWordVC, animated: true)
    }
}

extension WordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            showEmptyStatus(viewModel.filteredWords)
            return viewModel.filteredWords.count
        } else {
            showEmptyStatus(viewModel.words)
            return viewModel.words.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: WordCell.self)
        let word: Word
        if isFiltering {
            word = viewModel.filteredWords[indexPath.row]
        } else {
            word = viewModel.words[indexPath.row]
        }
        cell.setup(word)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        viewModel.selectedWordIndex = index
        let word = viewModel.words[index]
        viewModel.selectedWord = word
        viewModel.screenMode = .edit
        callAddWordScreen()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if isFiltering {
                viewModel.filteredWords.remove(at: indexPath.row)
            } else {
                viewModel.words.remove(at: indexPath.row)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension WordsViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if !searchController.isActive {
            tableView.reloadData()
        }
        guard let searchText = searchController.searchBar.text else {return}
        if searchText.count >= 3 {
            viewModel.filteredWords = viewModel.words.filter { word in
                return (word.name.lowercased().contains(searchText.lowercased()) ||
                            word.synonyms.contains {$0.name.contains(searchText.lowercased())}
                )
            }
            tableView.reloadData()
        } else {
            tableView.reloadData()
        }
    }
}
