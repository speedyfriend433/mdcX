//
//  LogStore.swift
//  mdcX
//
//  Created by 이지안 on 5/9/25.
//

import SwiftUI

class LogStore: ObservableObject {
    @Published var messages: String = "System Tweak Tool Initialized.\n"

    func append(message: String) {
        DispatchQueue.main.async {
            let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
            self.messages += "\(timestamp): \(message)\n"
        }
    }

    func clear() {
        DispatchQueue.main.async {
            self.messages = "Log cleared at \(DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)).\n"
        }
    }
}
