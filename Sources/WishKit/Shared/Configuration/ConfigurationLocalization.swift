//
//  Configuration+Localization.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 4/13/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

public struct ConfigurationLocalization {

        public var requested: String

        public var pending: String

        public var approved: String

        public var implemented: String

        public var inReview: String

        public var planned: String

        public var inProgress: String

        public var completed: String

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

        public var discardEnteredInformation: String
        
        public var addButtonInNavigationBar: String

        public var refresh: String

        public var refreshing: String

        public init(
            requested: String = ConfigurationLocalization.default().requested,
            pending: String = ConfigurationLocalization.default().pending,
            approved: String = ConfigurationLocalization.default().approved,
            implemented: String = ConfigurationLocalization.default().implemented,
            inReview: String = ConfigurationLocalization.default().inReview,
            planned: String = ConfigurationLocalization.default().planned,
            inProgress: String = ConfigurationLocalization.default().inProgress,
            completed: String = ConfigurationLocalization.default().completed,
            wishlist: String = ConfigurationLocalization.default().wishlist,
            save: String = ConfigurationLocalization.default().save,
            title: String = ConfigurationLocalization.default().title,
            description: String = ConfigurationLocalization.default().description,
            upvote: String = ConfigurationLocalization.default().upvote,
            info: String = ConfigurationLocalization.default().info,
            youCanOnlyVoteOnce: String = ConfigurationLocalization.default().youCanOnlyVoteOnce,
            youCanNotVoteForAnImplementedWish: String = ConfigurationLocalization.default().youCanNotVoteForAnImplementedWish,
            youCanNotVoteForYourOwnWish: String = ConfigurationLocalization.default().youCanNotVoteForYourOwnWish,
            poweredBy: String = ConfigurationLocalization.default().poweredBy,
            successfullyCreated: String = ConfigurationLocalization.default().successfullyCreated,
            done: String = ConfigurationLocalization.default().done,
            detail: String = ConfigurationLocalization.default().detail,
            featureWishlist: String = ConfigurationLocalization.default().featureWishlist,
            confirm: String = ConfigurationLocalization.default().confirm,
            cancel: String = ConfigurationLocalization.default().cancel,
            ok: String = ConfigurationLocalization.default().ok,
            titleOfWish: String = ConfigurationLocalization.default().titleOfWish,
            titleDescriptionCannotBeEmpty: String = ConfigurationLocalization.default().titleDescriptionCannotBeEmpty,
            votes: String = ConfigurationLocalization.default().votes,
            close: String = ConfigurationLocalization.default().close,
            createWish: String = ConfigurationLocalization.default().createWish,
            optional: String = ConfigurationLocalization.default().optional,
            required: String = ConfigurationLocalization.default().required,
            emailRequiredText: String = ConfigurationLocalization.default().emailRequiredText,
            emailFormatWrongText: String = ConfigurationLocalization.default().emailFormatWrongText,
            comments: String = ConfigurationLocalization.default().comments,
            writeAComment: String = ConfigurationLocalization.default().writeAComment,
            admin: String = ConfigurationLocalization.default().admin,
            user: String = ConfigurationLocalization.default().user,
            noFeatureRequests: String = ConfigurationLocalization.default().noFeatureRequests,
            emailOptional: String = ConfigurationLocalization.default().emailOptional,
            emailRequired: String = ConfigurationLocalization.default().emailRequired,
            discardEnteredInformation: String = ConfigurationLocalization.default().discardEnteredInformation,
            addButtonInNavigationBar: String = ConfigurationLocalization.default().addButtonInNavigationBar,
            refresh: String = ConfigurationLocalization.default().refresh,
            refreshing: String = ConfigurationLocalization.default().refreshing
        ) {
            self.requested = requested
            self.pending = pending
            self.approved = approved
            self.implemented = implemented
            self.inReview = inReview
            self.planned = planned
            self.inProgress = inProgress
            self.completed = completed
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
            self.discardEnteredInformation = discardEnteredInformation
            self.addButtonInNavigationBar = addButtonInNavigationBar
            self.refresh = refresh
            self.refreshing = refreshing
        }

        public static func `default`() -> ConfigurationLocalization {
            ConfigurationLocalization(
                requested: "Requested",
                pending: "Pending",
                approved: "Approved",
                implemented: "Completed",
                inReview: "In Review",
                planned: "Planned",
                inProgress: "In Progress",
                completed: "Completed",
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
                emailRequired: "Email (required)",
                discardEnteredInformation: "Discard entered information?",
                addButtonInNavigationBar: "Create",
                refresh: "Refresh",
                refreshing: "Refreshing.."
            )
        }
    }
