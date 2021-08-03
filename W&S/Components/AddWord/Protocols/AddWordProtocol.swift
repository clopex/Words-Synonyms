//
//  AddWordProtocol.swift
//  W&S
//
//  Created by Adis Mulabdic on 02.08.2021..
//

import Foundation

protocol AddWordDelegate: AnyObject {
    func deleteAll(_ synonyms: [String])
    func deleteOne()
}
