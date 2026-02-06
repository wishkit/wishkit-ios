//
//  WishKit+Poll.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/5/26.
//

import Combine

extension WishKit {
    
    @MainActor
    public final class PollModel: ObservableObject {
        
        @Published
        public var shouldShowPoll = false
        
        @Published
        internal var pollResponse: PollResponse? = nil
        
        public init() {
            Task {
                await fetchActivePoll()
            }
        }
        
        internal func fetchActivePoll() async {
            let response = await PollApi.fetchActive()
            
            switch response {
            case .success(let activePollResponse):
                if let activePoll = activePollResponse.activePoll {
                    self.pollResponse = activePoll
                    self.shouldShowPoll = true
                }
            case .failure(let error):
                return
            }
        }
    }
}
