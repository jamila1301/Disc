//
//  NetworkError.swift
//  Disc
//
//  Created by Jamila Mahammadli on 09.10.25.
//

import Foundation

struct NetworkError: Decodable, Error {
    let error: CustomError
    
    struct CustomError: Decodable {
        let message: String
    }
}
