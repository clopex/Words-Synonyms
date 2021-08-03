//
//  Word.swift
//  W&S
//
//  Created by Adis Mulabdic on 29.07.2021.
//

import Foundation

struct Word {
    var name: String
    var synonyms: [Synonym]
    
    init(name: String, synonyms: [Synonym]) {
        self.name = name
        self.synonyms = synonyms
    }
    
    static func getDummyData() -> [Word] {
        var words = [Word]()
        words.append(Word(name: "phone", synonyms: [
                            Synonym(name: "sound"),
                            Synonym(name: "speech sound"),
                            Synonym(name: "telephone"),
                            Synonym(name: "earphone")
        ]))
        words.append(Word(name: "house", synonyms: [
                            Synonym(name: "domiciliate"),
                            Synonym(name: "family"),
                            Synonym(name: "home"),
                            Synonym(name: "household")
        ]))
        words.append(Word(name: "travel", synonyms: [
                            Synonym(name: "move"),
                            Synonym(name: "journey"),
                            Synonym(name: "trip"),
                            Synonym(name: "move around")
        ]))
        
        return words
    }
}

struct Synonym {
    var id: UUID
    var name: String
    
    init(name: String) {
        self.name = name
        self.id = UUID()
    }
}

