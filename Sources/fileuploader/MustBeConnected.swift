//
//  MustBeConnected.swift
//  fileuploader
//
//  Created by Hugo Medina on 31/01/2020.
//

import Foundation
import Kitura
import KituraSession

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
        
        guard let token = request.session?["connexionToken"] else {
            _ = try? response.redirect("/connection", status: .unauthorized)
            return
        }
    }
}
