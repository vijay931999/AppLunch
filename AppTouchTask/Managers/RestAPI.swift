//
//  RestAPI.swift
//  AppTouchTask
//
//  Created by Vijay K on 12/12/22.
//

import Alamofire
import Foundation
import SDWebImage

class RestAPI {
    /// This performs the basic GET for REST calls in app.
    /// It validates the response 200, 201 and makes sure the json data is available
    /// On failure it simply returns nil on json data
    class func request(url: String, method: HTTPMethod, parameters: [String: Any]? = nil, completionHandler: @escaping (_ data: Data?) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        AF.request(url, method: method, headers: headers).response { response in
            if validateResponse(url: url, response: response) {
                if let data = response.data {
                    completionHandler(data)
                    return
                }
            }
            completionHandler(nil)
        }
    }
    
    class func validateResponse(url: String, response: AFDataResponse<Data?>) -> Bool {
        if let httpCode = response.response?.statusCode {
            if httpCode == 200 || httpCode == 201 {
                if let _ = response.data {
                    return true
                }
            }
            print("Http Error \(httpCode) on URL -> \(url)")
            return (false)
        }
        print("Unable to fetch -> \(url)")
        return false
    }
    
    /// Fetch companies
    class func fetchCompany(completionHandler: @escaping (Company?) -> Void) {
        let url = "https://api.spacexdata.com/v4/company"
        request(url: url, method: .get) { data in
            if let data = data {
                do {
                    let company = try JSONDecoder().decode(Company.self, from: data)
                    completionHandler(company)
                } catch let error {
                    print(error.localizedDescription)
                    completionHandler(nil)
                }
            }
        }
    }
    
    /// Fetch Lauches
    class func fetchLaunches(completionHandler: @escaping ([Launches]?) -> Void) {
        let url = "https://api.spacexdata.com/v4/launches"
        request(url: url, method: .get) { data in
            if let data = data {
                do {
                    let launches = try JSONDecoder().decode([Launches].self, from: data)
                    completionHandler(launches)
                } catch let error {
                    print(error.localizedDescription)
                    completionHandler(nil)
                }
            }
        }
    }
}

extension Date {
    func toString(dateFormat: String, timeZone: TimeZone = .current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: self)
    }
}

