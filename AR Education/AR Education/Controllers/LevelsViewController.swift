//
//  LevelsViewController.swift
//  AR Education
//
//  Created by Howard Wang on 3/10/18.
//  Copyright © 2018 Mango Apps. All rights reserved.
//

import UIKit

class LevelsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let cellReuseIdentifier = "LevelsTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(LevelsTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! UITableViewCell
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Constants.Segue.toAR, sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
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
