//
//  ViewController.swift
//  Photo Library
//
//  Created by Артур Кононович on 6.05.21.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configure()
    }
    
    func configure() {
        if UserDefaults.wasAppLaunched() {
            self.configureVC()
        } else {
            self.configureVCForFirstLaunch()
        }
    }
    
    func configureVC() {
        self.passwordTextField.placeholder = "Password".localized
        self.confirmPasswordTextField.isHidden = true
        self.loginButton.setTitle("Login".localized, for: .normal)
    }
    
    func configureVCForFirstLaunch() {
        self.passwordTextField.placeholder = "Confirm password".localized
        self.confirmPasswordTextField.placeholder = "Password".localized
        self.confirmPasswordTextField.isHidden = false
        self.loginButton.setTitle("Login".localized, for: .normal)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        self.chekPassword()
    }
    
    func chekPassword() {
        guard let password = self.passwordTextField.text,
              let confirmPassword = self.confirmPasswordTextField.text else {
            return
        }
        
        Manager.shared.checkPassword(password: password, confirmPassword: confirmPassword) { [weak self] success, error in
            if success {
                self?.showMainViewController()
            } else {
                switch error {
                case .passwordsNotEqual:
                    self?.showAlert(message: "Password mismatch".localized)
                case .incorrectPassword:
                    self?.showAlert(message: "Wrong password".localized)
                case .none:
                    break
                }
            }
        }
    }
    
    func showMainViewController() {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else {
            return
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error".localized, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.chekPassword()
        return true
    }
    
}





