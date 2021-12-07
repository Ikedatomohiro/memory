//
//  Address.swift
//  memory
//
//  Created by Tomohiro Ikeda on 2021/12/04.
//

import UIKit
import Alamofire
import CoreLocation

class GetAddress {
    /// APIを利用して郵便番号から住所を取得
    static func callZipCloudApi(zipcode: String, completion: @escaping (String) -> ()) {
        
        var resultText: String = ""
        /// 郵便番号チェック
        if !checkZipcode(zipcode: zipcode) { return }
        
        let apiURL = "https://zipcloud.ibsnet.co.jp/api/search?zipcode=\(zipcode)"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Ios-Bundle-Identifier": Bundle.main.bundleIdentifier ?? "",
        ]
        AF.request(
            apiURL,
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers)
            .responseJSON() { response in
                // JSONデコード
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                do {
                    let decoded: ZipCloudApiResponse = try decoder.decode(ZipCloudApiResponse.self, from: response.data ?? Data())
                    if let address = decoded.results {
                        resultText = address[0].address1 + address[0].address2 + address[0].address3
                    }
                    completion(resultText)
                } catch {
                    print(error.localizedDescription)
                }
            }
        return
    }
    
    /// ライブラリで郵便番号から住所を取得
    static func transferZipcodeToAdress(zipcode: String, completion: @escaping (String) -> ()) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(zipcode, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                //                print("State:       \(placemark.administrativeArea)")
                //                print("City:        \(placemark.locality)")
                //                print("SubLocality: \(placemark.subLocality)")
                completion("address")
            }
        })
    }
    
    /// 郵便番号の入力チェック
    static func checkZipcode(zipcode: String) -> Bool {
        let pattern = "^[0-9]{3}-?[0-9]{4}$"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return false }
        let results = regex.matches(in: zipcode, options: [], range: NSRange(0..<zipcode.count))
        if (results.count == 0) {
            return false
        }
        return true
    }
}

// MARK: - CloudVisionApiレスポンス解析
struct ZipCloudApiResponse: Codable {
    let message: String?
    let results: [Result]?
    struct Result: Codable {
        let address1, address2, address3, kana1: String
        let kana2, kana3, prefcode, zipcode: String
    }
    let status: Int
}
