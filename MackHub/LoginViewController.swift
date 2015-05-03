//
//  ViewController.swift
//  MackHub
//
//  Created by Rafael Fernandes de Oliveira Carvalho on 4/27/15.
//  Copyright (c) 2015 Rafael Fernandes de Oliveira Carvalho. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Variable declaration

    @IBOutlet weak var login: UITextField!
    
    var ghManager = GitHubManager.sharedInstance;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ((ghManager.login) != nil) {
            print(ghManager.login);
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
            return true;
        }
        
        return false;
    }


}

