import XCTest
@testable import MyService

class MockURLSession: URLSessionProtocol {

    private (set) var url: URL?
    var dataTask = MockURLSessionDataTask()

    func dataTask(with request: URLRequestProtocol,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTaskProtocol {
        url = request.url
//        completionHandler(nextData, successHttpURLResponse(request: request), nextError)
        return dataTask
    }
}
