//
//  GetUsers.swift
//  Eko Task
//
//  Created by apple on 12/16/19.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation
import Alamofire

class UsersWebService {

func getUsersList(controller: UIViewController, dataURL: String,apiTitle: String,view:UIView,completion: @escaping (_ users : [AllUsers]) -> Void ){

    Alamofire.request(dataURL, method: .get, encoding: JSONEncoding.default).responseJSON(completionHandler:
        {
            ( response  ) in
            do {
                let jsonDecoder = JSONDecoder()
                let users = try jsonDecoder.decode([AllUsers].self, from: response.data!)
                completion(users)
            } catch {
                
            }
            
    })
}

}

