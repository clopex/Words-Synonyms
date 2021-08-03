//
//  ArrayExt.swift
//  W&S
//
//  Created by Adis Mulabdic on 02.08.2021..
//

import Foundation

extension Array where Element == Synonym {
    
    func isSynonymAvailable(for text: String?) -> [String] {
        var tempArray: [String] = []
        for item in self {
            if item.name == text {
                tempArray.append(item.id.uuidString)
            }
        }
        return tempArray
    }
}
