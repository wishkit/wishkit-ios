#if os(macOS)
import SwiftUI

/// Removes default background color and allows custom color for TextEditor
extension NSTextView {
    open override var frame: CGRect {
        didSet {
            backgroundColor = .clear
            drawsBackground = true
        }
    }
}
#endif
