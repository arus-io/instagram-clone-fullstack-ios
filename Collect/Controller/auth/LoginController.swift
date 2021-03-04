//
//  LoginController.swift
//  Collect
//
//  Created by Patrick Ortell on 1/23/21.
//

import UIKit

protocol AuthDelagate: class {
    func AuthenticationComplete()
}


class LoginController: UIViewController {
    
    // MARK: Properties
    
    private var viewModel = LoginViewModel()
    weak var delegate: AuthDelagate?
    
    private let iconImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "cliqe'_logo_white"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    
    private let emailTextFeild: UITextField = {
        let tf = CustomTextFeild(placeholder: "Email")
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let passwordTextFeild: UITextField = {
        let tf = CustomTextFeild(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    
    
    private let loginButton: UIButton = {
        let button = UIButton (type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = false
        button.addTarget(self, action: #selector (handleLogin), for: .touchUpInside)
        return button
    }()
    
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attriburtedTitle(firstPart: "Dont have an account?", secondPart: "Sign up")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button

    }()
    
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.attriburtedTitle(firstPart: "Forgot your password?", secondPart: "Get help signing in.")
        return button
    }()
    
    
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        configureUI()
        configureNotifacationObservers()
    }
    
    
    // MARK: Actions
    
    @objc func handleLogin(){
        guard let email = emailTextFeild.text else {return}
        guard let password = passwordTextFeild.text else {return}
        
        AuthService.loginUserIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print("DEBUG: failed to log user in")
                return
            }
            self.delegate?.AuthenticationComplete()
        }
    }
    
    
    @objc func handleShowSignUp(){
        let controller = RegistrationController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField){
        if sender == emailTextFeild {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        updateForm()
        
    }
    
    
    // MARK: Helpers

    func configureUI(){
        configureGraidentLayer()
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTextFeild, passwordTextFeild, loginButton, forgotPasswordButton])
        stack.axis = .vertical
        stack.spacing = 20
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        
    }
    
    func configureNotifacationObservers(){
        emailTextFeild.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextFeild.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

    }
    
    
}


//MARK: FormViewModel

extension LoginController: FormViewModel {
    func updateForm() {
        loginButton.backgroundColor = viewModel.buttonBackgroundColor
        loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        loginButton.isEnabled = viewModel.formIsValid
    }
    
    
}
