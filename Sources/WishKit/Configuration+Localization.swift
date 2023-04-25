//
//  Configuration+Localization.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 4/13/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

extension Configuration {

    public struct Localizaton {

        public var requested: String

        public var pending: String

        public var approved: String

        public var implemented: String

        public var wishlist: String

        public var save: String

        public var title: String

        public var description: String

        public var upvote: String

        public var info: String

        public var youCanOnlyVoteOnce: String

        public var youCanNotVoteForAnImplementedWish: String

        public var youCanNotVoteForYourOwnWish: String

        public var poweredBy: String

        public var successfullyCreated: String

        public var done: String

        public var detail: String

        public var featureWishlist: String

        public var confirm: String

        public var cancel: String

        public var ok: String

        public var titleOfWish: String

        public var titleDescriptionCannotBeEmpty: String

        public var votes: String

        public var close: String

        public var createWish: String

        public init(
            requested: String = Localizaton.default().requested,
            pending: String = Localizaton.default().pending,
            approved: String = Localizaton.default().approved,
            implemented: String = Localizaton.default().implemented,
            wishlist: String = Localizaton.default().wishlist,
            save: String = Localizaton.default().save,
            title: String = Localizaton.default().title,
            description: String = Localizaton.default().description,
            upvote: String = Localizaton.default().upvote,
            info: String = Localizaton.default().info,
            youCanOnlyVoteOnce: String = Localizaton.default().youCanOnlyVoteOnce,
            youCanNotVoteForAnImplementedWish: String = Localizaton.default().youCanNotVoteForAnImplementedWish,
            youCanNotVoteForYourOwnWish: String = Localizaton.default().youCanNotVoteForYourOwnWish,
            poweredBy: String = Localizaton.default().poweredBy,
            successfullyCreated: String = Localizaton.default().successfullyCreated,
            done: String = Localizaton.default().done,
            detail: String = Localizaton.default().detail,
            featureWishlist: String = Localizaton.default().featureWishlist,
            confirm: String = Localizaton.default().confirm,
            cancel: String = Localizaton.default().cancel,
            ok: String = Localizaton.default().ok,
            titleOfWish: String = Localizaton.default().titleOfWish,
            titleDescriptionCannotBeEmpty: String = Localizaton.default().titleDescriptionCannotBeEmpty,
            votes: String = Localizaton.default().votes,
            close: String = Localizaton.default().close,
            createWish: String = Localizaton.default().createWish
        ) {
            self.requested = requested
            self.pending = pending
            self.approved = approved
            self.implemented = implemented
            self.wishlist = wishlist
            self.save = save
            self.title = title
            self.description = description
            self.upvote = upvote
            self.info = info
            self.youCanOnlyVoteOnce = youCanOnlyVoteOnce
            self.youCanNotVoteForAnImplementedWish = youCanNotVoteForAnImplementedWish
            self.youCanNotVoteForYourOwnWish = youCanNotVoteForYourOwnWish
            self.poweredBy = poweredBy
            self.successfullyCreated = successfullyCreated
            self.done = done
            self.detail = detail
            self.featureWishlist = featureWishlist
            self.confirm = confirm
            self.cancel = cancel
            self.ok = ok
            self.titleOfWish = titleOfWish
            self.titleDescriptionCannotBeEmpty = titleDescriptionCannotBeEmpty
            self.votes = votes
            self.close = close
            self.createWish = createWish
        }

        public static func `default`() -> Localizaton {
            Localizaton(
                requested: "Requested",
                pending: "Pending",
                approved: "Approved",
                implemented: "Implemented",
                wishlist: "Wishlist",
                save: "Save",
                title: "Title",
                description: "Description",
                upvote: "Upvote",
                info: "Info",
                youCanOnlyVoteOnce: "You can only vote once.",
                youCanNotVoteForAnImplementedWish: "You can not vote for a wish that is already implemented.",
                youCanNotVoteForYourOwnWish: "You cannot vote for your own wish.",
                poweredBy: "Powered by",
                successfullyCreated: "Successfully created",
                done: "Done",
                detail: "Detail",
                featureWishlist: "Feature Wishlist",
                confirm: "Confirm",
                cancel: "Cancel",
                ok: "Ok",
                titleOfWish: "Title of the wish..",
                titleDescriptionCannotBeEmpty: "Title/Description cannot be empty.",
                votes: "Votes",
                close: "Close",
                createWish: "Create Wish"
            )
        }
    }
}
