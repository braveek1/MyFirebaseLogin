//
//  ViewController.swift
//  MyFirebaseLoginBrave
//
//  Created by YONGKI LEE on 2020/02/01.
//  Copyright © 2020 Brave Lee. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FTIndicator
import Alamofire
import Kingfisher



class ViewController: UIViewController {
    
    override func viewDidLoad() {
        
        //setBackgroundColor(view: self.view)
        setLoginBackgroundColor()
        setSignUpBackgroundColor()
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //change to status
        changeToStatus()
        autoLogin()
    }
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        hideKeyboard()
        
        guard let email = emailTextField.text, !email.isEmpty else {
            print("braveLee:: user ID has error")
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            print("braveLee:: user ID has error")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            guard error == nil else { return }
            
            guard let currentUser = Auth.auth().currentUser else { return }
            currentUser.getIDToken { (result, error) in
                guard error == nil else { return }
                
                if let result = result {
                    print("result : \(result)")
                    
                    UserDefaults.standard.set(result, forKey: "currentUserTokenId")
                    UserDefaults.standard.synchronize()
                }
                
            }
            let alertController = UIAlertController(title: "Login Success", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alertController.addAction(action)
            strongSelf.present(alertController, animated: true, completion: nil)
        }
        
        
        changeToStatus()
    }
    
    public func goTologinSuccessViewController() {
        
    //let loginSuccessViewController: LoginSuccessViewController
        //self.present(<#T##viewControllerToPresent: UIViewController##UIViewController#>, animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        
        hideKeyboard()
        
        guard let email = emailTextField.text, !email.isEmpty else {
            print("braveLee:: user ID has error")
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            print("braveLee:: user ID has error")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard error == nil else { return }
            let alertController = UIAlertController(title: "Signup Success", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
        changeToStatus()
    }
    
    private func changeToStatus() {
        guard let currentUser = Auth.auth().currentUser else { return }
        guard let currentUserEmail = currentUser.email else { return }
        statusLabel.text = "status : \(currentUserEmail)"
        
    }
    
    
    private func autoLogin() {
        
        if let currentUserTokenId = UserDefaults.standard.string(forKey: "currentUserTokenId") {
            Auth.auth().signIn(withCustomToken: currentUserTokenId) { authDataResult, error in
                if error == nil {
                    let alertController = UIAlertController(title: "Login Success", message: "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                    print("login Success")
                } else {
                    print("login Error")
                }
                if let authDataResult = authDataResult {
                    print("authDataResult : \(authDataResult)")
                }
            }
        } else {
            print("token not found")
        }
    }
    
    private func setSignUpBackgroundColor() {
        signUpButton.backgroundColor = UIColor.init(red: 0.3, green: 0.3, blue: 0.8, alpha: 0.6)
        
    }
    
    private func setLoginBackgroundColor() {
        loginButton.backgroundColor = UIColor.init(red: 0.3, green: 0.3, blue: 0.8, alpha: 0.6)
        
    }
    private func setBackgroundColor(view: UIView) {
        
        let caGradientLayer = CAGradientLayer()
        
        let color1 = UIColor.init(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0).cgColor
        
        let color2 = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        
        caGradientLayer.colors = [color1, color2]
        
        caGradientLayer.locations = [0.0, 0.5]
        
        caGradientLayer.frame = view.bounds
        
        view.layer.insertSublayer(caGradientLayer, at: 0)
    }
    
    var weatherViewController: BookViewController?
    
    
    private func hideKeyboard() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    

}
