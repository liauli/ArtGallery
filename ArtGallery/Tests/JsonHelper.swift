//
//  JsonHelper.swift
//  ArtGallery
//
//  Created by aulia_nastiti on 08/06/25.
//


import Foundation

enum ReadJsonError: Error, Equatable {
  case fileNotFound
  case failedToParse
}

class JsonHelper {
  func readJson(_ fileName: String, bundle: Bundle = .main) throws -> String {
    if let jsonURL = bundle.url(forResource: fileName, withExtension: "json") {
      do {
        let jsonString = try String(contentsOf: jsonURL)
        return jsonString
      } catch {
        throw ReadJsonError.failedToParse
      }
    } else {
      throw ReadJsonError.fileNotFound
    }
  }

  func decodeJSON<T: Decodable>(_ type: T.Type, from jsonData: Data) -> T? {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    do {
      let decodedObject = try decoder.decode(type, from: jsonData)
      return decodedObject
    } catch {
      return nil
    }
  }
}
