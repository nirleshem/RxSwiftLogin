//
//  LoginViewModel.swift
//  RxSwiftLogin
//
//  Created by Nir Leshem on 10/04/2020.
//  Copyright © 2020 Nir Leshem. All rights reserved.
//

import RxSwift

class LoginViewModel {
    let userNameSubject = PublishSubject<String>()
    let passwordSubject = PublishSubject<String>()
    
    func isValid() -> Observable<Bool> {
        return Observable.combineLatest(userNameSubject.asObservable().startWith(""), passwordSubject.asObservable().startWith("")).map { username, password in
            return username.count > 2 && password.count > 2
        }.startWith(false)
    }
}
