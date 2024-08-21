//
//  LoginViewModel.swift
//  CombineFrameworkExample
//
//  Created by Prasanth S on 20/08/24.
//

import Foundation
import Combine


class LoginViewModel {
    
    @Published var user: UserLoginModel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = ""
    @Published var jsonData: [String:Any]?
    
    private var cancellables = Set<AnyCancellable>()
    
    
    func userLogin(param:[String:Any]) {
        if let url = URL(string: "http://180.235.121.244/buspass/TransportLogin.php") {
            APIService.shared.fetchDataWithPostMethod(url: url,param: param, model: UserLoginModel.self).sink {  completion in
                switch completion {
                case .finished:
                    print("")
                    self.isLoading = false
                case .failure(let err):
                    self.isLoading = false
                    self.errorMessage = err.localizedDescription
                    print("Failed with error: \(err.localizedDescription)")
                }
            } receiveValue: { loginResponse in
                self.user = loginResponse
            }
            .store(in: &cancellables)
        }
    }
    
    func loginUser(param:[String:Any]) {
        isLoading = true
        if let url = URL(string: "http://180.235.121.244/buspass/TransportLogin.php") {
            APIService.shared.fetchRawDataWithFormData(url: url, param: param)
                .sink { completion in
                    switch completion {
                    case .finished:
                        self.isLoading = false
                    case .failure(let err):
                        self.isLoading = false
                        self.errorMessage = err.localizedDescription
                        print("Failed with error: \(err.localizedDescription)")
                    }
                } receiveValue: { data in
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        self.jsonData = json
                    } else {
                        self.errorMessage = "Failed to parse JSON"
                    }
                }
                .store(in: &cancellables)
        }
    }
}
