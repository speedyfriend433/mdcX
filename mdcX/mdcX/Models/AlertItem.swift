//
//  AlertItem.swift
//  mdcX
//
//  Created by 이지안 on 5/9/25.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text?
    var primaryButton: Alert.Button
    var secondaryButton: Alert.Button?
}
