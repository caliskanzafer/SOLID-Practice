//
//  CoreDataRepositoryManager.swift
//  SOLID-Practice
//
//  Created by Zafer Çalışkan on 27.02.2024.
//

import Foundation

protocol CoreDataRepositoryManager {
    func getJokeEntity(id: String) -> [JokeEntity]?
}