//
//  String+extensions.swift
//  Photo Library
//
//  Created by Артур Кононович on 28.07.21.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
