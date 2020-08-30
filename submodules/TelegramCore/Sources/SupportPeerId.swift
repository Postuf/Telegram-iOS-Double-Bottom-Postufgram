import Postbox
import SwiftSignalKit
import TelegramApi
import MtProtoKit

import SyncCore

public func supportPeerId(account:Account) -> Signal<PeerId?, NoError> {
    return account.network.request(Api.functions.help.getSupport())
    |> map(Optional.init)
    |> `catch` { _ in
        return Signal<Api.help.Support?, NoError>.single(nil)
    }
    |> mapToSignal { support -> Signal<PeerId?, NoError> in
        if let support = support {
            switch support {
                case let .support(phoneNumber: _, user: user):
                    let user = TelegramUser(user: user)
                    return account.postbox.transaction { transaction -> PeerId in
                        updatePeers(transaction: transaction, peers: [user], update: { (previous, updated) -> Peer? in
                            return updated
                        })
                        return user.id
                    }
            }
        }
        return .single(nil)
    }
}

public func postufgramHelpPeerId(account:Account) -> Signal<PeerId?, NoError> {
    return account.network.request(Api.functions.contacts.resolveUsername(username: "postufgram"))
    |> map(Optional.init)
    |> `catch` { _ in
        return Signal<Api.contacts.ResolvedPeer?, NoError>.single(nil)
    }
    |> mapToSignal { peer -> Signal<PeerId?, NoError> in
        if let peer = peer {
            switch peer {
                case let .resolvedPeer(_, chats, _):
                    guard let user = parseTelegramGroupOrChannel(chat: chats[0]) else { return .single(nil) }
                    return account.postbox.transaction { transaction -> PeerId in
                        updatePeers(transaction: transaction, peers: [user], update: { (previous, updated) -> Peer? in
                            return updated
                        })
                        return user.id
                    }
            }
        }
        return .single(nil)
    }
}
