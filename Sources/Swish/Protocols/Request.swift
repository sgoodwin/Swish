import Foundation

public typealias EmptyResponse = Void

public protocol Request {
  associatedtype ResponseObject

  func build() -> URLRequest
  func parse(_ data: Data) throws -> ResponseObject
}

public extension Request where ResponseObject: Decodable {
  func parse<Wrapped>(_ data: Data) -> ResponseObject where ResponseObject == Wrapped? {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
      return try? decoder.decode(ResponseObject.self, from: data)
  }

  func parse<Wrapped>(_ data: Data) throws -> ResponseObject where ResponseObject == Wrapped {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
      return try decoder.decode(ResponseObject.self, from: data)
  }
}

public extension Request where ResponseObject == EmptyResponse {
  func parse(_: Data) throws -> ResponseObject {}
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
