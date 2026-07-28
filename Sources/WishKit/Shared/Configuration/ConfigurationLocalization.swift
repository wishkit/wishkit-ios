//
//  Configuration+Localization.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 4/13/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import Foundation

public struct ConfigurationLocalization {

        public var requested: String

        public var pending: String

        public var approved: String

        public var implemented: String

        public var inReview: String

        public var planned: String

        public var inProgress: String

        public var completed: String

        public var open: String

        public var closed: String

        public var wishlist: String

        public var save: String

        public var title: String

        public var description: String

        public var upvote: String

        public var info: String

        public var youCanOnlyVoteOnce: String

        public var youCanNotVoteForACompletedWish: String

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

        public var submitComment: String

        public var admin: String

        public var user: String

        public var noFeatureRequests: String

        public var emailOptional: String

        public var emailRequired: String

        public var discardEnteredInformation: String
        
        public var addButtonInNavigationBar: String

        public var refresh: String

        public var refreshing: String

        public var somethingWentWrong: String

        public var all: String

        public var notSupported: String

        public var filter: String

        public var activateToSwitchFilter: String

        public var seeTranslation: String

        public var seeOriginal: String

        public init(
            requested: String = ConfigurationLocalization.default().requested,
            pending: String = ConfigurationLocalization.default().pending,
            approved: String = ConfigurationLocalization.default().approved,
            implemented: String = ConfigurationLocalization.default().implemented,
            inReview: String = ConfigurationLocalization.default().inReview,
            planned: String = ConfigurationLocalization.default().planned,
            inProgress: String = ConfigurationLocalization.default().inProgress,
            completed: String = ConfigurationLocalization.default().completed,
            open: String = ConfigurationLocalization.default().open,
            closed: String = ConfigurationLocalization.default().closed,
            wishlist: String = ConfigurationLocalization.default().wishlist,
            save: String = ConfigurationLocalization.default().save,
            title: String = ConfigurationLocalization.default().title,
            description: String = ConfigurationLocalization.default().description,
            upvote: String = ConfigurationLocalization.default().upvote,
            info: String = ConfigurationLocalization.default().info,
            youCanOnlyVoteOnce: String = ConfigurationLocalization.default().youCanOnlyVoteOnce,
            youCanNotVoteForACompletedWish: String = ConfigurationLocalization.default().youCanNotVoteForACompletedWish,
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
            submitComment: String = ConfigurationLocalization.default().submitComment,
            admin: String = ConfigurationLocalization.default().admin,
            user: String = ConfigurationLocalization.default().user,
            noFeatureRequests: String = ConfigurationLocalization.default().noFeatureRequests,
            emailOptional: String = ConfigurationLocalization.default().emailOptional,
            emailRequired: String = ConfigurationLocalization.default().emailRequired,
            discardEnteredInformation: String = ConfigurationLocalization.default().discardEnteredInformation,
            addButtonInNavigationBar: String = ConfigurationLocalization.default().addButtonInNavigationBar,
            refresh: String = ConfigurationLocalization.default().refresh,
            refreshing: String = ConfigurationLocalization.default().refreshing,
            somethingWentWrong: String = ConfigurationLocalization.default().somethingWentWrong,
            all: String = ConfigurationLocalization.default().all,
            notSupported: String = ConfigurationLocalization.default().notSupported,
            filter: String = ConfigurationLocalization.default().filter,
            activateToSwitchFilter: String = ConfigurationLocalization.default().activateToSwitchFilter,
            seeTranslation: String = ConfigurationLocalization.default().seeTranslation,
            seeOriginal: String = ConfigurationLocalization.default().seeOriginal
        ) {
            self.requested = requested
            self.pending = pending
            self.approved = approved
            self.implemented = implemented
            self.inReview = inReview
            self.planned = planned
            self.inProgress = inProgress
            self.completed = completed
            self.open = open
            self.closed = closed
            self.wishlist = wishlist
            self.save = save
            self.title = title
            self.description = description
            self.upvote = upvote
            self.info = info
            self.youCanOnlyVoteOnce = youCanOnlyVoteOnce
            self.youCanNotVoteForACompletedWish = youCanNotVoteForACompletedWish
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
            self.submitComment = submitComment
            self.admin = admin
            self.user = user
            self.noFeatureRequests = noFeatureRequests
            self.emailOptional = emailOptional
            self.emailRequired = emailRequired
            self.discardEnteredInformation = discardEnteredInformation
            self.addButtonInNavigationBar = addButtonInNavigationBar
            self.refresh = refresh
            self.refreshing = refreshing
            self.somethingWentWrong = somethingWentWrong
            self.all = all
            self.notSupported = notSupported
            self.filter = filter
            self.activateToSwitchFilter = activateToSwitchFilter
            self.seeTranslation = seeTranslation
            self.seeOriginal = seeOriginal
        }

        /// Default values come from the bundled translations (en/de/es/zh-Hans),
        /// resolved against the host app's language. Consumer overrides always win.
        public static func `default`() -> ConfigurationLocalization {
            ConfigurationLocalization(
                requested: localized("requested"),
                pending: localized("pending"),
                approved: localized("approved"),
                implemented: localized("implemented"),
                inReview: localized("inReview"),
                planned: localized("planned"),
                inProgress: localized("inProgress"),
                completed: localized("completed"),
                open: localized("open"),
                closed: localized("closed"),
                wishlist: localized("wishlist"),
                save: localized("save"),
                title: localized("title"),
                description: localized("description"),
                upvote: localized("upvote"),
                info: localized("info"),
                youCanOnlyVoteOnce: localized("youCanOnlyVoteOnce"),
                youCanNotVoteForACompletedWish: localized("youCanNotVoteForACompletedWish"),
                youCanNotVoteForYourOwnWish: localized("youCanNotVoteForYourOwnWish"),
                poweredBy: localized("poweredBy"),
                successfullyCreated: localized("successfullyCreated"),
                done: localized("done"),
                detail: localized("detail"),
                featureWishlist: localized("featureWishlist"),
                confirm: localized("confirm"),
                cancel: localized("cancel"),
                ok: localized("ok"),
                titleOfWish: localized("titleOfWish"),
                titleDescriptionCannotBeEmpty: localized("titleDescriptionCannotBeEmpty"),
                votes: localized("votes"),
                close: localized("close"),
                createWish: localized("createWish"),
                optional: localized("optional"),
                required: localized("required"),
                emailRequiredText: localized("emailRequiredText"),
                emailFormatWrongText: localized("emailFormatWrongText"),
                comments: localized("comments"),
                writeAComment: localized("writeAComment"),
                submitComment: localized("submitComment"),
                admin: localized("admin"),
                user: localized("user"),
                noFeatureRequests: localized("noFeatureRequests"),
                emailOptional: localized("emailOptional"),
                emailRequired: localized("emailRequired"),
                discardEnteredInformation: localized("discardEnteredInformation"),
                addButtonInNavigationBar: localized("addButtonInNavigationBar"),
                refresh: localized("refresh"),
                refreshing: localized("refreshing"),
                somethingWentWrong: localized("somethingWentWrong"),
                all: localized("all"),
                notSupported: localized("notSupported"),
                filter: localized("filter"),
                activateToSwitchFilter: localized("activateToSwitchFilter"),
                seeTranslation: localized("seeTranslation"),
                seeOriginal: localized("seeOriginal")
            )
        }

        private static func localized(_ key: String) -> String {
            NSLocalizedString(key, bundle: .module, comment: "")
        }
    }
