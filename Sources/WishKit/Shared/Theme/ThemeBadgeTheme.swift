import SwiftUI

public struct ThemeBadgeTheme {

    public var pending: ThemeScheme

    public var inReview: ThemeScheme

    public var planned: ThemeScheme

    public var inProgress: ThemeScheme

    public var completed: ThemeScheme

    public var rejected: ThemeScheme

    init(
        pending: ThemeScheme,
        inReview: ThemeScheme,
        planned: ThemeScheme,
        inProgress: ThemeScheme,
        completed: ThemeScheme,
        rejected: ThemeScheme
    ) {
        self.pending = pending
        self.inReview = inReview
        self.planned = planned
        self.inProgress = inProgress
        self.completed = completed
        self.rejected = rejected
    }

    static func `default`() -> ThemeBadgeTheme {
        ThemeBadgeTheme(
            pending: .setBoth(to: .yellow),
            inReview: .setBoth(to: Color(red: 1 / 255, green: 255 / 255, blue: 255 / 255)),
            planned: .setBoth(to: .purple),
            inProgress: .setBoth(to: .blue),
            completed: .setBoth(to: .green),
            rejected: .setBoth(to: .red)
        )
    }
}
