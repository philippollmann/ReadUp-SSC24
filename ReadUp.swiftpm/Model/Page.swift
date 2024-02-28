import SwiftUI


enum PageType: String, Codable {
    case text = "text"
    case quiz = "quiz"
    case collect = "collect"
}

class Page: Codable {
    var type: PageType
    
    init(type: PageType) {
        self.type = type
    }
    
    enum CodingKeys: String, CodingKey {
        case type
    }
        
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(PageType.self, forKey: .type)
    }
}
