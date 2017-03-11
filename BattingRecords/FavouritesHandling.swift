//
//  FavouritesHandling.swift
//  BattingRecords
//
//  Created by Abhinav Mathur on 12/03/17.
//  Copyright © 2017 Abhinav Mathur. All rights reserved.
//

import Foundation
import CoreData

class FavouritesHandling {
    
    func returnFavouriteInformation(info : AnyObject) -> Bool
    {
        var returnValue : Bool = false
        let managedContext = CoreDataStack.getInstance().managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouriteRecords")
        fetchRequest.predicate = NSPredicate(format:"playerInfo = %@", info as! CVarArg)

        do {
            let results = try managedContext.fetch(fetchRequest)
            let group = results as! [NSManagedObject]
            if group.count != 0{
               returnValue = true
            }
            else
            {
                returnValue = false
            }
        }  catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return returnValue
    }

    func setFavouriteInformation(info : AnyObject)
    {
        let managedContext = CoreDataStack.getInstance().managedObjectContext
        let entity =  NSEntityDescription.entity(forEntityName: "FavouriteRecords",in:managedContext)

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouriteRecords")
        fetchRequest.predicate = NSPredicate(format:"playerInfo = %@", info as! CVarArg)
        do {
            let results = try managedContext.fetch(fetchRequest)
            let group = results as! [NSManagedObject]
            if group.count != 0{
                for i in 0  ..< group.count
                {
                    managedContext.delete(group[i])
                }
            }
            else
            {
                let msgupdate = NSManagedObject(entity: entity!,insertInto: managedContext)
                msgupdate.setValue(info,forKey: "playerInfo")
            }
            do {
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
        }  catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    func returnAllFavouritePlayers() -> Array<AnyObject>
    {
        var returnValue : Array<AnyObject> = []
        let managedContext = CoreDataStack.getInstance().managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavouriteRecords")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            let group = results as! [NSManagedObject]
            if group.count != 0{
                for i in 0  ..< group.count
                {
                    returnValue.append(group[i].value(forKey: "playerInfo") as AnyObject)

                }
            }
        }  catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return returnValue
    }
}
