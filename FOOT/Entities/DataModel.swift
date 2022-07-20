//
//  DataModule.swift
//  FOOT
//
//  Created by Nuno Silva on 06/07/2022.
//

import Combine

final class DataModel {
    private let persistence = PersistenceMemory()
    
    @Published var aircrafts: [Aircraft] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    func load(){
        persistence.load()
            .assign(to: \.aircrafts, on: self)
            .store(in: &cancellables)
    }
    
    func save(){
        persistence.save(aircrafts: aircrafts)
    }
    
    func loadDefaults(synchronous: Bool = false){
        persistence.loadDefault(synchronous: synchronous)
            .assign(to: \.aircrafts, on: self)
            .store(in: &cancellables)
    }
    
}

extension DataModel: ObservableObject{}

#if DEBUG
extension DataModel {
    static var sample: DataModel{
        let model = DataModel()
        model.loadDefaults(synchronous: true)
        return model
    }
}
#endif
