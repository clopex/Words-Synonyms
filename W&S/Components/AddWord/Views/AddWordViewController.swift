//
//  AddWordViewController.swift
//  W&S
//
//  Created by Adis Mulabdic on 29.07.2021.
//

import UIKit

class AddWordViewController: UIViewController {
    
    @IBOutlet weak var addWordField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var wordLabel: UILabel!
    
    var viewModel: WordsViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.addOrEditWord()
    }
    
    private func setupView() {
        viewModel.delegate = self
        addGradientBg()
        addWordField.delegate = self
        
        switch viewModel.screenMode {
            case .add:
                addWordField.becomeFirstResponder()
                viewModel.synonyms = []
            case .edit:
                wordLabel.text = viewModel.getWordName()
                viewModel.setEditMode()
                collectionView.reloadData()
        }
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "SynonymCell", bundle: nil), forCellWithReuseIdentifier: SynonymCell.reuseIdentifier)
    }
    
    private func addSynonym(_ synonym: String?) {
        if let _ = synonym {
            viewModel.screenMode = .edit
        } else {
            viewModel.screenMode = .add
        }
        
        let alert = UIAlertController(title: viewModel.alertTitle(), message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            if let text = synonym {
                textField.text = text
            }
            textField.placeholder = Constants.synonym
        }
        alert.addAction(UIAlertAction(title: viewModel.buttonTitle(), style: .default, handler: { [weak alert] (_) in
            guard let alert = alert else {return}
            guard let textFields = alert.textFields else {return}
            guard let field = textFields.first else {return}
            guard let text = field.text else {return}
            if !text.isEmptyOrWhitespace() {
                if self.viewModel.screenMode == .edit {
                    self.viewModel.editSynonym(text)
                } else {
                    self.viewModel.addSynonym(text)
                }
                
                self.collectionView.reloadData()
            }
            
        }))
        alert.view.tintColor = .black
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addSynonym(_ sender: UIButton) {
        view.endEditing(true)
        guard let field = addWordField.text else {return}
        if !field.isEmptyOrWhitespace() {
            wordLabel.text = field
            viewModel.wordName = field
            addWordField.text = ""
        }
        guard let word = wordLabel.text else {return}
        if word.isEmptyOrWhitespace() {
            addWordField.layer.borderWidth = 1
            addWordField.layer.borderColor = UIColor.red.cgColor
            showAlertDialog(alertText: Constants.error, alertMessage: Constants.addWord)
            return
        }
        addSynonym(nil)
    }
    
    private func callSheetView(_ name: String) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: Constants.edit, style: .default , handler:{ (UIAlertAction) in
            self.addSynonym(name)
        }))
        
        alert.addAction(UIAlertAction(title: Constants.delete, style: .destructive , handler:{ (UIAlertAction)  in
            self.viewModel.checkSynonyms()
        }))
        
        alert.addAction(UIAlertAction(title: Constants.dismiss, style: .cancel, handler:{ (UIAlertAction) in
            self.viewModel.screenMode = .add
        }))
        
        
        self.present(alert, animated: true, completion: {
           
        })
    }
}

extension AddWordViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.synonyms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SynonymCell.reuseIdentifier, for: indexPath) as! SynonymCell
        let synonym = viewModel.synonyms[indexPath.row]
        cell.setup(synonym)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.screenMode = .edit
        let synonym = viewModel.synonyms[indexPath.row]
        viewModel.selectedIndex = indexPath.row
        callSheetView(synonym.name)
    }
}

extension AddWordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        wordLabel.text = textField.text
        viewModel.wordName = textField.text
        viewModel.editWord(textField.text)
        addWordField.text = ""
        addWordField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z].*", options: [])
            if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
                return false
            }
        }
        catch {
            print("some error")
        }
        return true
    }
}

extension AddWordViewController: AddWordDelegate {
    func deleteOne() {
        self.viewModel.deleteSynonym()
        self.collectionView.reloadData()
    }
    
    func deleteAll(_ synonyms: [String]) {
        let alert = UIAlertController(title: Constants.warning, message: Constants.warningMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: Constants.yes, style: .destructive, handler: { alert in
            self.viewModel.deleteAllLinked(synonyms)
            self.collectionView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: Constants.no, style: .default, handler: { alert in
            self.viewModel.deleteSynonym()
            self.collectionView.reloadData()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
