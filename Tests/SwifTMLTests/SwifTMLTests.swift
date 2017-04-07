import XCTest
@testable import SwifTML

struct View: SwifTML {
    static var h1: String {
        return H1("Hello").htmlString
    }
}

class SwifTMLTests: XCTestCase {
    func testBasicTag() {
        XCTAssertEqual(View.h1, "<h1>Hello</h1>")
    }

    func testAttributes() {
        let id = Attribute.id("test")
        let klass = Attribute.class("test")
        XCTAssertEqual(Attribute.combined(attributes: [id, klass]), "id=\"test\" class=\"test\"")
    }

    static var allTests = [
        ("testBasicTag", testBasicTag),
        ("testAttributes", testAttributes),
    ]
}
