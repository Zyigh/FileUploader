//
//  AddFileMiddleware.swift
//  fileuploader
//
//  Created by Hugo Medina on 31/01/2020.
//

import Foundation

import Kitura

class AddFileMiddleware: RouterMiddleware {
    public func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        guard let formData = request.body?.asMultiPart,
           let data = (formData.filter{ $0.name == "file" }.first)
           else {
            _ = try? response.redirect("/", status: .unprocessableEntity)
            return
        }
        
        guard data.filename != "",
            let ext = (data.filename.split(separator: ".").map{ String($0) }.last)
           else {
            _ = try? response.redirect("/", status: .badRequest)
            return
        }
        
        let uniqueName = UUID().toSimpleString()
        let completeFileName = "\(uniqueName).\(ext)"
        
        if let raw = data.body.asRaw {
            let fm = FileManager.default
            let currentPath = fm.currentDirectoryPath
            guard fm.createFile(atPath: "\(currentPath)/public/uploaded/\(completeFileName)", contents: raw, attributes: nil) else {
                _ = try? response.redirect("/", status: .internalServerError)
                return
            }
            
            request.userInfo["addedFile"] = completeFileName
            next()
        } else {
            _ = try? response.redirect("/", status: .badGateway)
        }
    }
}
