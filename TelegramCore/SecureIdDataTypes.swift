import Foundation

public struct SecureIdDate: Equatable {
    public let day: Int32
    public let month: Int32
    public let year: Int32

    public init(day: Int32, month: Int32, year: Int32) {
        self.day = day
        self.month = month
        self.year = year
    }
}

public enum SecureIdGender {
    case male
    case female
}

public struct SecureIdFileReference: Equatable {
    public let id: Int64
    let accessHash: Int64
    let size: Int32
    let datacenterId: Int32
    public let timestamp: Int32
    public let fileHash: Data
    let encryptedSecret: Data
}

extension SecureIdFileReference {
    init?(apiFile: Api.SecureFile) {
        switch apiFile {
            case let .secureFile(id, accessHash, size, dcId, date, fileHash, secret):
                self.init(id: id, accessHash: accessHash, size: size, datacenterId: dcId, timestamp: date, fileHash: fileHash.makeData(), encryptedSecret: secret.makeData())
            case .secureFileEmpty:
                return nil
        }
    }
}

extension SecureIdGender {
    init?(serializedString: String) {
        switch serializedString {
            case "male":
                self = .male
            case "female":
                self = .female
            default:
                return nil
        }
    }
    
    func serialize() -> String {
        switch self {
            case .male:
                return "male"
            case .female:
                return "female"
        }
    }
}

extension SecureIdDate {
    init?(serializedString: String) {
        let data = serializedString.components(separatedBy: ".")
        guard data.count == 3 else {
            return nil
        }
        guard let day = Int32(data[0]), let month = Int32(data[1]), let year = Int32(data[2]) else {
            return nil
        }
        self.init(day: day, month: month, year: year)
    }
    
    func serialize() -> String {
        return "\(self.day).\(self.month).\(self.year)"
    }
}
