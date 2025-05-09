//
//  LogView.swift
//  mdcX
//
//  Created by 이지안 on 5/9/25.
//

import SwiftUI

struct LogView: View {
    @Binding var logMessages: String
    @ObservedObject var logStore: LogStore

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Activity Log:")
                    .font(.caption.bold())
                Spacer()
                Button {
                    logStore.clear()
                } label: {
                    Image(systemName: "trash")
                        .font(.caption)
                }
            }
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: true) {
                    Text(logMessages) 
                        .font(.caption2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .id("logEnd_ID")
                        .padding(5)
                        .textSelection(.enabled)
                }
                .frame(height: 100)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .onChange(of: logMessages) { _ in
                    withAnimation {
                        proxy.scrollTo("logEnd_ID", anchor: .bottom)
                    }
                }
                .onAppear {
                     proxy.scrollTo("logEnd_ID", anchor: .bottom)
                }
            }
        }
    }
}
