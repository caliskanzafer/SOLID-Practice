//
//  HomeCellProtocol.swift
//  SOLID-Practice
//
//  Created by Zafer Çalışkan on 25.02.2024.
//

import Foundation

protocol HomeCellProtocol {
    
    var joke: JokeModelProtocol? { get }
    var isExist: Bool { get set }
}
