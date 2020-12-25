//
//  String+Extensions.swift
//  GraduateProject
//
//  Created by Aleksei Sobolevskii on 2020-12-25.
//

import Foundation

extension String {
    func uncapitalized() -> String {
        return prefix(1).lowercased() + dropFirst()
    }
}
