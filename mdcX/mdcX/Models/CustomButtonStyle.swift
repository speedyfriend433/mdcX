//
//  CustomButtonStyle.swift
//  mdcX
//
//  Created by 이지안 on 5/10/25.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    var color: Color
    var foregroundColor: Color = .white
    var isDisabledStyle: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(isDisabledStyle ? Color.gray.opacity(0.5) : (configuration.isPressed ? color.opacity(0.7) : color))
            .foregroundColor(isDisabledStyle ? Color.gray : foregroundColor)
            .cornerRadius(10) // Increased corner radius
            .shadow(color: isDisabledStyle ? .clear : color.opacity(0.3), radius: configuration.isPressed || isDisabledStyle ? 0 : 4, x: 0, y: configuration.isPressed || isDisabledStyle ? 1 : 3) // Adjusted shadow
            .scaleEffect(configuration.isPressed && !isDisabledStyle ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
