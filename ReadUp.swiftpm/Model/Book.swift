import SwiftUI

class Book: Decodable {
    let comingSoon: Bool
    let title: String
    let coverName: String
    let author: String
    let description: String
    let pages: [Page]
    
    enum CodingKeys: String, CodingKey {
        case title, coverName, author, description, pages, comingSoon
    }
    
    init(title: String, coverName: String, author: String, description: String, pages: [Page], comingSoon: Bool = false) {
        self.title = title
        self.coverName = coverName
        self.author = author
        self.description = description
        self.pages = pages
        self.comingSoon = comingSoon
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        author = try container.decode(String.self, forKey: .author)
        description = try container.decode(String.self, forKey: .description)
        coverName = try container.decode(String.self, forKey: .coverName)
        comingSoon = try container.decodeIfPresent(Bool.self, forKey: .comingSoon) ?? false
        
        var pagesArrayForType = try container.nestedUnkeyedContainer(forKey: .pages)
        var pages = [Page]()
        
        var pagesArray = pagesArrayForType
        while !pagesArrayForType.isAtEnd {
            let page = try pagesArrayForType.nestedContainer(keyedBy: Page.CodingKeys.self)
            let type = try page.decode(PageType.self, forKey: .type)
            switch type {
            case .text:
                pages.append(try pagesArray.decode(TextPage.self))
            case .quiz:
                pages.append(try pagesArray.decode(QuizPage.self))
            case .collect:
                pages.append(try pagesArray.decode(CollectionPage.self))
            }
        }
        self.pages = pages
    }
}

extension Book {
    static let bookFixture: Book = bookFixtures.first!
    static let bookFixtures: [Book] = [
        Book(title: "Lisa and Steve's Lunar Adventure",
             coverName: "cover",
             author: "Philipp Ollmann",
             description: "Testing Book for testing!",
             pages: [
                TextPage.fixture,
                QuizPage.fixture,
                CollectionPage.fixture,
                TextPage.fixture
             ]
            )
    ]
    
    static let bookFixturesComingSoon: Book = Book(title: "Benny the Alien",
                                                   coverName: "alien_cover",
                                                   author: "Philipp Ollmann",
                                                   description: "Get ready for an out-of-this-world adventure as Benny the Alien zooms into the galaxy on a quest to discover the magic of friendship and the wonders of Earth!",
                                                   pages: [],
                                                   comingSoon: true
    )
}



