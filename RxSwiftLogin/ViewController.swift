//
//  ViewController.swift
//  RxSwiftLogin
//
//  Created by Nir Leshem on 10/04/2020.
//  Copyright © 2020 Nir Leshem. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var userNameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    private let disposeBag = DisposeBag()
    private let viewModel = LoginViewModel()
    private var keyboardIsOpen: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        userNameTextfield.rx.text.map { $0 ?? "" }.bind(to: viewModel.userNameSubject).disposed(by: disposeBag)
        passwordTextfield.rx.text.map { $0 ?? "" }.bind(to: viewModel.passwordSubject).disposed(by: disposeBag)
        
        viewModel.isValid().bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
        viewModel.isValid().map { $0 ? 1.0 : 0.25 }.bind(to: loginButton.rx.alpha).disposed(by: disposeBag)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(resignTextfields))
        view.addGestureRecognizer(tap)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func resignTextfields() {
        if userNameTextfield.isFirstResponder {
            userNameTextfield.resignFirstResponder()
        }
        if passwordTextfield.isFirstResponder {
            passwordTextfield.resignFirstResponder()
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if !keyboardIsOpen {
            keyboardIsOpen.toggle()
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.topConstraint.constant = 100
                self?.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if keyboardIsOpen {
            keyboardIsOpen.toggle()
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.topConstraint.constant = 200
                self?.view.layoutIfNeeded()
            }
        }
    }

    @IBAction func loginAction(_ sender: Any) {
        print("login tapped")
        resignTextfields()
    }
}

