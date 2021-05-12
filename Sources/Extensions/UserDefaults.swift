//
//  UserDefaults.swift
//  Appong
//
//  Created by Gints Murans on 02/02/2021.
//

import Foundation

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"

    var errorDescription: String? {
        rawValue
    }
}

extension UserDefaults {
    func setObject<Object: Encodable>(_ object: Object, forKey: String) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }

    func getObject<Object: Decodable>(forKey: String, castTo type: Object.Type) throws -> Object {
        guard let data = data(forKey: forKey) else {
            throw ObjectSavableError.noValue
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}
