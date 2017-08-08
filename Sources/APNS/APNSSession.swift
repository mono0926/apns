import Foundation
import Dispatch

class APNSSession {
    private let session = URLSession(configuration: .default)
    func sendSync(request: URLRequest) -> (Data?, URLResponse?, Error?) {
        var result: (Data?, URLResponse?, Error?)! = nil
        let semaphor = DispatchSemaphore(value: 0)
        session.dataTask(with: request) { data, response, error in
            result = (data, response, error)
            semaphor.signal()
            }
            .resume()
        semaphor.wait()
        return result
    }
}
