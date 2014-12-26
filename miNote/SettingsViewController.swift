//
//  SettingsViewController.swift
//  miNote
//
//  Created by Dominik Butz on 05/11/14.
//  Copyright (c) 2014 Duoyun. All rights reserved.
//

import UIKit

@objc
protocol SettingsViewControllerDelegate {
    
    func didTapMenuButton()
    
}

class SettingsViewController: UIViewController {

    
    var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func menuBarButtonItemTapped(sender: UIBarButtonItem) {
        
        
        if let d = delegate? {
            
            d.didTapMenuButton()
        }
        
    }
    
    

}
