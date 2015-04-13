//
//  ViewController.swift
//  Instagram
//
//  Created by Rafael Nicolett on 09/04/15.
//  Copyright (c) 2015 Code Behind. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var alredyRegistered: UILabel!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var singupButton: UIButton!
    @IBOutlet weak var singupToogleButton: UIButton!
    
    var error = ""
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func singUp(sender: AnyObject) {
        if username.text == "" || password.text == "" {
            error = "Por favor insira o usuario e a senha!"
        }
        
        if error != ""{
            displayAlert("Error no registro!", errorParam: error)
        } else {
            register(username.text, password: password.text)
           
        }
    }
    
    @IBAction func toogleSingUp(sender: AnyObject) {
        login(username.text, password: password.text)
    }
    
    func login(username: String!, password: String!) {
        loadPauseApplication()
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user: PFUser?,singinError : NSError?) -> Void in
            self.restorePauseApplication()
            if singinError == nil {
                println("logged in!!!")
            } else {
                if let errorString = singinError?.userInfo?["error"] as? NSString {
                    self.error = errorString as String
                }else{
                    self.error = "Por favor tente novamente!"
                }
                
                self.displayAlert("Nao foi possivel entrar!", errorParam: self.error)
            }
        }
    }
    
    func register(username: String!, password: String!) {
        var user = PFUser()
        user.username = username
        user.password = password
        
        loadPauseApplication()
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, signupError: NSError?) -> Void in
            self.restorePauseApplication()
            if signupError == nil {
                println("singned up!!!")
            } else {
                if let errorString = signupError?.userInfo?["error"] as? NSString {
                    self.error = errorString as String
                }else{
                    self.error = "Por favor tente novamente!"
                }
                
                self.displayAlert("Nao foi possivel registrar-se!", errorParam: self.error)
            }
        }
    }
    
    func displayAlert(title: String, errorParam: String){
        var alert = UIAlertController(title: title, message: errorParam, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func loadPauseApplication(){
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    func restorePauseApplication(){
        activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
}

