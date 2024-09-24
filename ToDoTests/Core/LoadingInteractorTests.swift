//
//  LoadingInteractorTests.swift
//  ToDoTests
//
//  Created by Nikita Stepanov on 24.09.2024.
//

import XCTest
@testable import ToDo

final class LoadingInteractorTests: XCTestCase {
    // MARK: - Private properties
    private var sut: LoadingInteractorProtocol!
    private var loadingPresenterSpy: LoadingPresenterSpyProtocol!
    private var userDefaultsManagerMock: UserDefaultsManagerMockProtocol!
    private var dummyAPIManagerMock = DummyAPIManagerMock()
    private var storageManagerMock = StorageManagerMock()
    
    override func setUp() {
        loadingPresenterSpy = LoadingPresenterSpy()
        userDefaultsManagerMock = UserDefaultsManagerMock()
        sut = LoadingInteractor(presenter: loadingPresenterSpy,
                                userDefaultsManager: userDefaultsManagerMock,
                                storageManager: storageManagerMock,
                                dummyAPIManager: dummyAPIManagerMock)
        sut.presenter = loadingPresenterSpy
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        loadingPresenterSpy = nil
        super.tearDown()
    }
    
    func testDataRequestingWhenFirstLaunch() {
        userDefaultsManagerMock.setUpAsFirst()
        dummyAPIManagerMock.setUpForSuccess()
        sut.requestData()
        XCTAssertTrue(loadingPresenterSpy.dataFetchedCalled,
                      "After 'requestData' interacroe should call 'dataFetched' on presenter")
        XCTAssertTrue(loadingPresenterSpy.fetchedData == TaskModel.storageMockList,
                           "FetchedData should be from api \(loadingPresenterSpy.fetchedData)")
    }
    
    func testDataRequestingWhenSecondLaunch() {
        userDefaultsManagerMock.setUpAsNotFirst()
        sut.requestData()
        XCTAssertTrue(loadingPresenterSpy.dataFetchedCalled,
                      "After 'requestData' interacroe should call 'dataFetched' on presenter")
        XCTAssertTrue(loadingPresenterSpy.fetchedData == TaskModel.storageMockList,
                      "FetchedData should be from storage")
      
    }
}
