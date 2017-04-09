//
//  JsonToFlexConverter.swift
//  FlexBuffers
//
//  Created by Maxim Zaks on 03.04.17.
//  Copyright © 2017 Maxim Zaks. All rights reserved.
//

import XCTest
import FlexBuffers

class JsonToFlexConverterTest: XCTestCase {

    func testJSONObjectOnePropertyToInt() {
        let data = FlexBuffer.dataFrom(jsonData:"{a:25}".data(using: .utf8)!)
        let o = FlexBuffer.decode(data: data)
        XCTAssertEqual(25, o!["a"]?.asInt!)
    }
    
    func testJSONObjectOnePropertyToIntWithQuotes() {
        let data = FlexBuffer.dataFrom(jsonData:"{\("a"):25}".data(using: .utf8)!)
        let o = FlexBuffer.decode(data: data)
        XCTAssertEqual(25, o!["a"]?.asInt!)
    }

    func testJSONObjectOnePropertyToFloat() {
        let data = FlexBuffer.dataFrom(jsonData:"{\("a"):2.5}".data(using: .utf8)!)
        let o = FlexBuffer.decode(data: data)
        XCTAssertEqual(2.5, o!["a"]?.asDouble!)
    }
    
    func testJSONObjectWithArrayAndObject() {
        let data = FlexBuffer.dataFrom(jsonData:"{my_name:{a:123, b:null}, _vec: [true, 123, 0.7, \"hello\"]}".data(using: .utf8)!)
        let o = FlexBuffer.decode(data: data)
        XCTAssertEqual(123, o?["my_name"]?["a"]?.asInt)
        XCTAssertEqual(nil, o?["my_name"]?["b"]?.asString)
        XCTAssertEqual(true, o?["_vec"]?[0]?.asBool)
        XCTAssertEqual(123, o?["_vec"]?[1]?.asInt)
        XCTAssertEqual(0.7, o?["_vec"]?[2]?.asFloat)
        XCTAssertEqual("hello", o?["_vec"]?[3]?.asString)
    }
    
    func testJSONObjectOnePropertyToString() {
        let data = FlexBuffer.dataFrom(jsonData:"{name:\"slkfjsdlfkjw23424\"}".data(using: .utf8)!)
        let o = FlexBuffer.decode(data: data)
        XCTAssertEqual("slkfjsdlfkjw23424", o!["name"]?.asString!)
    }
    
    func testJSONObjectOnePropertyToStringWithEscaping() {
        let data = FlexBuffer.dataFrom(jsonData:"{name:\"slkfjsdl\\\"\\n\\r\\{}[]:,  tfkjw23424\"}".data(using: .utf8)!)
        let o = FlexBuffer.decode(data: data)
        XCTAssertEqual("slkfjsdl\\\"\\n\\r\\{}[]:,  tfkjw23424", o!["name"]?.asString!)
    }
    
    func testJSONObjectOnePropertyToStringWithEmoji() {
        let data = FlexBuffer.dataFrom(jsonData:"{name:\"slkfjsdlfkjw23424😒😒🤓😎\"}".data(using: .utf8)!)
        let o = FlexBuffer.decode(data: data)
        XCTAssertEqual("slkfjsdlfkjw23424😒😒🤓😎", o!["name"]?.asString!)
    }
    
    func testJSONArrayOfIntegers() {
        let data = FlexBuffer.dataFrom(jsonData:"[1, -424244, 333333, 0,     -0, 3e3, 3E5]".data(using: .utf8)!)
        let o = FlexBuffer.decode(data: data)
        XCTAssertEqual(1, o![0]?.asInt)
        XCTAssertEqual(-424244, o![1]?.asInt)
        XCTAssertEqual(333333, o![2]?.asInt)
        XCTAssertEqual(0, o![3]?.asInt)
        XCTAssertEqual(0, o![4]?.asInt)
        XCTAssertEqual(3000, o![5]?.asInt)
        XCTAssertEqual(300000, o![6]?.asInt)
    }
    
    func testJSONArrayOfFloats() {
        let data = FlexBuffer.dataFrom(jsonData:"[0.1, 0.25, 0.75, 0.55555, 0.76543, 1e-2, 1.222e+2, 1.222E-2]".data(using: .utf8)!)
        let o = FlexBuffer.decode(data: data)
        XCTAssertEqual(0.1, o![0]?.asFloat!)
        XCTAssertEqual(0.25, o![1]?.asFloat!)
        XCTAssertEqual(0.75, o![2]?.asFloat!)
        XCTAssertEqual(0.55555, o![3]?.asFloat!)
        XCTAssertEqual(0.76543, o![4]?.asFloat!)
        XCTAssertEqual(0.01, o![5]?.asFloat)
        XCTAssertEqual(122.2, o![6]?.asFloat)
        XCTAssertEqual(0.01222, o![7]?.asFloat)
    }
    
    func testJSONArrayOfFloatsAndNull() {
        let data = FlexBuffer.dataFrom(jsonData:"[0.1, 0.25, 0.75, null, 0.55555, 0.76543]".data(using: .utf8)!)
        let o = FlexBuffer.decode(data: data)
        XCTAssertEqual(0.1, o![0]?.asFloat!)
        XCTAssertEqual(0.25, o![1]?.asFloat!)
        XCTAssertEqual(0.75, o![2]?.asFloat!)
        XCTAssertEqual(nil, o![3]!.asFloat)
        XCTAssertEqual(nil, o![3]!.asString)
        XCTAssertEqual(0.55555, o![4]?.asFloat!)
        XCTAssertEqual(0.76543, o![5]?.asFloat!)
    }
    
    func testJSONArrayBools() {
        let data = FlexBuffer.dataFrom(jsonData:"[true, false, true]".data(using: .utf8)!)
        let o = FlexBuffer.decode(data: data)
        XCTAssertEqual(true, o![0]?.asBool)
        XCTAssertEqual(false, o![1]!.asBool)
        XCTAssertEqual(true, o![2]!.asBool)
    }
    
    func testJSONArrayOfFloatsAndTrue() {
        let data = FlexBuffer.dataFrom(jsonData:"[0.1, 0.25, 0.75, true, 0.55555, 0.76543]".data(using: .utf8)!)
        let o = FlexBuffer.decode(data: data)
        XCTAssertEqual(0.1, o![0]?.asFloat)
        XCTAssertEqual(0.25, o![1]?.asFloat)
        XCTAssertEqual(0.75, o![2]?.asFloat)
        XCTAssertEqual(true, o![3]!.asBool)
        XCTAssertEqual(0.55555, o![4]?.asFloat)
        XCTAssertEqual(0.76543, o![5]?.asFloat)
    }
    
    func testJSONArrayOfFloatsWhereOneNumberIsNotValid() {
        let data = FlexBuffer.dataFrom(jsonData:"[0.1, 025]".data(using: .utf8)!)
        let o = FlexBuffer.decode(data: data)
        XCTAssertEqual(0.1, o![0]?.asFloat!)
        XCTAssertEqual("025", o![1]?.asString!)
    }
    
    func testJSONArrayOfFloatsAndFalse() {
        let data = FlexBuffer.dataFrom(jsonData:"[0.1, 0.25, 0.75, false, 0.55555, -0.76543]".data(using: .utf8)!)
        let o = FlexBuffer.decode(data: data)
        print(o!.debugDescription)
        XCTAssertEqual(0.1, o![0]?.asFloat)
        XCTAssertEqual(0.25, o![1]?.asFloat)
        XCTAssertEqual(0.75, o![2]?.asFloat)
        XCTAssertEqual(false, o![3]!.asBool)
        XCTAssertEqual(0.55555, o![4]?.asFloat)
        XCTAssertEqual(-0.76543, o![5]?.asFloat)
    }
    
    func testJSONSample(){
        let data = FlexBuffer.dataFrom(jsonData:"{name:\"Maxim\", birthday:{\"year\": 1981, month: 6, day: 12}}".data(using: .utf8)!)
        let accessor = FlexBuffer.decode(data:data)
        let name = accessor?["name"]?.asString
        let day = accessor?["birthday"]?["day"]?.asInt
        
        XCTAssertEqual("Maxim", name)
        XCTAssertEqual(12, day)
    }
    
    func testGiphyTrending(){
        let url = Bundle.init(for: JsonToFlexConverterTest.self).url(forResource: "giphy_trending", withExtension: "json")!
        let jsonData = try!Data(contentsOf: url)
        let data = FlexBuffer.dataFrom(jsonData: jsonData)
        let o = FlexBuffer.decode(data: data)
        XCTAssertEqual("http:\\/\\/giphy.com\\/gifs\\/nirvana-bored-kurt-cobain-qc1waqAag4tZC", o!["data"]![1]!["url"]!.asString!)
        XCTAssertEqual(25, o!["data"]!.count)
        XCTAssertEqual("http:\\/\\/media3.giphy.com\\/media\\/qc1waqAag4tZC\\/giphy.gif", o!["data"]![1]!["images"]!["original"]!["url"]!.asString!)
    }
}