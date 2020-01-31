import Foundation
import LoggerAPI
import DotEnv
import HeliumLogger
import Kitura
import KituraCompression
import KituraSession
import KituraStencil

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

let router = Router()

router.all(middleware: [Session(secret: secret), Compression(), StaticFileServer()])
router.post(middleware: [BodyParser()])

router.get("/", middleware: [MustBeConnected()])
router.post("/", middleware: [MustBeConnected(), AddFileMiddleware()])
router.add(templateEngine: StencilTemplateEngine())

router.get("/") {
    _, response, next in
    
    defer {
        next()
    }
    
    do {
        try response.render("index.stencil", context: ["files" : Buffer.toArray()])
    } catch let e {
        response.status(.internalServerError)
        response.send(e.localizedDescription)
    }
    
}

router.post("/") {
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
        try response.render("connection.stencil", context: [:])
    } catch let e {
        response.status(.internalServerError)
        response.send(e.localizedDescription)
    }
}

router.post("/connection") {
    request, response, next in
    
    defer {
        next()
    }
    
    dump(request)
}

Kitura.addHTTPServer(onPort: 80, with: router)
Kitura.run()
