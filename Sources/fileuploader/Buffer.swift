
//
//  File.swift
//  fileuploader
//
//  Created by Hugo Medina on 31/01/2020.
//

import Foundation

class Buffer: Codable {
    public struct File {
        let name: String
        let path: String
        let description: String
        
        public func toArray() -> [String: String] {
            return [
                "name": name,
                "path": path,
                "description": description,
            ]
        }
    }
    
    public static var files = [File]()
    
    public static func toArray() -> [[String: String]] {
        return files.map{ $0.toArray() }
    }
    
    private init() {}
}
