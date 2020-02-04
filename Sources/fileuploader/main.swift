import Foundation
import LoggerAPI
import DotEnv
import HeliumLogger
import Kitura
import KituraCompression
import KituraSession
import KituraStencil
import SwiftKuerySQLite

HeliumLogger.use()

let env = DotEnv.init(withFile: ".env")
guard let secret = env.get("secret") else {
    Log.exit("Must provide a secret in .env")
    exit(1)
}

guard let password = env.get("password") else {
    Log.exit("Must provide a secret in .env")
    exit(1)
}

guard let cookie = env.get("cookiename") else {
    Log.exit("Must provide a cookie name in .env")
    exit(1)
}

let router = Router()

router.add(templateEngine: StencilTemplateEngine())

let session = Session(secret: secret, cookie: [.name("caliban-session-id")], store: nil)

router.all(middleware: [session, Compression(), StaticFileServer()])
router.post(middleware: [BodyParser()])

router.get("/home", middleware: [MustBeConnected()])
router.post("/home", middleware: [MustBeConnected(), AddFileMiddleware()])

router.get("/") {
    _, response, next in
    
    _ = try? response.redirect("/home")
    next()
}

router.get("/home") {
    _, response, next in
    
    defer {
        next()
    }
    
    do {
        try response.render("index.stencil", context: ["files" : Buffer.toArray()])
    } catch let e {
        Log.error(e.localizedDescription)
        response.status(.internalServerError)
    }
    
}

router.post("/home") {
    request, response, next in
    
    defer {
        next()
    }
    
    guard let addedFileName = request.userInfo["addedFile"] as? String else {
        _ = try? response.redirect("/", status: .internalServerError)
        return
    }
    
    guard let formData = request.body?.asMultiPart else {
        _ = try? response.redirect("/", status: .unprocessableEntity)
        return
    }
    
    var name: String? = nil
    var description: String? = nil
    
    
    for data in formData {
        if data.name == "description" {
            description = data.body.asText
        }
        if data.name == "file" {
            name = data.filename
        }
    }
    
    guard nil != name else {
        response.status(.badRequest)
       _ = try? response.redirect("/")
       return
    }
    
    let formatedFile = Buffer.File(name: name!, path: addedFileName, description: description ?? "")
    
    Buffer.files.append(formatedFile)
    
    do {
        try response.redirect("/")
    } catch let e {
        response.status(.internalServerError)
        response.send(e.localizedDescription)
    }
}

router.get("/connection") {
    _, response, next in
    
    defer {
        next()
    }
    
    do {
        try response.render("connection.stencil", context: [:]).end()
    } catch let e {
        response.status(.internalServerError)
        response.send(e.localizedDescription)
    }
}

router.post("/connection") {
    request, response, next in
    
    guard let data = request.body?.asURLEncoded, let passwd = data["password"] else {
        response.status(.badRequest)
        return
    }
    
    guard passwd == env.get("password")! else {
        response.status(.forbidden)
        _ = try? response.redirect("/connection")
        return
    }
    
    let token = Token(value: UUID())
    validConnexion[token.value] = Date()
    request.session?[cookie] = token
    
    request.session?.save(callback: { error in
        guard nil == error else {
            response.status(.internalServerError)
            return
        }

        do {
            try response.redirect("/home")
            next()
        } catch let e {
            Log.error(e.localizedDescription)
            response.status(.internalServerError)
        }
    })
}

Kitura.addHTTPServer(onPort: 80, with: router)
Kitura.run()
