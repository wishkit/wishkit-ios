//
//  Configuration+Localization.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 4/13/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

extension Configuration {

    public struct Localization {

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

        public var optional: String

        public var required: String

        public var emailRequiredText: String

        public var emailFormatWrongText: String

        public var comments: String

        public var writeAComment: String

        public var admin: String

        public var user: String

        public var noFeatureRequests: String

        public var emailOptional: String

        public var emailRequired: String

        public init(
            requested: String = Localization.default().requested,
            pending: String = Localization.default().pending,
            approved: String = Localization.default().approved,
            implemented: String = Localization.default().implemented,
            wishlist: String = Localization.default().wishlist,
            save: String = Localization.default().save,
            title: String = Localization.default().title,
            description: String = Localization.default().description,
            upvote: String = Localization.default().upvote,
            info: String = Localization.default().info,
            youCanOnlyVoteOnce: String = Localization.default().youCanOnlyVoteOnce,
            youCanNotVoteForAnImplementedWish: String = Localization.default().youCanNotVoteForAnImplementedWish,
            youCanNotVoteForYourOwnWish: String = Localization.default().youCanNotVoteForYourOwnWish,
            poweredBy: String = Localization.default().poweredBy,
            successfullyCreated: String = Localization.default().successfullyCreated,
            done: String = Localization.default().done,
            detail: String = Localization.default().detail,
            featureWishlist: String = Localization.default().featureWishlist,
            confirm: String = Localization.default().confirm,
            cancel: String = Localization.default().cancel,
            ok: String = Localization.default().ok,
            titleOfWish: String = Localization.default().titleOfWish,
            titleDescriptionCannotBeEmpty: String = Localization.default().titleDescriptionCannotBeEmpty,
            votes: String = Localization.default().votes,
            close: String = Localization.default().close,
            createWish: String = Localization.default().createWish,
            optional: String = Localization.default().optional,
            required: String = Localization.default().required,
            emailRequiredText: String = Localization.default().emailRequiredText,
            emailFormatWrongText: String = Localization.default().emailFormatWrongText,
            comments: String = Localization.default().comments,
            writeAComment: String = Localization.default().writeAComment,
            admin: String = Localization.default().admin,
            user: String = Localization.default().user,
            noFeatureRequests: String = Localization.default().noFeatureRequests,
            emailOptional: String = Localization.default().emailOptional,
            emailRequired: String = Localization.default().emailRequired
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
            self.optional = optional
            self.required = required
            self.emailRequiredText = emailRequiredText
            self.emailFormatWrongText = emailFormatWrongText
            self.comments = comments
            self.writeAComment = writeAComment
            self.admin = admin
            self.user = user
            self.noFeatureRequests = noFeatureRequests
            self.emailOptional = emailOptional
            self.emailRequired = emailRequired
        }

        public static func `default`() -> Localization {
            Localization(
                requested: "Requested",
                pending: "Pending",
                approved: "Approved",
                implemented: "Implemented",
                wishlist: "Feature Requests",
                save: "Save",
                title: "Title",
                description: "Description",
                upvote: "Upvote",
                info: "Info",
                youCanOnlyVoteOnce: "You can only vote once.",
                youCanNotVoteForAnImplementedWish: "You can not vote for a feature that is already implemented.",
                youCanNotVoteForYourOwnWish: "You cannot vote for your own feature request.",
                poweredBy: "Powered by",
                successfullyCreated: "Successfully created",
                done: "Done",
                detail: "Detail",
                featureWishlist: "Feature Requests",
                confirm: "Confirm",
                cancel: "Cancel",
                ok: "Ok",
                titleOfWish: "Title of the feature..",
                titleDescriptionCannotBeEmpty: "Title/Description cannot be empty.",
                votes: "Votes",
                close: "Close",
                createWish: "Create Feature",
                optional: "optional",
                required: "required",
                emailRequiredText: "Please enter your email address.",
                emailFormatWrongText: "Wrong email format.",
                comments: "Comments",
                writeAComment: "Write a comment..",
                admin: "Admin",
                user: "User",
                noFeatureRequests: "No feature requests, yet ✨",
                emailOptional: "Email (optional)",
                emailRequired: "Email (required)"
            )
        }
    }
}
