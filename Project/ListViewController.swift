//
//  ListViewController.swift
//  Project
//
//  Created by Ростислав Нурдинов on 07.02.19.
//  Copyright © 2019 Ростислав Нурдинов. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.backgroundColor = Colors.backgroudStartColor
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return NetworkManager.shared.itemListArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as? ListCollectionViewCell {
            itemCell.layer.cornerRadius = 15
            itemCell.layer.borderWidth = 2
            itemCell.layer.borderColor = UIColor.black.cgColor
            itemCell.clipsToBounds = true
            itemCell.listMenu = NetworkManager.shared.itemListArray[indexPath.row]
            
            return itemCell
        }
        return UICollectionViewCell()
    }
}
