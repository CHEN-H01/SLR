import Foundation
import SwiftUI
import AVKit
//import AVFoundation

struct RoundedAndShadowProButtonStyle: ButtonStyle {
    @Environment(\.controlSize) var controlSize
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width:150, height: 30, alignment: .center)
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .font(.headline)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(configuration.role == .destructive ? .red : .blue)
            )
            .compositingGroup()
            .overlay(
                VStack {
                    if configuration.isPressed {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.5))
                            .blendMode(.hue)
                    }
                }
            )
            .shadow(radius: configuration.isPressed ? 0 : 5, x: 0, y: configuration.isPressed ? 0 : 3)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == RoundedAndShadowProButtonStyle {
    static var roundedAndShadowPro: RoundedAndShadowProButtonStyle {
        RoundedAndShadowProButtonStyle()
    }
}

struct ContentView: View {
    @State private var showCamera = false
    var body: some View {
        ZStack {
            
            HStack(spacing: 10) {
                
                Button(action: { open_camera_action("Open camera") }, label: { label1 })
                .buttonStyle(.roundedAndShadowPro)
                .sheet(isPresented: $showCamera) {
                    CameraViewAdapter()
                }
                
                Button(action: { upload_action("Upload video") }, label: { label2 })
                .buttonStyle(.roundedAndShadowPro)
                
            }
        }
        // 使布局撑满屏幕
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        // 设置背景色
        .background(
            Image("back")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
    }
    
    func open_camera_action(_ text: String) {
        showCamera = true
        print(text)
    }
    
    func upload_action(_ text: String) {
        print(text)
    }
}
    
let label1 = Label("Open Camera", systemImage: "camera.circle.fill")
let label2 = Label("Upload Video", systemImage: "square.and.arrow.up.circle.fill")


let videoURL = URL(string: "https://example.com/video.mp4")
let player = AVPlayer(url: videoURL!)
let playerViewController = AVPlayerViewController()



