//
//  String+Extension.swift
//  shop-keep
//
//  Created by Kaichi Momose on 2018/02/14.
//  Copyright © 2018 Eliel Gordon. All rights reserved.
//

import Foundation

extension String {
    var isEmptyOrWhitespace: Bool {
        return self.trimmingCharacters(in: CharacterSet.whitespaces) == ""
    }
}
