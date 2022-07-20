//
//  AircraftListPresenter.swift
//  FOOT
//
//  Created by Nuno Silva on 06/07/2022.
//

import Foundation
import Combine

class AircraftsListPresenter: ObservableObject{
    private let interactor: AircraftsListInteractor
    private var cancellabels = Set<AnyCancellable>()
    @Published var aircrafts: [Aircraft] = []
    
    init(interactor: AircraftsListInteractor){
        self.interactor = interactor
        
        interactor.model.$aircrafts
            .assign(to: \.aircrafts, on: self)
            .store(in: &cancellabels)
    }
}
