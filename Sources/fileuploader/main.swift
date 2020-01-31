import HeliumLogger
import Kitura
import KituraCompression
import KituraStencil

HeliumLogger.use()

let router = Router()

router.all(middleware: [Compression(), StaticFileServer()])
router.post(middleware: BodyParser())
router.add(templateEngine: StencilTemplateEngine())

router.get("/") {
    _, response, next in
    
    defer {
        next()
    }
    
    do {
        try response.render("index.stencil", context: ["greetings" : "HELLLOOOOOO"])
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
    
    response.send(["greetings": "Hello ! Mais en post"])
}

Kitura.addHTTPServer(onPort: 80, with: router)
Kitura.run()
