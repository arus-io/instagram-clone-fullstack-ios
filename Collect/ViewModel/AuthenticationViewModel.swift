//
//  AuthenticationViewModel.swift
//  Collect
//
//  Created by Patrick Ortell on 1/25/21.
//

import UIKit


protocol AuthenicationViewModel {
    var formIsValid: Bool {get}
    var buttonBackgroundColor: UIColor {get}
    var buttonTitleColor: UIColor {get}
}

protocol FormViewModel {
    func updateForm()
}

struct LoginViewModel: AuthenicationViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false 
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
}


struct RegistrationViewModel: AuthenicationViewModel {

    
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false && fullname?.isEmpty == false && username?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)

    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

    }
    
}
