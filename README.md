# fileuploader

A very simple file uploader that you can use to share files easily on your servers, based on [Kitura](https://www.kitura.io/)

**NOT PRODUCTION READY**

## How to deploy

First of all, clone the project

```
git clone https://github.com/Zyigh/FileUploader.git
cd FileUploader
```

`Package.swift` requires Swift 5.1, but you probably can downgrade that to 5.0. I can't guarantee anything for Swift <5.0

First of all, you just need to copy .env.dist as .env file and fill the blank values
```
cp .env.dist .env
```

### Deployement with Docker

This wasn't tested with many environments, but works with Docker 19.03.5 for Mac OS Catalina 10.15.2 and for Debian 10. 

The web server will run on port 80, the example will let you enjoy the file uploader on the host machine on port 8000

Simply run 
```
docker build --rm -t fileuploader .
docker run -d --name FileUploader -p 8000:80 fileuploader
```

You might want to persist the files you get, in which case the docker run command will look like

```
docker run -d --name FileUploader -p 8000:80 -v $PWD/public/uploaded:/fileuploader/public/uploaded fileuploader
```

### Deployement with Swift

It shouldn't be to hard to run the web server with Swift

```
swift package generate-xcodeproj
swift build
swift run
```

## Features wanted

### Database

Actually, all the data is stored in memory 

It would be great to add a database on this. CouchDB would probably make a good deal for that.

Also we might want to look at this https://github.com/Oyvindkg/swiftydb 🐬

### Cookies

It might be cool to handle cookies with another service. KituraSession example works well with PostgreSQL and Redis, but it might be a bit huge for the usage this website requires. Perhaps a simple SQLite would be enough ?

### Files Name

Now the downloading of files is quite naive. It just uses the StaticFile Middleware to display the raw file, and the browser download it magically. As the names are changed with UUID, you can't retrieve a file with it's original name, which is quite unpractical. It could be fine to returns the file with the right headers and proper filename

Feel free to open Pull Requests 😁
