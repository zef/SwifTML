import XCTest
@testable import SwifTML

struct View: SwifTML {
    static var h1: String {
        return H1("Hello").htmlString
    }
}

class SwifTMLTests: XCTestCase {
    func testExample() {
        XCTAssertEqual(View.h1, "<h1>Hello</h1>")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
