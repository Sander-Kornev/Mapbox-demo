//
//  Subject+Extension.swift
//  Mapbox-demo
//
//  Created by Sander on 30.03.2021.
//

import Foundation
import Combine

typealias VoidSubject = PassthroughSubject<Void, Never>

extension PassthroughSubject where Output == Void {
    
    func callAsFunction() {
        send(())
    }
}

extension PassthroughSubject {
    
    func callAsFunction(_ output: Output) {
        send(output)
    }
}

extension CurrentValueSubject {
    
    func callAsFunction(_ output: Output) {
        send(output)
    }
}
