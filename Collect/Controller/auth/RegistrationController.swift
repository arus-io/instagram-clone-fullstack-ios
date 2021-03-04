//
//  RegistrationController.swift
//  Collect
//
//  Created by Patrick Ortell on 1/23/21.
//

import UIKit


class RegistrationController: UIViewController {
    
    // MARK: Properties
    
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    weak var delegate: AuthDelagate?
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handelProfilePhotoSelect), for: .touchUpInside)
        return button
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
    
    private let fullnameTextFeild: UITextField = CustomTextFeild(placeholder: "Full Name")
    private let usernameTextFeild: UITextField = CustomTextFeild(placeholder: "Username")


    
    private let signUpButton: UIButton = {
        let button = UIButton (type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attriburtedTitle(firstPart: "Already have an account?", secondPart: "Sign in")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button

    }()
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotifacationObservers()
        hidesKeyboard()
        
        
    }
    
    
    // MARK: KeyBoard hack
    
    func hidesKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    
    //MARK: -- Actions
    
    
    @objc func handleSignUp(){
        guard let email = emailTextFeild.text else {return}
        guard let password = passwordTextFeild.text else {return}
        guard let fullname = fullnameTextFeild.text else {return}
        guard let username = usernameTextFeild.text?.lowercased() else {return}
        guard let profileImage = self.profileImage else {return}
        let credentials = AuthCreds(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        
        AuthService.registerUser(withCredentials: credentials) { error in
            if let error = error {
                print("DEBUG: failed to register user")
                return
            }
            
            self.delegate?.AuthenticationComplete()
            
            
            }
        }
    
    @objc func handleShowLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField){
        if sender == emailTextFeild {
            viewModel.email = sender.text
        } else if sender == passwordTextFeild {
            viewModel.password = sender.text
        } else if sender == fullnameTextFeild {
            viewModel.fullname = sender.text
        } else {
            viewModel.username = sender.text
        }
        
        updateForm()
        
    }
    
    @objc func handelProfilePhotoSelect(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil )
    }
    
    
    // MARK: --Helpers
    func configureUI(){
        configureGraidentLayer()
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.setDimensions(height: 140, width: 140)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTextFeild, passwordTextFeild, fullnameTextFeild, usernameTextFeild, signUpButton])
        stack.axis = .vertical
        stack.spacing = 20
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        
        
    }
    
    func configureNotifacationObservers(){
        emailTextFeild.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextFeild.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextFeild.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextFeild.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        

    }
    
}


//MARK: FormViewModel

extension RegistrationController: FormViewModel {
    func updateForm() {
        signUpButton.backgroundColor = viewModel.buttonBackgroundColor
        signUpButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        signUpButton.isEnabled = viewModel.formIsValid
    }
    
    
}


//MARK: -UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else {return}
        profileImage = selectedImage
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 2
        plusPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true, completion: nil)
    }
}






