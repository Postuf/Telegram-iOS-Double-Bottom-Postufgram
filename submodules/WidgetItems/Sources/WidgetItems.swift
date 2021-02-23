import Foundation

public enum WidgetCodingError: Error {
    case generic
}

public struct WidgetDataPeer: Codable, Equatable {
    public struct Badge: Codable, Equatable {
        public var count: Int
        public var isMuted: Bool
        
        public init(count: Int, isMuted: Bool) {
            self.count = count
            self.isMuted = isMuted
        }
    }
    
    public struct Message: Codable, Equatable {
        public enum Content: Codable, Equatable {
            public enum DecodingError: Error {
                case generic
            }
            
            public struct Image: Codable, Equatable {
                public init() {
                }
            }
            
            public struct Video: Codable, Equatable {
                public init() {
                }
            }
            
            public struct File: Codable, Equatable {
                public var name: String
                
                public init(name: String) {
                    self.name = name
                }
            }
            
            public struct Gif: Codable, Equatable {
                public init() {
                }
            }
            
            public struct Music: Codable, Equatable {
                public var artist: String
                public var title: String
                public var duration: Int32
                
                public init(artist: String, title: String, duration: Int32) {
                    self.artist = artist
                    self.title = title
                    self.duration = duration
                }
            }
            
            public struct VoiceMessage: Codable, Equatable {
                public var duration: Int32
                
                public init(duration: Int32) {
                    self.duration = duration
                }
            }
            
            public struct VideoMessage: Codable, Equatable {
                public var duration: Int32
                
                public init(duration: Int32) {
                    self.duration = duration
                }
            }
            
            public struct Sticker: Codable, Equatable {
                public var altText: String
                
                public init(altText: String) {
                    self.altText = altText
                }
            }
            
            public struct Call: Codable, Equatable {
                public var isVideo: Bool
                
                public init(isVideo: Bool) {
                    self.isVideo = isVideo
                }
            }
            
            public struct MapLocation: Codable, Equatable {
                public init() {
                }
            }
            
            public struct Game: Codable, Equatable {
                public var title: String
                
                public init(title: String) {
                    self.title = title
                }
            }
            
            public struct Poll: Codable, Equatable {
                public var title: String
                
                public init(title: String) {
                    self.title = title
                }
            }
            
            enum CodingKeys: String, CodingKey {
                case text
                case image
                case video
                case file
                case gif
                case music
                case voiceMessage
                case videoMessage
                case sticker
                case call
                case mapLocation
                case game
                case poll
            }
            
            case text
            case image(Image)
            case video(Video)
            case file(File)
            case gif(Gif)
            case music(Music)
            case voiceMessage(VoiceMessage)
            case videoMessage(VideoMessage)
            case sticker(Sticker)
            case call(Call)
            case mapLocation(MapLocation)
            case game(Game)
            case poll(Poll)
            
            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                if let _ = try? container.decode(String.self, forKey: .text) {
                    self = .text
                } else if let image = try? container.decode(Image.self, forKey: .image) {
                    self = .image(image)
                } else if let video = try? container.decode(Video.self, forKey: .video) {
                    self = .video(video)
                } else if let gif = try? container.decode(Gif.self, forKey: .gif) {
                    self = .gif(gif)
                } else if let file = try? container.decode(File.self, forKey: .file) {
                    self = .file(file)
                } else if let music = try? container.decode(Music.self, forKey: .voiceMessage) {
                    self = .music(music)
                } else if let voiceMessage = try? container.decode(VoiceMessage.self, forKey: .voiceMessage) {
                    self = .voiceMessage(voiceMessage)
                } else if let videoMessage = try? container.decode(VideoMessage.self, forKey: .videoMessage) {
                    self = .videoMessage(videoMessage)
                } else if let sticker = try? container.decode(Sticker.self, forKey: .sticker) {
                    self = .sticker(sticker)
                } else if let call = try? container.decode(Call.self, forKey: .call) {
                    self = .call(call)
                } else if let mapLocation = try? container.decode(MapLocation.self, forKey: .mapLocation) {
                    self = .mapLocation(mapLocation)
                } else if let game = try? container.decode(Game.self, forKey: .game) {
                    self = .game(game)
                } else if let poll = try? container.decode(Poll.self, forKey: .poll) {
                    self = .poll(poll)
                } else {
                    throw DecodingError.generic
                }
            }
            
            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                switch self {
                case .text:
                    try container.encode("", forKey: .text)
                case let .image(image):
                    try container.encode(image, forKey: .image)
                case let .video(video):
                    try container.encode(video, forKey: .video)
                case let .file(file):
                    try container.encode(file, forKey: .file)
                case let .gif(gif):
                    try container.encode(gif, forKey: .gif)
                case let .music(music):
                    try container.encode(music, forKey: .music)
                case let .voiceMessage(voiceMessage):
                    try container.encode(voiceMessage, forKey: .voiceMessage)
                case let .videoMessage(videoMessage):
                    try container.encode(videoMessage, forKey: .videoMessage)
                case let .sticker(sticker):
                    try container.encode(sticker, forKey: .sticker)
                case let .call(call):
                    try container.encode(call, forKey: .call)
                case let .mapLocation(mapLocation):
                    try container.encode(mapLocation, forKey: .mapLocation)
                case let .game(game):
                    try container.encode(game, forKey: .game)
                case let .poll(poll):
                    try container.encode(poll, forKey: .poll)
                }
            }
        }
        
        public var text: String
        public var content: Content
        public var timestamp: Int32
        
        public init(text: String, content: Content, timestamp: Int32) {
            self.text = text
            self.content = content
            self.timestamp = timestamp
        }
    }
    
    public var id: Int64
    public var name: String
    public var lastName: String?
    public var letters: [String]
    public var avatarPath: String?
    public var badge: Badge?
    public var message: Message?
    
    public init(id: Int64, name: String, lastName: String?, letters: [String], avatarPath: String?, badge: Badge?, message: Message?) {
        self.id = id
        self.name = name
        self.lastName = lastName
        self.letters = letters
        self.avatarPath = avatarPath
        self.badge = badge
        self.message = message
    }
}

public struct WidgetDataPeers: Codable, Equatable {
    public var accountPeerId: Int64
    public var peers: [WidgetDataPeer]
    
    public init(accountPeerId: Int64, peers: [WidgetDataPeer]) {
        self.accountPeerId = accountPeerId
        self.peers = peers
    }
}

public struct WidgetPresentationData: Codable, Equatable {
    public var applicationLockedString: String
    public var applicationStartRequiredString: String
    public var widgetGalleryTitle: String
    public var widgetGalleryDescription: String
    
    public init(applicationLockedString: String, applicationStartRequiredString: String, widgetGalleryTitle: String, widgetGalleryDescription: String) {
        self.applicationLockedString = applicationLockedString
        self.applicationStartRequiredString = applicationStartRequiredString
        self.widgetGalleryTitle = widgetGalleryTitle
        self.widgetGalleryDescription = widgetGalleryDescription
    }
}

public func widgetPresentationDataPath(rootPath: String) -> String {
    return rootPath + "/widgetPresentationData.json"
}

public struct WidgetData: Codable, Equatable {
    public enum Content: Codable, Equatable {
        private enum CodingKeys: CodingKey {
            case discriminator
            case peers
        }
        
        private enum Cases: Int32, Codable {
            case notAuthorized
            case disabled
            case peers
        }
        
        case notAuthorized
        case disabled
        case peers(WidgetDataPeers)
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let discriminator = try container.decode(Cases.self, forKey: .discriminator)
            switch discriminator {
            case .notAuthorized:
                self = .notAuthorized
            case .disabled:
                self = .disabled
            case .peers:
                self = .peers(try container.decode(WidgetDataPeers.self, forKey: .peers))
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .notAuthorized:
                try container.encode(Cases.notAuthorized, forKey: .discriminator)
            case .disabled:
                try container.encode(Cases.disabled, forKey: .discriminator)
            case let .peers(peers):
                try container.encode(Cases.peers, forKey: .discriminator)
                try container.encode(peers, forKey: .peers)
            }
        }
    }
    
    public var accountId: Int64
    public var content: Content
    
    public init(accountId: Int64, content: Content) {
        self.accountId = accountId
        self.content = content
    }
}
