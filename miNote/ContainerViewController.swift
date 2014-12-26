//
//  ContainerViewController.swift
//  miNote
//
//  Created by Dominik Butz on 06/11/14.
//  Copyright (c) 2014 Duoyun. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, MenuViewControllerDelegate, NotesListViewControllerDelegate, SettingsViewControllerDelegate, UIGestureRecognizerDelegate {

    
    var panelClosed: Bool = true
    
    let centerPanelExpandedOffset: CGFloat = 150.0
    
    var centerNavigationController: UINavigationController!
    
    var menuViewController = UIStoryboard.menuViewController()!
    var settingsViewController = UIStoryboard.settingsViewController()!
    var notesListViewController = UIStoryboard.notesListViewController()!
    
    override init() {
        super.init(nibName: nil, bundle: nil)
    }

    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // we always want the Notes List vc's nav controller to be the first VC to appear as center VC
        
     
        
       self.notesListViewController.delegate  = self
        self.notesListViewController.title = "Notes"
        
        self.centerNavigationController = UINavigationController(rootViewController: self.notesListViewController)
        
        self.view.addSubview(self.centerNavigationController.view)
        self.addChildViewController(self.centerNavigationController!)
        
        self.centerNavigationController!.didMoveToParentViewController(self)
        
        
        

        self.settingsViewController.delegate = self
        self.settingsViewController.title = "Settings"
        
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        self.centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
        
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
    
    
    //MARK: MenuVC Delegate
    
    func menuItemSelected(menuItem: String) {
        
       // self.removeCenterNavController()
        
        switch menuItem {
            case "Settings":
                self.changeCenterNavigationControllersFirstViewController(self.settingsViewController)
            case "Notes":
                self.changeCenterNavigationControllersFirstViewController(self.notesListViewController)
            default:
            break
            
        }
        
        
    }
    
    
    //this method doesn't seem to be required
    
//    func removeCenterNavController() {
//        
//        self.centerNavigationController.view.removeFromSuperview()
//        self.centerNavigationController.removeFromParentViewController()
//      //  self.centerNavigationController = nil
//    }
    
    func changeCenterNavigationControllersFirstViewController (viewController: UIViewController) {
        
        if self.centerNavigationController.viewControllers[0] as UIViewController != viewController {
            
            self.centerNavigationController.viewControllers[0] = viewController
            
        }
        
        self.toggleLeftPanel()
        
    }
    
 
    
    
    //MARK: side menu functions & animation
    
    func toggleLeftPanel() {
        
        if self.panelClosed {
            
            self.addMenuViewController()
        }
        
        
        self.animateLeftPanel(self.panelClosed)
        
        
    }
    

    
    func addMenuViewController() {
        
        self.menuViewController.delegate = self
        
        self.view.insertSubview(self.menuViewController.view, atIndex: 0)
        
        self.addChildViewController(self.menuViewController)
        self.menuViewController.didMoveToParentViewController(self)
        
        
    }
    
    func animateLeftPanel(shouldExpand: Bool) {
        
        
        if shouldExpand {
            
            self.panelClosed = false
            
            self.showShadowForCenterViewController(true)
            
        self.animateCenterPanelXPosition(targetPosition: CGRectGetWidth(self.centerNavigationController.view.frame) - self.centerPanelExpandedOffset)

        }
        
        else {
            
            self.animateCenterPanelXPosition(targetPosition: 0, completion: { (finished) -> Void in
                
                self.panelClosed = true
                self.showShadowForCenterViewController(false)
                
                self.menuViewController.view.removeFromSuperview()
              //  self.menuViewController = nil
                
                
            })
        }
        
    }
    
    func animateCenterPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil)  {
        
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            
            self.centerNavigationController.view.frame.origin.x = targetPosition
            
            }, completion: completion)
        
    }
    
    
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        
        if shouldShowShadow {
            
             self.centerNavigationController.view.layer.shadowOpacity = 0.8
        }
        
        else {
            
            self.centerNavigationController.view.layer.shadowOpacity = 0.0
            
        }
        
    }

    
    // MARK: NotesListVC delegate
    
    func didTapMenuButton() {
        
        self.toggleLeftPanel()
        
    }
    
    
    // MARK: Gesture recognizer
    
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        
        let gestureIsDraggingFromLeftToRight: Bool = (recognizer.velocityInView(self.view).x > 0)
        
        switch recognizer.state {
            
        case .Began:
            if self.panelClosed {
                
                if gestureIsDraggingFromLeftToRight {
                    
                    self.addMenuViewController()
                }
   
                self.showShadowForCenterViewController(true)

            }
            
        case .Changed:
            recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(self.view).x
            recognizer.setTranslation(CGPointZero, inView: self.view)
            
        case .Ended:
                // animate the side panel open or closed based on whether the view has moved more or less than halfway
                let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
                self.animateLeftPanel(hasMovedGreaterThanHalfway)
            
        default:
            break
            
        }
        
        
        
    }

    
    

}


private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func menuViewController() -> MenuViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("MenuVC") as? MenuViewController
    }
    
    class func notesListViewController() -> NotesListViewController? {
        
        return mainStoryboard().instantiateViewControllerWithIdentifier("NotesVC") as? NotesListViewController
        
    }
    
    class func settingsViewController() -> SettingsViewController? {
        
        return mainStoryboard().instantiateViewControllerWithIdentifier("SettingsVC") as? SettingsViewController
    }
    
    
}
