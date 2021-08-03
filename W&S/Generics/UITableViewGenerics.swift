//
//  UITableViewGenerics.swift
//  W&S
//
//  Created by Adis Mulabdic on 28.07.2021.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableView {
    
    func dequeueCell<T: UITableViewCell>(ofType type: T.Type) -> T     {
        let cellName = T.reuseIdentifier
        
        return dequeueReusableCell(withIdentifier: cellName) as! T
    }
    
    func registerCell<T: UITableViewCell>(ofType type: T.Type) {
        let cellName = T.reuseIdentifier //String(describing: T.self)
        
        if Bundle.main.path(forResource: cellName, ofType: "nib") != nil {
            let nib = UINib(nibName: cellName, bundle: Bundle.main)
            
            register(nib, forCellReuseIdentifier: cellName)
        } else {
            register(T.self, forCellReuseIdentifier: cellName)
        }
    }
}

protocol UICollectionViewRegisterable {
    static var cellIdentifier: String { get }
    static var cellNib: UINib { get }
}

extension UICollectionView {
    func register(type: UICollectionViewRegisterable.Type) {
        register(type.cellNib, forCellWithReuseIdentifier: type.cellIdentifier)
    }

    func dequeueCell<CellType: UICollectionViewRegisterable>(at indexPath: IndexPath) -> CellType {
        guard let cell = dequeueReusableCell(withReuseIdentifier: CellType.cellIdentifier, for: indexPath) as? CellType else {
            fatalError("UICollectionView should dequeue a cell of type \(CellType.self)")
        }
        return cell
    }
}
