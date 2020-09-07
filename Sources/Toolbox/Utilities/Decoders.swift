import Foundation

public struct Decoders {
    public static let standardJSON: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(Decoders.decodeDate)
        return decoder
    }()

    public static func decodeDate(decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)

        if let value = Formatters.isoDateFormatter.date(from: raw) {
            return value
        }

        if let value = Formatters.apiRenderedFormatter.date(from: raw) {
            return value
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Couldn't decode Date from \(raw).")
        }
    }
}
