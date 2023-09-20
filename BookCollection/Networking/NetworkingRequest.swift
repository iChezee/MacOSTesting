import Foundation

enum Request {
    static func makeRequest() {
        let headers = [
            "content-type": "application/json",
            "authorization": "apikey your_token"
        ]
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.collectapi.com/book/newBook")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
            }
        })
        
        dataTask.resume()
    }
}
