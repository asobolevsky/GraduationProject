//
//  Sequence+Extension.swift
//  GraduateProject
//
//  Created by Aleksei Sobolevskii on 2020-12-25.
//

import Foundation

extension Sequence {
    func splitBefore(separator shouldSplit: (Iterator.Element) throws -> Bool) rethrows -> [AnySequence<Iterator.Element>] {
        var result: [AnySequence<Iterator.Element>] = []
        var subSequence: [Iterator.Element] = []
        
        var iterator = makeIterator()
        while let element = iterator.next() {
            if try shouldSplit(element) {
                if !subSequence.isEmpty {
                    result.append(AnySequence(subSequence))
                }
                subSequence = [element]
            } else {
                subSequence.append(element)
            }
        }
        result.append(AnySequence(subSequence))
        return result
    }
}

extension Character {
    var isUpperCase: Bool {
        return String(self) == String(self).uppercased()
    }
}
