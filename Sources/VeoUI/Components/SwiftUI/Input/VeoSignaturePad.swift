//
//  VeoSignaturePad.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 1/1/2025.
//

import SwiftUI
import PencilKit

public struct VeoSignaturePad: View {
    @Binding var signature: UIImage?
    
    var strokeColor: Color = .black
    var strokeWidth: CGFloat = 3
    var backgroundColor: Color = .white
    var cornerRadius: CGFloat = 12
    var placeholder: String = "Sign Here"
    
    @State private var canvasView = PKCanvasView()
    @State private var isEditing = false
    @State private var showingClearAlert = false
    
    public init(
        signature: Binding<UIImage?>,
        strokeColor: Color = .black,
        strokeWidth: CGFloat = 3,
        backgroundColor: Color = .white,
        cornerRadius: CGFloat = 12,
        placeholder: String = "Sign Here"
    ) {
        self._signature = signature
        self.strokeColor = strokeColor
        self.strokeWidth = strokeWidth
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.placeholder = placeholder
        
        canvasView.backgroundColor = .clear
        canvasView.tool = PKInkingTool(.pen, color: UIColor(strokeColor), width: strokeWidth)
        canvasView.drawingPolicy = .anyInput
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            SignatureCanvasWrapper(
                canvasView: canvasView,
                isEditing: $isEditing
            )
            .frame(height: 200)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .overlay(
                Group {
                    if !isEditing {
                        Text(placeholder)
                            .foregroundColor(.gray)
                    }
                }
            )
            
            HStack(spacing: 16) {
                clearButton
                saveButton
            }
        }
    }
    
    private var clearButton: some View {
        Button {
            if isEditing {
                clearSignature()
            }
        } label: {
            HStack {
                VeoIcon(icon: .common(.delete), color: .red)
                VeoText("Clear", style: .body, color: .red)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color.red.opacity(0.1))
            .cornerRadius(8)
        }
        .disabled(!isEditing)
    }
    
    private var saveButton: some View {
        Button {
            saveSignature()
        } label: {
            HStack {
                VeoIcon(icon: .common(.success), color: .white)
                VeoText("Save", style: .body, color: .white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isEditing ? VeoUI.primaryColor : Color.gray)
            .cornerRadius(8)
        }
        .disabled(!isEditing)
    }
    
    private func clearSignature() {
        canvasView.drawing = PKDrawing()
        isEditing = false
        signature = nil
    }
    
    private func saveSignature() {
        let image = canvasView.drawing.image(
            from: canvasView.bounds,
            scale: UIScreen.main.scale
        )
        signature = image
    }
}

struct SignatureCanvasWrapper: UIViewRepresentable {
    let canvasView: PKCanvasView
    @Binding var isEditing: Bool
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.delegate = context.coordinator
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        let parent: SignatureCanvasWrapper
        
        init(parent: SignatureCanvasWrapper) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            parent.isEditing = !canvasView.drawing.bounds.isEmpty
        }
    }
}

extension PKDrawing {
    func image(from rect: CGRect, scale: CGFloat = 1.0) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        let image = renderer.image { context in
            let cgContext = context.cgContext
            cgContext.setFillColor(UIColor.clear.cgColor)
            cgContext.fill(rect)
            
            self.image(from: rect, scale: scale).draw(in: rect)
        }
        return image
    }
}

#Preview {
    FontLoader.loadFonts()
    
    VeoUI.configure(
        primaryColor: Color(hex: "#e74c3c"),
        primaryDarkColor: Color(hex: "#c0392b"),
        mainFont: "Rubik-Regular"
    )
    
    struct VeoSignaturePadPreview: View {
        @State private var signature: UIImage?
        @State private var showingSignaturePad = false
        @State private var signatureStyle = 0
        
        var body: some View {
            ScrollView {
                VStack(spacing: 24) {
                    if let signature = signature {
                        VStack(spacing: 8) {
                            VeoText("Captured Signature", style: .headline)
                            Image(uiImage: signature)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                    }
                    
                    VStack(spacing: 16) {
                        VeoText("Signature Styles", style: .headline)
                        
                        Picker("Style", selection: $signatureStyle) {
                            Text("Black").tag(0)
                            Text("Blue").tag(1)
                            Text("Custom").tag(2)
                        }
                        .pickerStyle(.segmented)
                        
                        VeoSignaturePad(
                            signature: $signature,
                            strokeColor: signatureStyle == 0 ? .black :
                                       signatureStyle == 1 ? .blue :
                                       Color(hex: "#e74c3c"),
                            strokeWidth: signatureStyle == 2 ? 4 : 3,
                            backgroundColor: signatureStyle == 2 ? Color.gray.opacity(0.1) : .white
                        )
                    }
                    
                    VStack(spacing: 16) {
                        VeoText("RTL Support", style: .headline)
                        
                        VeoSignaturePad(
                            signature: $signature,
                            placeholder: "التوقيع هنا"
                        )
                        .environment(\.layoutDirection, .rightToLeft)
                    }
                }
                .padding()
            }
        }
    }
    
    return VeoSignaturePadPreview()
}
