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
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Activity Log")
                    .font(.footnote.weight(.semibold))
                Spacer()
                Button {
                    logStore.clear()
                } label: {
                    Image(systemName: "trash")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
                .buttonStyle(.plain)
            }
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: true) {
                    Text(logMessages)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .id("logEnd_ID_LogView")
                        .padding(EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6))
                }
                .frame(height: 70) // <<-- REDUCED HEIGHT
                .background(Color(uiColor: .systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .onChange(of: logMessages) { _ in
                    withAnimation(.easeOut(duration:0.1)) {
                        proxy.scrollTo("logEnd_ID_LogView", anchor: .bottom)
                    }
                }
                .onAppear {
                     proxy.scrollTo("logEnd_ID_LogView", anchor: .bottom)
                }
            }
        }
    }
}
