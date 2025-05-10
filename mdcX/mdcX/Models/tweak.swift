//
//  tweak.swift
//  mdcX
//
//  Created by 이지안 on 5/9/25.
//

import SwiftUI

enum TweakActionType {
    case zeroOutFiles(paths: [String])
}

struct Tweak: Identifiable {
    let id = UUID()
    var name: String
    var description: String?
    var action: TweakActionType
    var category: String
    var status: String = ""
    var isProcessing: Bool = false
}
