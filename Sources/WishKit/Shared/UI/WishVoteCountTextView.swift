import SwiftUI

struct WishVoteCountTextView: View {

    let voteCount: Int

    let textColor: Color

    let voteCountScale: CGFloat

    var body: some View {
        let base = Text(String(describing: voteCount))
            .font(.footnote.weight(.semibold))
            .foregroundColor(textColor)
            .frame(minWidth: 35)
            .scaleEffect(voteCountScale)

        if #available(iOS 17.0, macOS 14.0, *) {
            base.contentTransition(.numericText(value: Double(voteCount)))
        } else {
            base
        }
    }
}
