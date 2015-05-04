//
//  ViewController.swift
//  MackHub
//
//  Created by Rafael Fernandes de Oliveira Carvalho on 4/27/15.
//  Copyright (c) 2015 Rafael Fernandes de Oliveira Carvalho. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Variable declaration

    @IBOutlet weak var login: UITextField!
    
    var ghManager = GitHubManager.sharedInstance;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true;
        
        if ((ghManager.login) != nil) {
            self.performSegueWithIdentifier("repositoriesSegue", sender: self)
        }
        
        login.delegate = self;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //Se o texto inserido for vazio ou tiver mais de 39 caracteres...
        if (textField.text.isEmpty || count(textField.text) > 39) {
            //É mostrado um alerta ao usuário.
            let nameTooSmallAlert = UIAlertController(title: "Aviso", message: "Insira um nome de usuário entre 1 a 39 caracteres", preferredStyle: UIAlertControllerStyle.Alert);
            nameTooSmallAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil));
            presentViewController(nameTooSmallAlert, animated: true, completion: nil);
        } else {
            //O nome de usuário inserido é guardado para futura referência.
            ghManager.login = textField.text;
            performSegueWithIdentifier("repositoriesSegue", sender: self);
            return true;
        }
        
        return false;
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        login.resignFirstResponder();
    }
    
}

