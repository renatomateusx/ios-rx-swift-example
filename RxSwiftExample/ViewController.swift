//
//  ViewController.swift
//  RxSwiftExample
//
//  Created by Renato Mateus on 28/02/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class ViewController: UIViewController {
    
    private let loginViewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var btnlogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFields()
    }
    
    func configureFields()
    {
        loginTextField.becomeFirstResponder()
       
        loginTextField.rx.text.map { $0 ?? "" }.bind(to: loginViewModel.loginPublishSubject).disposed(by: disposeBag)
        passwordTextField.rx.text.map { $0 ?? "" }.bind(to: loginViewModel.passwordPublishSubject).disposed(by: disposeBag)
        
        loginViewModel.isValid().bind(to: btnlogin.rx.isEnabled).disposed(by: disposeBag)
        loginViewModel.isValid().map { $0 ? 1 : 0.1 }.bind(to: btnlogin.rx.alpha).disposed(by: disposeBag)
    }

    @IBAction func btnLoginAction(_ sender: UIButton) {
        print("Login Button tapped")
    }
    
}

class LoginViewModel {
    let loginPublishSubject = PublishSubject<String>()
    let passwordPublishSubject = PublishSubject<String>()
    
    func isValid() -> Observable<Bool> {
        return Observable.combineLatest(loginPublishSubject.asObservable().startWith(""), passwordPublishSubject.asObservable().startWith("")).map { username, password in
            return username.count > 3 && password.count > 3
        }.startWith(false)
    }
}


