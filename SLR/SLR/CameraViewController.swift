import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    var captureSession: AVCaptureSession?
    var videoOutput: AVCaptureMovieFileOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var messageLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupMessageLabel()
    }

    func setupCamera() {
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession else { return }

        // 设置摄像头输入
        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }

        // 设置视频输出
        videoOutput = AVCaptureMovieFileOutput()
        if let videoOutput = videoOutput, captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }

        // 设置预览层
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.frame = view.bounds
        previewLayer?.videoGravity = .resizeAspectFill
        if let previewLayer = previewLayer {
            view.layer.insertSublayer(previewLayer, at: 0)  // 确保预览层在背景
        }

        captureSession.startRunning()
    }

    func setupMessageLabel() {
        // 初始化并配置 UILabel
        messageLabel = UILabel()
        if let messageLabel = messageLabel {
            messageLabel.frame = CGRect(x: 0, y: view.bounds.height - 60, width: view.bounds.width, height: 40)
            messageLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            messageLabel.textColor = .white
            messageLabel.textAlignment = .center
            messageLabel.text = "这里到时现实从服务器端处理后的字符串"
            view.addSubview(messageLabel)
        }
    }

    func startRecording() {
        guard let videoOutput = videoOutput else { return }

        // 检查是否正在录制
        if videoOutput.isRecording {
            videoOutput.stopRecording()
        } else {
            // 设置视频保存的路径
            let filePath = NSTemporaryDirectory() + "tempVideo.mov"
            let fileURL = URL(fileURLWithPath: filePath)
            
            // 开始录制
            videoOutput.startRecording(to: fileURL, recordingDelegate: self)
        }

    }

    // AVCaptureFileOutputRecordingDelegate 的委托方法
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            // 处理录制过程中的错误
            print("Error recording movie: \(error.localizedDescription)")
        } else {
            // 录制完成，处理视频文件
            // 比如上传到服务器
            VideoUploader().uploadVideo(outputFileURL) { response in
                print("服务器响应: \(response)")
            }
        }
    }


}
