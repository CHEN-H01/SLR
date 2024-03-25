import Foundation
import SwiftUI
import PhotosUI
import UniformTypeIdentifiers
//import Alamofire

struct RoundedAndShadowProButtonStyle: ButtonStyle {
    @Environment(\.controlSize) var controlSize
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width:150, height: 20, alignment: .center)
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .font(.body)
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
    @State private var showPhotoPicker = false

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Button(action: { video2text("Translation") }, label: { label0 })
                    .buttonStyle(.roundedAndShadowPro)
                
                HStack(spacing: 10){
                    Button(action: { open_camera_action("Open Camera") }, label: { label1 })
                        .buttonStyle(.roundedAndShadowPro)
                        .sheet(isPresented: $showCamera) {
                            CameraViewAdapter()
                        }
                    
                    Button(action: { upload_action("Upload Video") }, label: { label2 })
                        .buttonStyle(.roundedAndShadowPro)
                        .sheet(isPresented: $showPhotoPicker) {
                            //                    PhotoPicker(selectionLimit: 1, filter: .videos) { results in
                            //                        if let result = results.first {
                            //                            handlePickedVideo(result)
                            //                        }
                            //                    }
                        }
                }
                
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
    
    func video2text(_ text: String) {
        print(text)
    }
    
    func open_camera_action(_ text: String) {
        showCamera = true
        print(text)
    }
    
    func upload_action(_ text: String) {
        showPhotoPicker = true
        print(text)
    }


//    func handlePickedVideo(_ result: PHPickerResult) {
//        result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
//            guard let url = url, error == nil else { return }
//
//            // Update UI if needed
//            DispatchQueue.main.async {
//                self.videoURL = url
//                // Now you can upload the video to your server
//                uploadVideoToServer(videoURL: url)
//            }
//        }
//    }

//    func uploadVideoToServer(videoURL: URL) {
//        // Specify your server upload URL and parameters
//        let uploadURL = "https://yourserver.com/upload"
//
//        AF.upload(multipartFormData: { multipartFormData in
//            multipartFormData.append(videoURL, withName: "video", fileName: videoURL.lastPathComponent, mimeType: "video/mp4")
//        }, to: uploadURL).response { response in
//            switch response.result {
//            case .success(let responseData):
//                // Handle success
//                print("Video uploaded successfully: \(String(describing: responseData))")
//            case .failure(let error):
//                // Handle error
//                print("Error uploading video: \(error.localizedDescription)")
//            }
//        }
//    }
}
    
let label0 = Label("Translation", systemImage: "rectangle.and.pencil.and.ellipsis")
let label1 = Label("Open Camera", systemImage: "camera.circle.fill")
let label2 = Label("Upload Video", systemImage: "square.and.arrow.up.circle.fill")





