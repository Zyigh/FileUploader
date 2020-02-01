//
//  MustBeConnected.swift
//  fileuploader
//
//  Created by Hugo Medina on 31/01/2020.
//

import Foundation
import Kitura
import KituraSession
import DotEnv

extension Date {
  static func add(days: Int) -> Date {
    let currentDate = Date()
    var dateComponents = DateComponents()
    dateComponents.day = days
    return Calendar.current.date(byAdding: dateComponents, to: currentDate)!
  }
}

class MustBeConnected: RouterMiddleware {
    public func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        let oldestValidDate = Date.add(days: -30)
        
        let env = DotEnv(withFile: ".env")
        
        guard let token: Token = request.session?[env.get("cookiename")!],
            let lastConnexion = validConnexion[token.value],
            oldestValidDate < lastConnexion else {
                
                response.status(.unauthorized)
                _ = try? response.redirect("/connection")
                return
        }
        
        validConnexion[token.value] = Date()
        next()
    }
}
