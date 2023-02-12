//
//  WishVM.swift
//  wishkit-ios
//
//  Created by Martin Lasek on 2/10/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//


import UIKit
import WishKitShared

final class WishVM: NSObject {

    private var approvedWishList: [WishResponse] = []

    private var implementedWishList: [WishResponse] = []

    private var currentListKind: WishListVC.Kind = .requested

    weak var delegate: WishVMDelegate?

    private func setApprovedWishlist(using response: ListWishResponse) {
        let userUUID = UUIDManager.getUUID()

        // Only list wishes that are either approved or the user created himself.
        var list = response.list.filter { wish in
            (wish.state == .pending && wish.userUUID == userUUID) ||
            wish.state == .approved
        }

        list.sort { $0.votingUsers.count > $1.votingUsers.count }

        self.approvedWishList = list
    }

    private func setImplementedWishlist(using response: ListWishResponse) {
        // Only list wishes that are implemented.
        var list = response.list.filter { wish in wish.state == .implemented }
        list.sort { $0.votingUsers.count > $1.votingUsers.count }

        self.implementedWishList = list
    }
}

// MARK: - Network

extension WishVM {
    func fetchWishList() {
        WishApi.fetchWishList { response in
            DispatchQueue.main.async {
                switch response {
                case .success(let listResponse):
                    self.handleFetchSuccess(response: listResponse)
                case .failure(let error):
                    self.handleFetchFailure(error: error)
                }
            }
        }
    }

    private func handleFetchSuccess(response: ListWishResponse) {
        setApprovedWishlist(using: response)
        setImplementedWishlist(using: response)

        guard let delegate = delegate else {
            printError(self, "Delegate is missing.")
            return
        }

        delegate.listWasUpdated()
    }

    private func handleFetchFailure(error: ApiError.Kind) {
        guard let delegate = delegate, let vc = delegate as? UIViewController else {
            printError(self, "Delegate is missing.")
            return
        }

        AlertManager.confirmMessage(on: vc, message: error.description)
    }
}

// MARK: - Configure

extension WishVM {
    func showList(of kind: WishListVC.Kind) {
        self.currentListKind = kind

        guard let delegate = delegate else {
            printError(self, "Delegate is missing.")
            return
        }

        delegate.listWasUpdated()
    }
}

// MARK: - UITableViewDataSource

extension WishVM: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentListKind {
        case .requested:
            return approvedWishList.count
        case .implemented:
            return implementedWishList.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WishCell.identifier, for: indexPath)

        guard
            let wishCell = cell as? WishCell
        else {
            return cell
        }

        switch currentListKind {
        case .requested:
            wishCell.set(response: approvedWishList[indexPath.row])
        case .implemented:
            wishCell.set(response: implementedWishList[indexPath.row])
        }

        wishCell.delegate = self
        return wishCell
    }
}

// MARK: - UITableViewDelegate

extension WishVM: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var wishResponse: WishResponse

        switch currentListKind {
        case .requested:
            wishResponse = approvedWishList[indexPath.row]
        case .implemented:
            wishResponse = implementedWishList[indexPath.row]
        }

        guard let delegate = delegate else {
            printError(self, "Delegate is missing.")
            return
        }

        delegate.didSelect(wishResponse: wishResponse)
    }
}

// MARK: - WishCellDelegate

extension WishVM: WishCellDelegate {
    func voteWasTapped() {
        fetchWishList()
    }
}
