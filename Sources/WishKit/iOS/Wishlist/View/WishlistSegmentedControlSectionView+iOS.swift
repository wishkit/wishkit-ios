#if os(iOS)
import SwiftUI
import WishKitShared

struct WishlistSegmentedControlSectionView: View {
    
    @Binding
    var selectedWishState: LocalWishState
    
    let feedbackStateSelection: [LocalWishState]
    
    let countProvider: (LocalWishState) -> Int
    
    var body: some View {
        Spacer(minLength: 15)
        Picker("", selection: $selectedWishState) {
            ForEach(feedbackStateSelection, id: \.self) { state in
                Text("\(state.description) (\(countProvider(state)))")
                    .tag(state)
            }
        }
    }
}
#endif
