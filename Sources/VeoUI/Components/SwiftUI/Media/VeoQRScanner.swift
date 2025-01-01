//
//  VeoQRScanner.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 1/1/2025.
//

import SwiftUI
import AVFoundation

public enum QRScannerError: Error {
    case invalidDeviceInput
    case invalidCaptureOutput
    case cameraAccessDenied
    case cameraUnavailable
}

public enum QRScannerResult {
    case success(String)
    case failure(QRScannerError)
}

public class QRScannerCoordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    var parent: VeoQRScanner
    var didFindCode: ((String) -> Void)?
    
    init(parent: VeoQRScanner, didFindCode: ((String) -> Void)?) {
        self.parent = parent
        self.didFindCode = didFindCode
    }
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput,
                             didOutput metadataObjects: [AVMetadataObject],
                             from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = metadataObject.stringValue {
            didFindCode?(stringValue)
        }
    }
}

public struct QRCameraPreviewLayer: UIViewRepresentable {
    let previewLayer: AVCaptureVideoPreviewLayer
    
    public func makeUIView(context: Context) -> UIView {
        let view = UIView()
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        return view
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {
        previewLayer.frame = uiView.bounds
    }
}

public struct VeoQRScanner: View {
    @StateObject private var viewModel = QRScannerViewModel()
    var onResult: (QRScannerResult) -> Void
    var scannerOverlay: ScannerOverlay
    var torchEnabled: Bool
    var vibrateOnSuccess: Bool
    
    public init(
        onResult: @escaping (QRScannerResult) -> Void,
        scannerOverlay: ScannerOverlay = .default,
        torchEnabled: Bool = false,
        vibrateOnSuccess: Bool = true
    ) {
        self.onResult = onResult
        self.scannerOverlay = scannerOverlay
        self.torchEnabled = torchEnabled
        self.vibrateOnSuccess = vibrateOnSuccess
    }
    
    public var body: some View {
        ZStack {
            if let previewLayer = viewModel.previewLayer {
                QRCameraPreviewLayer(previewLayer: previewLayer)
                    .ignoresSafeArea()
            }
            
            scannerOverlayView
            
            if let error = viewModel.error {
                errorView(error)
            }
            
            VStack {
                Spacer()
                controlsView
            }
            .padding()
        }
        .onAppear {
            viewModel.startScanning { result in
                handleScanResult(result)
            }
        }
        .onDisappear {
            viewModel.stopScanning()
        }
    }
    
    private var scannerOverlayView: some View {
        GeometryReader { geometry in
            switch scannerOverlay {
            case .default:
                defaultOverlay(in: geometry)
            case .corners:
                cornersOverlay(in: geometry)
            case .none:
                EmptyView()
            }
        }
    }
    
    private func defaultOverlay(in geometry: GeometryProxy) -> some View {
        let size = min(geometry.size.width, geometry.size.height) * 0.7
        
        return RoundedRectangle(cornerRadius: 12)
            .stroke(VeoUI.primaryColor, lineWidth: 3)
            .frame(width: size, height: size)
            .padding()
            .background(
                Color.black.opacity(0.5)
                    .mask(defaultOverlayMask(in: geometry, size: size))
            )
    }
    
    private func defaultOverlayMask(in geometry: GeometryProxy, size: CGFloat) -> some View {
        Rectangle()
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: size, height: size)
                    .blendMode(.destinationOut)
            )
            .compositingGroup()
    }
    
    private func cornersOverlay(in geometry: GeometryProxy) -> some View {
        let size = min(geometry.size.width, geometry.size.height) * 0.7
        let cornerSize: CGFloat = 20
        
        return ZStack {
            Color.black.opacity(0.5)
                .mask(defaultOverlayMask(in: geometry, size: size))
            
            VStack {
                HStack {
                    cornerPath(cornerSize: cornerSize)
                    Spacer()
                    cornerPath(cornerSize: cornerSize)
                        .rotation3DEffect(.degrees(90), axis: (x: 0, y: 0, z: 1))
                }
                Spacer()
                HStack {
                    cornerPath(cornerSize: cornerSize)
                        .rotation3DEffect(.degrees(-90), axis: (x: 0, y: 0, z: 1))
                    Spacer()
                    cornerPath(cornerSize: cornerSize)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 0, z: 1))
                }
            }
            .frame(width: size, height: size)
            .foregroundColor(VeoUI.primaryColor)
        }
    }
    
    private func cornerPath(cornerSize: CGFloat) -> some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: cornerSize))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: cornerSize, y: 0))
        }
        .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
    }
    
    private var controlsView: some View {
        HStack {
            if torchEnabled {
                Button(action: viewModel.toggleTorch) {
                    VeoIcon(
                        icon: .system(viewModel.isTorchOn ? "flashlight.on.fill" : "flashlight.off.fill"),
                        color: .white
                    )
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .clipShape(Circle())
                }
            }
            
            Spacer()
            
            Button(action: viewModel.switchCamera) {
                VeoIcon(
                    icon: .system("camera.rotate.fill"),
                    color: .white
                )
                .padding()
                .background(Color.black.opacity(0.3))
                .clipShape(Circle())
            }
        }
    }
    
    private func errorView(_ error: QRScannerError) -> some View {
        VStack(spacing: 16) {
            VeoIcon(icon: .common(.error), size: 48, color: VeoUI.dangerColor)
            
            VeoText(errorMessage(for: error), style: .headline)
                .multilineTextAlignment(.center)
            
            VeoButton(
                title: "Open Settings",
                style: .primary
            ) {
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
    
    private func errorMessage(for error: QRScannerError) -> String {
        switch error {
        case .cameraAccessDenied:
            return "Camera access is denied. Please enable it in Settings."
        case .cameraUnavailable:
            return "Camera is not available on this device."
        case .invalidDeviceInput:
            return "Unable to capture video input."
        case .invalidCaptureOutput:
            return "Unable to capture video output."
        }
    }
    
    private func handleScanResult(_ result: QRScannerResult) {
        if vibrateOnSuccess, case .success = result {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
        onResult(result)
    }
}

public enum ScannerOverlay {
    case `default`
    case corners
    case none
}

class QRScannerViewModel: ObservableObject {
    @Published var error: QRScannerError?
    @Published var isTorchOn = false
    
    private var captureSession: AVCaptureSession?
    private var currentCamera: AVCaptureDevice.Position = .back
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    @MainActor
    func startScanning(completion: @escaping (QRScannerResult) -> Void) {
        checkCameraPermission { [weak self] granted in
            if granted {
                self?.setupCaptureSession(completion: completion)
            } else {
                self?.error = .cameraAccessDenied
            }
        }
    }
    
    func stopScanning() {
        captureSession?.stopRunning()
    }
    
    func toggleTorch() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            try device.lockForConfiguration()
            
            if device.hasTorch {
                if device.torchMode == .on {
                    device.torchMode = .off
                    isTorchOn = false
                } else {
                    try device.setTorchModeOn(level: 1.0)
                    isTorchOn = true
                }
            }
            
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used")
        }
    }
    
    @MainActor
    func switchCamera() {
        stopScanning()
        currentCamera = currentCamera == .back ? .front : .back
        setupCaptureSession { _ in }
    }
    
    @MainActor
    private func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                    completion(granted)
            }
        default:
            completion(false)
        }
    }
    
    @MainActor private func setupCaptureSession(completion: @escaping (QRScannerResult) -> Void) {
        let session = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                              for: .video,
                                                              position: currentCamera)
        else {
            error = .cameraUnavailable
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            
            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
            } else {
                error = .invalidDeviceInput
                return
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if session.canAddOutput(metadataOutput) {
                session.addOutput(metadataOutput)
                
                let coordinator = QRScannerCoordinator(parent: VeoQRScanner(onResult: completion)) { code in
                    completion(.success(code))
                }
                
                metadataOutput.setMetadataObjectsDelegate(coordinator, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr]
            } else {
                error = .invalidCaptureOutput
                return
            }
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            self.previewLayer = previewLayer
            
            Task { @MainActor in
                session.startRunning()
            }
            
            self.captureSession = session
            
        } catch {
            self.error = .invalidDeviceInput
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
    
    struct VeoQRScannerPreview: View {
        @State private var scannedCode: String?
        @State private var showingScanner = false
        
        var body: some View {
            VStack(spacing: 20) {
                if let code = scannedCode {
                    VStack(spacing: 16) {
                        VeoIcon(icon: .common(.success), size: 48, color: .green)
                        VeoText("Scanned Code:", style: .headline)
                        VeoText(code, style: .body)
                    }
                    .padding()
                }
                
                VeoButton(
                    title: "Scan QR Code"
                    //icon: .common(.camera)
                ) {
                    showingScanner = true
                }
                .padding()
            }
            .sheet(isPresented: $showingScanner) {
                VeoQRScanner(
                    onResult: { result in
                        switch result {
                        case .success(let code):
                            scannedCode = code
                            showingScanner = false
                        case .failure(let error):
                            print("Scanning failed: \(error)")
                        }
                    },
                    scannerOverlay: .corners,
                    torchEnabled: true
                )
            }
        }
    }
    
    return VeoQRScannerPreview()
}
