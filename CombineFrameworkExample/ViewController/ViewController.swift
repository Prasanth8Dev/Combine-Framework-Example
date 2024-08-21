//
//  ViewController.swift
//  CombineFrameworkExample
//
//  Created by Prasanth S on 20/08/24.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    var loginVM = LoginViewModel()
    
    @IBOutlet weak var userIdTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    var cancellables = Set<AnyCancellable>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    
    
    @IBAction func loginTapped(_ sender: Any) {
        guard let userId = userIdTF.text, !userId.isEmpty, let pass = passwordTF.text, !pass.isEmpty else {
            print("Please enter the User Id and Password")
            return
        }
        // Get the Resopnse in Model Type
         loginVM.userLogin(param: ["registerNumber":userId,
        "passwordLog":pass])
        
        
        // Get the Resopnse in JSON Data
        
//        loginVM.loginUser(param: ["registerNumber":userId,
//                                  "passwordLog":pass])
        
        
    }
    
    private func setupBindings() {
        loginVM.$jsonData.receive(on: DispatchQueue.main).sink { userLoginJsonData in
            if let loginData = userLoginJsonData {
                print(loginData)
            }
        }
        .store(in: &cancellables)
        
        loginVM.$user
            .receive(on: DispatchQueue.main)
            .sink { userLoginData in
                if let userLoginData = userLoginData {
                    print("User logged in: \(userLoginData)")
                }
            }
            .store(in: &cancellables)
        
        loginVM.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { errorMessage in
                if let errorMessage = errorMessage {
                    print("Error: \(errorMessage)")
                }
            }
            .store(in: &cancellables)
        
        loginVM.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { isStillLoading in
                // Show or Hide the Loader based on the response
                print(isStillLoading ? "Loading..." : "Loading finished.")
            }
            .store(in: &cancellables)
    }
}

