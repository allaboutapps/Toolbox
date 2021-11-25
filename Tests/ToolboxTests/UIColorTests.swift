import UIKit
@testable import Toolbox
import XCTest

final class UIColorTests: XCTestCase {
    // MARK: Array Testing
    
    func testUIColorConversionFFFFFFWithHashtag() {
        let color = UIColor(hexString: "#FFFFFF")
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        XCTAssertEqual(r, 1.0, "red should  match")
        XCTAssertEqual(g, 1.0, "red should  match")
        XCTAssertEqual(b, 1.0, "red should  match")
    }
    
    func testUIColorConversionFFFFFF() {
        let color = UIColor(hexString: "FFFFFF")
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        XCTAssertEqual(r, 1.0, "red should  match")
        XCTAssertEqual(g, 1.0, "red should  match")
        XCTAssertEqual(b, 1.0, "red should  match")
    }
    
    func testUIColorConversion000000WithHashTag() {
        let color = UIColor(hexString: "#000000")
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        XCTAssertEqual(r, 0.0, "red should  match")
        XCTAssertEqual(g, 0.0, "red should  match")
        XCTAssertEqual(b, 0.0, "red should  match")
    }
    
    func testUIColorConversion000000() {
        let color = UIColor(hexString: "000000")
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)

        XCTAssertEqual(r, 0.0, "red should  match")
        XCTAssertEqual(g, 0.0, "red should  match")
        XCTAssertEqual(b, 0.0, "red should  match")
    }
    
    func testUIColorConversionABCDEF() {
        let color = UIColor(hexString: "ABCDEF")
        
        XCTAssertEqual(color.toHexString().uppercased(), "#ABCDEF")
    }
}
