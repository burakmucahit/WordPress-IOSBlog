import SwiftUI

struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.subheadline.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(ThemeColors.accent.opacity(0.95))
                    .shadow(color: ThemeColors.text.opacity(0.1), radius: 10, x: 0, y: 5)
            )
            .padding(.top, 10)
    }
}

extension View {
    func toast(isPresented: Binding<Bool>, message: String) -> some View {
        self.overlay(
            ZStack {
                if isPresented.wrappedValue {
                    VStack {
                        ToastView(message: message)
                        Spacer()
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.spring(duration: 0.3)) {
                                isPresented.wrappedValue = false
                            }
                        }
                    }
                }
            }
            .animation(.spring(duration: 0.5), value: isPresented.wrappedValue)
        )
    }
}

#Preview {
    VStack {
        Text("Preview")
    }
    .toast(isPresented: .constant(true), message: "Önbellek temizlendi")
} 