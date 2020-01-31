import Foundation

extension UUID {
    public func toSimpleString() -> String {
        return self.uuidString.replacingOccurrences(of: "-", with: "").lowercased()
    }
}

var validConnexion = [UUID: Date]()
