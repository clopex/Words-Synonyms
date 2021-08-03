//
//  WordsViewModel.swift
//  W&S
//
//  Created by Adis Mulabdic on 29.07.2021..
//

import Foundation

class WordsViewModel {
    
    var words: [Word] = []
    var filteredWords: [Word] = []
    var synonyms: [Synonym] = []
    var selectedWord: Word?
    var selectedIndex: Int?
    var selectedWordIndex: Int?
    var wordName: String?
    
    var screenMode: Type = .add
    weak var delegate: AddWordDelegate?
    
    static func build() -> WordsViewModel {
        return WordsViewModel()
    }
    
    func addWord() {
        if let name = wordName {
            let word = Word(name: name, synonyms: synonyms)
            words.append(word)
        }
    }
    
    func addOrEditWord() {
        if let _ = selectedWord {
            editWord(wordName)
        } else {
            addWord()
        }
    }
    
    func resetState() {
        selectedWord = nil
        selectedIndex = nil
        selectedWordIndex = nil
        wordName = nil
        synonyms.removeAll()
    }
    
    func addSynonym(_ synonym: String) {
        let synonym = Synonym(name: synonym)
        synonyms.append(synonym)
        updateWord()
    }
    
    func editSynonym(_ synonym: String) {
        guard let index = selectedIndex else {return}
        synonyms[index].name = synonym
        selectedWord?.synonyms = synonyms
        updateWord()
    }
    
    func editWord(_ name: String?) {
        if let text = name {
            if !text.isEmptyOrWhitespace() {
                wordName = text
                updateWord()
            }
        }
    }
    
    func getSelectedWord() -> Word {
        if let word = selectedWord {
            return word
        }
        return Word(name: "", synonyms: [])
    }
    
    private func getSelectedSynonyms() -> [Synonym] {
        let word = getSelectedWord()
        return word.synonyms
    }
    
    func getWordName() -> String {
        let word = getSelectedWord()
        wordName = word.name
        return word.name
    }
    
    func setEditMode() {
        synonyms = getSelectedSynonyms()
    }
    
    func checkSynonyms() {
        guard let index = selectedIndex else {return}
        let name = synonyms[index].name
        var tempArray: [String] = []
        for item in words {
            tempArray.append(contentsOf: item.synonyms.isSynonymAvailable(for: name))
        }
        if tempArray.count > 1 {
            delegate?.deleteAll(tempArray)
        } else {
            delegate?.deleteOne()
        }
    }
    
    func deleteSynonym() {
        guard let index = selectedIndex else {return}
        synonyms.remove(at: index)
        selectedWord?.synonyms = synonyms
        updateWord()
    }
    
    func deleteAllLinked(_ synonyms: [String]) {
        for synonym in synonyms {
            for (x, word) in words.enumerated() {
                var wordsSynonyms = word.synonyms
                wordsSynonyms = wordsSynonyms.filter{$0.id.uuidString != synonym}
                if let index = selectedIndex {
                    if index == x {
                        self.synonyms = wordsSynonyms
                    }
                }
                words[x].synonyms = wordsSynonyms
            }
        }
    }
    
    func alertTitle() -> String {
        if screenMode == .edit {
            return Constants.editSynonym
        } else {
            return Constants.addSynonym
        }
    }
    
    func buttonTitle() -> String {
        if screenMode == .edit {
            return Constants.edit
        } else {
            return Constants.add
        }
    }
    
    private func updateWord() {
        if var newWord = selectedWord {
            if let name = wordName {
                newWord.name = name
            }
            guard let index = selectedWordIndex else {return}
            words[index] = newWord
            words[index].synonyms = synonyms
        }
    }
}
