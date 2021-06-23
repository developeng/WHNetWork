//
//  ViewController.swift
//  WHNetWork
//
//  Created by developeng on 2021/6/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        API.EnvSelect.isTest = false
        
        API.Prefix.dev = "http://www.baidu.com"
        
        
        if API.EnvSelect.isTest == true {
            
            print(API.EnvSelect.defaultEnv)
        } else {
            print(API.EnvSelect.defaultEnv)
        }
        
        
        
        // Do any additional setup after loading the view.
    }


}

