//
//  LevelsViewController.swift
//  AR Education
//
//  Created by Howard Wang on 3/10/18.
//  Copyright © 2018 Mango Apps. All rights reserved.
//

import UIKit

class LevelsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let cellReuseIdentifier = "LevelSelectCollectionViewCell"
    let levels = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(LevelSelectCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        //collectionView.delegate = self
        //collectionView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levels
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! LevelSelectCollectionViewCell
        
        cell.backgroundColor = UIColor(color: UIColor.Color.med)
        
        let cellButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        cell.button = cellButton
        print(cell.button)
        let title = "/(indexPath.item)"
        let state = UIControlState.normal
        cell.button.setTitle(title, for: state)
        //let color = UIColor(color: UIColor.Color.med)
        //cell.button.setTitleColor(color, for: <#T##UIControlState#>)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        self.performSegue(withIdentifier: Constants.Segue.toAR, sender: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
