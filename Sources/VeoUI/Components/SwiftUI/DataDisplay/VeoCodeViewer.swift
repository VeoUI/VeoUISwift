//
//  VeoCodeViewer.swift
//  VeoUI
//
//  Created by Yassine Lafryhi on 3/1/2025.
//

import SwiftUI

struct VeoCodeViewer: View {
    let code: String
    let language: CodeLanguage
    @State private var isCopied: Bool = false
    
    enum CodeLanguage: String {
        case swift
        case python
        case javascript
        case java
        case cpp = "c++"
        case rust
        case go
        case typescript
        case kotlin
        case ruby
        
        var highlightRules: [HighlightRule] {
            switch self {
            case .swift:
                return [
                    HighlightRule(pattern: "\\b(class|struct|enum|func|var|let|if|else|guard|switch|case|default|for|while|do|try|catch|throws|throw|return|break|continue|import|protocol|extension|where|associatedtype|typealias|init)\\b", color: .purple),
                    HighlightRule(pattern: "\\b(String|Int|Double|Bool|Array|Dictionary|Set|Character|Float|Any|AnyObject)\\b", color: .blue),
                    HighlightRule(pattern: "//.*", color: .green),
                    HighlightRule(pattern: "/\\*.*?\\*/", color: .green, options: [.dotMatchesLineSeparators]),
                    HighlightRule(pattern: "\".*?\"", color: .red),
                    HighlightRule(pattern: "\\b\\d+(\\.\\d+)?\\b", color: .orange)
                ]
            case .python:
                return [
                    HighlightRule(pattern: "\\b(def|class|if|else|elif|for|while|try|except|finally|with|as|import|from|return|yield|break|continue|pass|raise|assert|del|global|nonlocal|lambda|not|is|in)\\b", color: .purple),
                    HighlightRule(pattern: "\\b(str|int|float|bool|list|dict|set|tuple|None|True|False)\\b", color: .blue),
                    HighlightRule(pattern: "#.*", color: .green),
                    HighlightRule(pattern: "\"\"\".*?\"\"\"", color: .green, options: [.dotMatchesLineSeparators]),
                    HighlightRule(pattern: "\".*?\"", color: .red),
                    HighlightRule(pattern: "'.*?'", color: .red),
                    HighlightRule(pattern: "\\b\\d+(\\.\\d+)?\\b", color: .orange)
                ]
            case .javascript, .typescript:
                return [
                    HighlightRule(pattern: "\\b(function|class|const|let|var|if|else|for|while|do|try|catch|return|break|continue|import|export|default|extends|implements|interface|type|namespace)\\b", color: .purple),
                    HighlightRule(pattern: "\\b(string|number|boolean|null|undefined|Symbol|BigInt|any|void|never)\\b", color: .blue),
                    HighlightRule(pattern: "//.*", color: .green),
                    HighlightRule(pattern: "/\\*.*?\\*/", color: .green, options: [.dotMatchesLineSeparators]),
                    HighlightRule(pattern: "\".*?\"", color: .red),
                    HighlightRule(pattern: "'.*?'", color: .red),
                    HighlightRule(pattern: "`.*?`", color: .red, options: [.dotMatchesLineSeparators]),
                    HighlightRule(pattern: "\\b\\d+(\\.\\d+)?\\b", color: .orange)
                ]
            default:
                return []
            }
        }
    }
    
    struct HighlightRule {
        let pattern: String
        let color: Color
        var options: NSRegularExpression.Options = []
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(language.rawValue.capitalized)
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: copyToClipboard) {
                    HStack(spacing: 4) {
                        Image(systemName: isCopied ? "checkmark.circle.fill" : "doc.on.doc")
                            .imageScale(.medium)
                        Text(isCopied ? "Copied!" : "Copy")
                            .font(.subheadline)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(8)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(attributedCode)
                        .font(.system(.body, design: .monospaced))
                        .textSelection(.enabled)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .background(Color.secondary.opacity(0.05))
            .cornerRadius(VeoUI.defaultCornerRadius)
        }
        .padding()
    }
    
    private func copyToClipboard() {
        UIPasteboard.general.string = code
        withAnimation {
            isCopied = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                isCopied = false
            }
        }
    }
    
    private var attributedCode: AttributedString {
        var attributed = AttributedString(code)
        
        for rule in language.highlightRules {
            guard let regex = try? NSRegularExpression(pattern: rule.pattern, options: rule.options) else {
                continue
            }
            
            let nsRange = NSRange(location: 0, length: code.utf16.count)
            let matches = regex.matches(in: code, range: nsRange)
            
            for match in matches.reversed() {
                let lowerBound = String.Index(utf16Offset: match.range.location, in: code)
                let upperBound = String.Index(utf16Offset: match.range.location + match.range.length, in: code)
                
                let startIndex = attributed.index(attributed.startIndex, offsetByCharacters: code.distance(from: code.startIndex, to: lowerBound))
                
                let endIndex = attributed.index(attributed.startIndex, offsetByCharacters: code.distance(from: code.startIndex, to: upperBound))
            let attributedRange = Range<AttributedString.Index>(uncheckedBounds: (startIndex, endIndex))
                    attributed[attributedRange].foregroundColor = rule.color
            }
        }
        
        return attributed
    }
}

#Preview {
    VeoCodeViewer(code: """
    func quickSort<T: Comparable>(_ array: [T]) -> [T] {
        guard array.count > 1 else { return array }
        
        let pivot = array[array.count / 2]
        let less = array.filter { $0 < pivot }
        let equal = array.filter { $0 == pivot }
        let greater = array.filter { $0 > pivot }
        
        return quickSort(less) + equal + quickSort(greater)
    }
    
    // Example usage
    let numbers = [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5]
    let sorted = quickSort(numbers)
    print(sorted) // [1, 1, 2, 3, 3, 4, 5, 5, 5, 6, 9]
    """, language: .swift)
}
