//
//  UnitTestingViewModelTests.swift
//  TestingPracticeTests
//
//  Created by NH on 10/19/23.
//

import XCTest
@testable import TestingPractice

// Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavior
// OR Naming Structure: test_Class_variableOrFunc_ExpectedResult

// Testing Structure: Given When Then

final class UnitTestingViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_UnitTestingBootCampViewModel_isPremium_shouldBeTrue() {
        // Given
        let userIsPremium: Bool = true
        // When
        let vm = UnitTestingBootCampViewModel(isPremium: userIsPremium)
        
        // Then
        XCTAssertTrue(vm.isPremium)
        // basic but if something changes down the line, should still work as expected
    }
    
    func test_UnitTestingBootCampViewModel_isPremium_shouldBeFalse() {
        // Given
        let userIsPremium: Bool = false
        // When
        let vm = UnitTestingBootCampViewModel(isPremium: userIsPremium)
        
        // Then
        XCTAssertFalse(vm.isPremium)
    }
    
    // Ints/ Doubles  --> less specific tests
    // doesn't cover previous two tests
    func test_UnitTestingBootCampViewModel_isPremium_shouldBeInjectedValue() {
        // Given
        let userIsPremium: Bool = Bool.random()
        // When
        let vm = UnitTestingBootCampViewModel(isPremium: userIsPremium)
        
        // Then
        XCTAssertEqual(vm.isPremium, userIsPremium)
    }
    // stress test of previous
    func test_UnitTestingBootCampViewModel_isPremium_shouldBeInjectedValue_stress() {
        for _ in 0 ..< 10 {
            let userIsPremium: Bool = Bool.random()
            // When
            let vm = UnitTestingBootCampViewModel(isPremium: userIsPremium)
            
            // Then
            XCTAssertEqual(vm.isPremium, userIsPremium)
        }
    }
    
    func test_UnitTestingBootCampViewModel_dataArray_shouldBeEmpty() {
        // Given
        
        // When
        let vm = UnitTestingBootCampViewModel(isPremium: Bool.random())
        // Then
        XCTAssertTrue(vm.dataArray.isEmpty)
        XCTAssertEqual(vm.dataArray.count, 0)
    }
    
    func test_UnitTestingBootCampViewModel_dataArray_shouldAddItem() {
        // Given
        let vm = UnitTestingBootCampViewModel(isPremium: Bool.random())
        // When
        vm.addItems(item: "Hello")
        // Then
        XCTAssertFalse(vm.dataArray.isEmpty)
        XCTAssertEqual(vm.dataArray.count, 1)
        XCTAssertNotEqual(vm.dataArray.count, 0)
    }
    
    func test_UnitTestingBootCampViewModel_dataArray_shouldNotAddEmptyString() {
        // Given
        let vm = UnitTestingBootCampViewModel(isPremium: Bool.random())
        // When
        vm.addItems(item: "")
        // Then
        XCTAssertTrue(vm.dataArray.isEmpty)
        XCTAssertNotEqual(vm.dataArray.count, 1)
        XCTAssertEqual(vm.dataArray.count, 0)
    }
    
    func test_UnitTestingBootCampViewModel_dataArray_shouldAddMultipleItems() {
        // Given
        let vm = UnitTestingBootCampViewModel(isPremium: Bool.random())
        
        // When
        let loopCount: Int = Int.random(in: 1 ..< 100)
        for _ in 0 ..< loopCount {
            vm.addItems(item: "Hello")
        }
        
        // Then
        XCTAssertFalse(vm.dataArray.isEmpty)
        XCTAssertEqual(vm.dataArray.count, loopCount)
        XCTAssertNotEqual(vm.dataArray.count, 0)
    }
    
    func test_UnitTestingBootCampViewModel_selectedItem_shouldStartAtNil() {
        // Given
        
        // When
        let vm = UnitTestingBootCampViewModel(isPremium: Bool.random())
        // Then
        XCTAssertTrue(vm.selectedItem == nil)
        XCTAssertNil(vm.selectedItem)
    }
    
    func test_UnitTestingBootCampViewModel_selectedItem_shouldEndAtNilIfDataArrayEmpty() {
        // Given
        let vm = UnitTestingBootCampViewModel(isPremium: Bool.random())
        // When
        vm.selectItem(item: "Hello")
        // Then
        XCTAssertTrue(vm.selectedItem == nil)
        XCTAssertNil(vm.selectedItem)
    }
    
    func test_UnitTestingBootCampViewModel_selectedItem_shouldBeSelected() {
        // Given
        let vm = UnitTestingBootCampViewModel(isPremium: Bool.random())
        // When
        let newItem = UUID().uuidString
        vm.addItems(item: newItem)
        vm.selectItem(item: newItem)
        // Then
        XCTAssertFalse(vm.selectedItem == nil)
        XCTAssertNotNil(vm.selectedItem)
        XCTAssertEqual(vm.selectedItem, newItem)
    }

}
