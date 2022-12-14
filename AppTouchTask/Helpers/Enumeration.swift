//
//  Enumeration.swift
//  AppTouchTask
//
//  Created by Tejas Gowda KC on 14/12/22.
//

import Foundation

enum Filter: String, CaseIterable {
    case years = "Year(s)"
    case successful = "Successful launches"
    case fialures = "Failed launches" 
}

enum SortOrder: String, CaseIterable {
    case asc = "Ascending"
    case desc = "Descending"
}
