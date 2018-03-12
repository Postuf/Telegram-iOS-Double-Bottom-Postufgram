import Foundation
import TelegramCore

private func inputQueryResultPriority(_ result: ChatPresentationInputQueryResult) -> Int {
    switch result {
        case .stickers:
            return 0
        case .hashtags:
            return 1
        case .mentions:
            return 2
        case .commands:
            return 3
        case .contextRequestResult:
            return 4
    }
}

func inputContextPanelForChatPresentationIntefaceState(_ chatPresentationInterfaceState: ChatPresentationInterfaceState, account: Account, currentPanel: ChatInputContextPanelNode?, interfaceInteraction: ChatPanelInterfaceInteraction?) -> ChatInputContextPanelNode? {
    guard let _ = chatPresentationInterfaceState.renderedPeer?.peer else {
        return nil
    }
    
    guard let inputQueryResult = chatPresentationInterfaceState.inputQueryResults.values.sorted(by: {
        inputQueryResultPriority($0) < inputQueryResultPriority($1)
    }).first else {
        return nil
    }
    
    switch inputQueryResult {
        case let .stickers(results):
            if !results.isEmpty {
                if let currentPanel = currentPanel as? HorizontalStickersChatContextPanelNode {
                    currentPanel.updateResults(results.map({ $0.file }))
                    return currentPanel
                } else {
                    let panel = HorizontalStickersChatContextPanelNode(account: account, theme: chatPresentationInterfaceState.theme, strings: chatPresentationInterfaceState.strings)
                    panel.interfaceInteraction = interfaceInteraction
                    panel.updateResults(results.map({ $0.file }))
                    return panel
                }
            }
        case let .hashtags(results):
            if let currentPanel = currentPanel as? HashtagChatInputContextPanelNode {
                currentPanel.updateResults(results)
                return currentPanel
            } else {
                let panel = HashtagChatInputContextPanelNode(account: account, theme: chatPresentationInterfaceState.theme, strings: chatPresentationInterfaceState.strings)
                panel.interfaceInteraction = interfaceInteraction
                panel.updateResults(results)
                return panel
            }
        case let .mentions(peers):
            if !peers.isEmpty {
                if let currentPanel = currentPanel as? MentionChatInputContextPanelNode, currentPanel.mode == .input {
                    currentPanel.updateResults(peers)
                    return currentPanel
                } else {
                    let panel = MentionChatInputContextPanelNode(account: account, theme: chatPresentationInterfaceState.theme, strings: chatPresentationInterfaceState.strings, mode: .input)
                    panel.interfaceInteraction = interfaceInteraction
                    panel.updateResults(peers)
                    return panel
                }
            } else {
                return nil
            }
        case let .commands(commands):
            if !commands.isEmpty {
                if let currentPanel = currentPanel as? CommandChatInputContextPanelNode {
                    currentPanel.updateResults(commands)
                    return currentPanel
                } else {
                    let panel = CommandChatInputContextPanelNode(account: account, theme: chatPresentationInterfaceState.theme, strings: chatPresentationInterfaceState.strings)
                    panel.interfaceInteraction = interfaceInteraction
                    panel.updateResults(commands)
                    return panel
                }
            } else {
                return nil
            }
        case let .contextRequestResult(_, results):
            if let results = results, (!results.results.isEmpty || results.switchPeer != nil) {
                switch results.presentation {
                    case .list:
                        if let currentPanel = currentPanel as? VerticalListContextResultsChatInputContextPanelNode {
                            currentPanel.updateResults(results)
                            return currentPanel
                        } else {
                            let panel = VerticalListContextResultsChatInputContextPanelNode(account: account, theme: chatPresentationInterfaceState.theme, strings: chatPresentationInterfaceState.strings)
                            panel.interfaceInteraction = interfaceInteraction
                            panel.updateResults(results)
                            return panel
                        }
                    case .media:
                        if let currentPanel = currentPanel as? HorizontalListContextResultsChatInputContextPanelNode {
                            currentPanel.updateResults(results)
                            return currentPanel
                        } else {
                            let panel = HorizontalListContextResultsChatInputContextPanelNode(account: account, theme: chatPresentationInterfaceState.theme, strings: chatPresentationInterfaceState.strings)
                            panel.interfaceInteraction = interfaceInteraction
                            panel.updateResults(results)
                            return panel
                        }
                }
            } else {
                return nil
            }
    }
    
    return nil
}

func chatOverlayContextPanelForChatPresentationIntefaceState(_ chatPresentationInterfaceState: ChatPresentationInterfaceState, account: Account, currentPanel: ChatInputContextPanelNode?, interfaceInteraction: ChatPanelInterfaceInteraction?) -> ChatInputContextPanelNode? {
    guard let searchQuerySuggestionResult = chatPresentationInterfaceState.searchQuerySuggestionResult, let _ = chatPresentationInterfaceState.renderedPeer?.peer else {
        return nil
    }
    
    switch searchQuerySuggestionResult {
        case let .mentions(peers):
            if !peers.isEmpty {
                if let currentPanel = currentPanel as? MentionChatInputContextPanelNode, currentPanel.mode == .search {
                    currentPanel.updateResults(peers)
                    return currentPanel
                } else {
                    let panel = MentionChatInputContextPanelNode(account: account, theme: chatPresentationInterfaceState.theme, strings: chatPresentationInterfaceState.strings, mode: .search)
                    panel.interfaceInteraction = interfaceInteraction
                    panel.updateResults(peers)
                    return panel
                }
            } else {
                return nil
            }
        default:
            break
    }
    
    return nil
}

