//
//  HomeViewController.swift
//  AR Education
//
//  Created by Howard Wang on 3/10/18.
//  Copyright © 2018 Mango Apps. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var puzzleButton: UIButton!
    @IBOutlet weak var duelButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        puzzleButton.layer.cornerRadius = 10
        
        duelButton.layer.cornerRadius = 10
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func puzzleButtonTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: Constants.Segue.toPuzzle, sender: nil)
    }
    

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
