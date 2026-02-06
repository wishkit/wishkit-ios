//
//  PollListView.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/5/26.
//

#if os(iOS)
import SwiftUI

struct InternalPollView: View {
    
    @EnvironmentObject
    var pollModel: WishKit.PollModel
    
    var body: some View {
        Group {
            if pollModel.shouldShowPoll, let pollResponse = pollModel.pollResponse {
                Text(pollResponse.title)
            } else {
                Text("There's no active poll at this time. Check back again later.")
            }
        }.task {
            await pollModel.fetchActivePoll()
        }
    }
}

extension PollResponse: Identifiable { }

#endif
