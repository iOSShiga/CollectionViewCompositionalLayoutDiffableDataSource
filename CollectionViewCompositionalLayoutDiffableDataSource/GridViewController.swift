//
//  ViewController.swift
//  CollectionViewCompositionalLayoutDiffableDataSource
//
//  Created by shiga on 15/02/20.
//  Copyright © 2020 shiga. All rights reserved.
//

import UIKit

struct Animal: Hashable  {
    let name: String
}

let animals = [
Animal(name: "lion"),
Animal(name: "tiger"),
Animal(name: "crocodile"),
Animal(name: "snake"),
Animal(name: "fox"),
Animal(name: "cat"),
Animal(name: "deer")
]

class GridViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var collectionView: UICollectionView! = nil
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Animal>! = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureHighierarchy()
        configureDataSource()
    }

}


extension GridViewController {
    
    func createLayout() -> UICollectionViewLayout  {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200.0))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func configureHighierarchy()  {
        collectionView  = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .black
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(GridCell.self, forCellWithReuseIdentifier: GridCell.reuseIdentifier)
        view.addSubview(collectionView)
    }
    
}


extension GridViewController {
    
    func configureDataSource()  {
        dataSource = UICollectionViewDiffableDataSource<Section, Animal>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, animal) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCell.reuseIdentifier, for: indexPath) as? GridCell else {fatalError("could not create cell")}
            cell.imageView.image = UIImage(named: animal.name)
            return cell
        })
        
        createSnapShot()
    }
    
    func createSnapShot()  {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Animal>()
        snapShot.appendSections([.main])
        snapShot.appendItems(animals)
        
        dataSource.apply(snapShot, animatingDifferences: true)
    }
}
