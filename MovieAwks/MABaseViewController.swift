//
//  MABaseViewController.swift
//  MovieAwks
//
//  Created by Mark Hall on 2016-05-26.
//  Copyright © 2016 markhall. All rights reserved.
//

import UIKit

class MABaseViewController: UIViewController {
    func showError(error:NSError){
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle:.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func showErrorString(error:String){
                let alert = UIAlertController(title: "Error", message: error, preferredStyle:.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
    }
}
