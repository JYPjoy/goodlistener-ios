//
//  BaseTargetType.swift
//  GoodListener
//
//  Created by cheonsong on 2022/08/31.
//

import Moya

protocol BaseTargetType: TargetType {
}

extension BaseTargetType {
    var baseURL: URL {
        // Configuration을 통해 phase별 baseURL 설정 방법: https://ios-development.tistory.com/660
//        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else { fatalError("API URL not defined")}
//        gaurd let apiURL = URL(string: urlString) else { fatalError("URL is invalid") }

        return URL(string: Host.Host)!
    }
    
    // HTTP header
    //  return ["Content-type": "application/json"]
    var headers: [String : String]? {
        return ["Content-type": "application/json",
                "Authorization": UserDefaultsManager.shared.accessToken!]
    }
    
    
    // 테스트용 Mock Data
    var sampleData: Data {
        return Data()
    }
}
