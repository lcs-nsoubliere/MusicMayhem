//
//  SharedFunctionsAndConstants.swift
//  MusicMayhem
//
//  Created by Noah Alexandre Soubliere on 2022-05-06.
//

import Foundation

import Foundation

//return the location of the documents directory for this app
func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)
    
    //Return the first path
    return paths[0]
}

//define a filename (label) that we will write the data to in
//the directory
let savedFavouritesLabel = "savedFavourites"
