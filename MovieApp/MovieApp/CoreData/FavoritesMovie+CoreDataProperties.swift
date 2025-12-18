//
//  FavoritesMovie+CoreDataProperties.swift
//  MovieApp
//
//  Created by goha on 17.12.2025.
//
//

import Foundation
import CoreData


extension FavoritesMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritesMovie> {
        return NSFetchRequest<FavoritesMovie>(entityName: "FavoritesMovie")
    }

    @NSManaged public var title: String?
    @NSManaged public var imdbID: String?
    @NSManaged public var year: Int16
    @NSManaged public var actors: String?
    @NSManaged public var posterURL: String?

}

extension FavoritesMovie : Identifiable {

}
