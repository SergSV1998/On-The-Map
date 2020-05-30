//
//  Response 6.0.swift
//  On The Map
//
//  Created by Sergey on 30/12/19.
//  Copyright © 2019 Sergey. All rights reserved.
//
import Foundation
import UIKit
var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt")!)
let session = URLSession.shared
let task = session.dataTask(with: request) { data, response, error in
  if error != nil {
      return
  }
  print(String(data: data!, encoding: .utf8)!)
   ///task.resume()
}
