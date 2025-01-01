//
//  VeoCamera.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 1/1/2025.
//

import SwiftUI
import AVFoundation
import Photos

public enum VeoCameraError: Error {
    case cameraUnavailable
    case permissionDenied
    case captureError
    case saveFailed
}

public enum VeoCameraMode {
    case photo
    case video
}

public struct VeoCamera: View {
    @StateObject private var viewModel = VeoCameraViewModel()
    
    let mode: VeoCameraMode
    let onCapture: (Result<URL, VeoCameraError>) -> Void
    let onDismiss: () -> Void
    
    var showFlashControl: Bool = true
    var showCameraSwitch: Bool = true
    
    public init(
        mode: VeoCameraMode = .photo,
        showFlashControl: Bool = true,
        showCameraSwitch: Bool = true,
        onCapture: @escaping (Result<URL, VeoCameraError>) -> Void,
        onDismiss: @escaping () -> Void
    ) {
        self.mode = mode
        self.showFlashControl = showFlashControl
        self.showCameraSwitch = showCameraSwitch
        self.onCapture = onCapture
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        ZStack {
            if let preview = viewModel.previewLayer {
                CameraPreviewView(previewLayer: preview)
                    .ignoresSafeArea()
            }
            
            VStack {
                topControls
                Spacer()
                bottomControls
            }
            .padding()
            
            if let error = viewModel.error {
                errorView(error)
            }
        }
        .onAppear {
            viewModel.checkPermissions()
            viewModel.setupSession(mode: mode)
        }
        .onDisappear {
            viewModel.stopSession()
        }
    }
    
    private var topControls: some View {
        HStack {
            Button(action: onDismiss) {
                VeoIcon(icon: .common(.close), color: .white)
                    .padding(12)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            if showFlashControl {
                Button(action: viewModel.toggleFlash) {
                    VeoIcon(
                        icon: .system(viewModel.isFlashOn ? "bolt.fill" : "bolt.slash.fill"),
                        color: .white
                    )
                    .padding(12)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
                }
            }
        }
    }
    
    private var bottomControls: some View {
        HStack {
            if showCameraSwitch {
                Button(action: viewModel.switchCamera) {
                    VeoIcon(icon: .system("camera.rotate.fill"), color: .white)
                        .padding(12)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                }
            }
            
            Spacer()
            
            Button(action: {
                viewModel.capture { result in
                    onCapture(result)
                }
            }) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 72, height: 72)
                    
                    if mode == .video && viewModel.isRecording {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.red)
                            .frame(width: 32, height: 32)
                    } else {
                        Circle()
                            .stroke(Color.black.opacity(0.2), lineWidth: 2)
                            .frame(width: 64, height: 64)
                    }
                }
            }

            Spacer()

            Color.clear
                .frame(width: 44, height: 44)
        }
    }
    
    private func errorView(_ error: VeoCameraError) -> some View {
        VStack(spacing: 16) {
            VeoIcon(icon: .common(.error), size: 48, color: .red)
            
            VeoText(errorMessage(for: error), style: .headline)
                .multilineTextAlignment(.center)
            
            VeoButton(title: "Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 8)
        .padding()
    }
    
    private func errorMessage(for error: VeoCameraError) -> String {
        switch error {
        case .cameraUnavailable:
            return "Camera is not available on this device"
        case .permissionDenied:
            return "Please allow camera access in Settings"
        case .captureError:
            return "Failed to capture photo/video"
        case .saveFailed:
            return "Failed to save captured media"
        }
    }
}

struct CameraPreviewView: UIViewRepresentable {
    let previewLayer: AVCaptureVideoPreviewLayer
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        previewLayer.frame = uiView.bounds
    }
}

class VeoCameraViewModel: ObservableObject {
    @Published var error: VeoCameraError?
    @Published var isFlashOn = false
    @Published var isRecording = false
    
    private var session: AVCaptureSession?
    private var currentCamera: AVCaptureDevice.Position = .back
    private var videoOutput: AVCaptureMovieFileOutput?
    private var photoOutput: AVCapturePhotoOutput?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if !granted {
                    DispatchQueue.main.async {
                        // self?.error = .permissionDenied
                    }
                }
            }
        default:
            error = .permissionDenied
        }
    }
    
    func setupSession(mode: VeoCameraMode) {
        let session = AVCaptureSession()
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                       for: .video,
                                                       position: currentCamera),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice)
        else {
            error = .cameraUnavailable
            return
        }
        
        guard session.canAddInput(videoInput) else {
            error = .cameraUnavailable
            return
        }
        
        session.addInput(videoInput)
        
        switch mode {
        case .photo:
            let photoOutput = AVCapturePhotoOutput()
            guard session.canAddOutput(photoOutput) else {
                error = .cameraUnavailable
                return
            }
            session.addOutput(photoOutput)
            self.photoOutput = photoOutput
            
        case .video:
            let videoOutput = AVCaptureMovieFileOutput()
            guard session.canAddOutput(videoOutput) else {
                error = .cameraUnavailable
                return
            }
            session.addOutput(videoOutput)
            self.videoOutput = videoOutput
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        self.previewLayer = previewLayer
        
        self.session = session
            session.startRunning()
    }
    
    func stopSession() {
        session?.stopRunning()
    }
    
    func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            try device.lockForConfiguration()
            
            if device.hasTorch {
                if device.torchMode == .on {
                    device.torchMode = .off
                    isFlashOn = false
                } else {
                    try device.setTorchModeOn(level: 1.0)
                    isFlashOn = true
                }
            }
            
            device.unlockForConfiguration()
        } catch {
            print("Flash control failed")
        }
    }
    
    func switchCamera() {
        stopSession()
        currentCamera = currentCamera == .back ? .front : .back
        setupSession(mode: photoOutput != nil ? .photo : .video)
    }
    
    func capture(completion: @escaping (Result<URL, VeoCameraError>) -> Void) {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        
        if let photoOutput = photoOutput {
            let settings = AVCapturePhotoSettings()
            settings.flashMode = isFlashOn ? .on : .off
            
            let delegate = PhotoCaptureDelegate(tempURL: tempURL, completion: completion)
            photoOutput.capturePhoto(with: settings, delegate: delegate)
        } else if let videoOutput = videoOutput {
            if isRecording {
                videoOutput.stopRecording()
                isRecording = false
            } else {
                /*videoOutput.startRecording(to: tempURL, recordingDelegate: VideoCaptureDelegate { url in
                    completion(.success(url))
                })
                isRecording = true*/
            }
        }
    }
}

class PhotoCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    private let completion: (Result<URL, VeoCameraError>) -> Void
    private let tempURL: URL
    
    init(tempURL: URL, completion: @escaping (Result<URL, VeoCameraError>) -> Void) {
        self.tempURL = tempURL
        self.completion = completion
        super.init()
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            completion(.failure(.captureError))
            return
        }
        
        guard let data = photo.fileDataRepresentation() else {
            completion(.failure(.captureError))
            return
        }
        
        do {
            try data.write(to: tempURL)
            completion(.success(tempURL))
        } catch {
            completion(.failure(.saveFailed))
        }
    }
}

#Preview {
    FontLoader.loadFonts()
    
    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        primaryDarkColor: Color(hex: "#c0392b"),
        mainFont: "Rubik-Regular"
    )
    
    struct VeoCameraPreview: View {
        @State private var showCamera = false
        @State private var capturedImage: UIImage?
        @State private var cameraMode: VeoCameraMode = .photo
        
        var body: some View {
            VStack(spacing: 20) {
                if let image = capturedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                }
                
                Picker("Camera Mode", selection: $cameraMode) {
                    Text("Photo").tag(VeoCameraMode.photo)
                    Text("Video").tag(VeoCameraMode.video)
                }
                .pickerStyle(.segmented)
                .padding()
                
                VeoButton(
                    title: "Open Camera"
                    // icon: .common(.camera)
                ) {
                    showCamera = true
                }
            }
            .sheet(isPresented: $showCamera) {
                VeoCamera(
                    mode: cameraMode,
                    onCapture: { result in
                        switch result {
                        case .success(let url):
                            if cameraMode == .photo {
                                capturedImage = UIImage(contentsOfFile: url.path)
                            }
                            showCamera = false
                        case .failure(let error):
                            print("Capture failed: \(error)")
                        }
                    },
                    onDismiss: {
                        showCamera = false
                    }
                )
            }
        }
    }
    
    return VeoCameraPreview()
}
