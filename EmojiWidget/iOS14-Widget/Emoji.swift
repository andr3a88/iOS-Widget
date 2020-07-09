//
//  Emoji.swift
//  iOS14-Widget
//
//  Created by Andrea Stevanato on 08/07/2020.
//

import Foundation

struct Emoji: Identifiable, Codable {

    var id: String { icon }

    let icon: String
    let name: String
    let description: String
}
