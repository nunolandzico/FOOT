//
//  Persistence.swift
//  FOOT
//
//  Created by Nuno Silva on 06/07/2022.
//

import Foundation
import Combine

fileprivate struct Envelope: Codable {
  let aircrafts: [Aircraft]
}

class PersistenceMemory{
    
    var localFile: URL {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("aircrafts.json")
        print("In case you need to delete the database: \(fileURL)")
        return fileURL
    }
    var defaultsFile: URL {
        return Bundle.main.url(forResource: "defaults", withExtension: "json")!
    }
    
    private func clear(){
        try? FileManager.default.removeItem(at: localFile)
    }
    
    func load() -> AnyPublisher<[Aircraft], Never>  {
      if FileManager.default.fileExists(atPath: localFile.standardizedFileURL.path) {
        return Future<[Aircraft], Never> { promise in
          self.load(self.localFile) { aircrafts in
            DispatchQueue.main.async {
              promise(.success(aircrafts))
            }
          }
        }.eraseToAnyPublisher()
      } else {
        return loadDefault()
      }
    }
    
    func save(aircrafts: [Aircraft]) {
      let envelope = Envelope(aircrafts: aircrafts)
      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted
      let data = try! encoder.encode(envelope)
      try! data.write(to: localFile)
    }
    
    private func loadSynchronously(_ file: URL) -> [Aircraft] {
      do {
        let data = try Data(contentsOf: file)
        let envelope = try JSONDecoder().decode(Envelope.self, from: data)
        return envelope.aircrafts
      } catch {
        clear()
        return loadSynchronously(defaultsFile)
      }
    }
    
    private func load(_ file: URL, completion: @escaping ([Aircraft]) -> Void) {
      DispatchQueue.global(qos: .background).async {
        let aircrafts = self.loadSynchronously(file)
        completion(aircrafts)
      }
    }
    
    func loadDefault(synchronous: Bool = false) -> AnyPublisher<[Aircraft], Never> {
      if synchronous {
        return Just<[Aircraft]>(loadSynchronously(defaultsFile)).eraseToAnyPublisher()
      }
      return Future<[Aircraft], Never> { promise in
        self.load(self.defaultsFile) { aircrafts in
          DispatchQueue.main.async {
            promise(.success(aircrafts))
          }
        }
      }.eraseToAnyPublisher()
    }
}
