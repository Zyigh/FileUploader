
//
//  File.swift
//  fileuploader
//
//  Created by Hugo Medina on 31/01/2020.
//

import Foundation

class Buffer {
    public struct File {
        let name: String
        let path: String
        let description: String
    }
    
    public static let files = [File]()
    
    private init() {}
}
