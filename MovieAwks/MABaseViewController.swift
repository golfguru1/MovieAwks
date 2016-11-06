//
//  MABaseViewController.swift
//  MovieAwks
//
//  Created by Mark Hall on 2016-05-26.
//  Copyright © 2016 markhall. All rights reserved.
//

import UIKit

class MABaseViewController: UIViewController {
    func showError(_ error:NSError){
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle:.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
        
    }
    
    func showErrorString(_ error:String){
                let alert = UIAlertController(title: "Error", message: error, preferredStyle:.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
    }
}
