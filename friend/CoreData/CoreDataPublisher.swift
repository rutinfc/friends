//
//  CoreDataPublisher.swift
//  Friend
//
//  Created by JK Kim on 2022/12/15.
//

import Combine
import CoreData
import Foundation

class CoreDataPublisher<Entity, Failure>: NSObject,
                                            NSFetchedResultsControllerDelegate,
                                            Publisher where Entity: NSManagedObject, Failure: Error {

    typealias Output = [Entity]
    
    private let request: NSFetchRequest<Entity>
    private let context: NSManagedObjectContext
    private let subject: CurrentValueSubject<[Entity], Failure>
    private var resultController: NSFetchedResultsController<NSManagedObject>?
    private var subscriptions = 0
    
    init(request: NSFetchRequest<Entity>, context: NSManagedObjectContext) {
        if request.sortDescriptors == nil { request.sortDescriptors = [] }
        self.request = request
        self.context = context
        self.subject = CurrentValueSubject([])
        super.init()
    }
    
    func receive<S>(subscriber: S)
    where S: Subscriber, CoreDataPublisher.Failure == S.Failure, CoreDataPublisher.Output == S.Input {
        var start = false
        
        objc_sync_enter(self)
        subscriptions += 1
        start = subscriptions == 1
        objc_sync_exit(self)
        
        if start {
            let controller = NSFetchedResultsController(fetchRequest: self.request, managedObjectContext: self.context,
                                                        sectionNameKeyPath: nil, cacheName: nil)
            controller.delegate = self
            self.context.perform { [weak self] in
                guard let self = self else { return }
                do {
                    try controller.performFetch()
                    let result = controller.fetchedObjects ?? []
                    self.subject.send(result)
                } catch {
                    if let error = error as? Failure {
                        self.subject.send(completion: .failure(error))
                    }
                }
            }
            self.resultController = controller as? NSFetchedResultsController<NSManagedObject>
        }
        CoreDataSubscription(fetchPublisher: self, subscriber: AnySubscriber(subscriber))
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let result = controller.fetchedObjects as? [Entity] ?? []
        self.subject.send(result)
    }
    
    private func dropSubscription() {
        objc_sync_enter(self)
        subscriptions -= 1
        let stop = subscriptions == 0
        objc_sync_exit(self)
        
        if stop {
            self.resultController?.delegate = nil
            self.resultController = nil
        }
    }
    
    private class CoreDataSubscription: Subscription {
        private var fetchPublisher: CoreDataPublisher?
        private var cancellable: AnyCancellable?
        
        @discardableResult
        init(fetchPublisher: CoreDataPublisher, subscriber: AnySubscriber<Output, Failure>) {
            self.fetchPublisher = fetchPublisher
            
            subscriber.receive(subscription: self)
            
            self.cancellable = fetchPublisher.subject.sink(receiveCompletion: { completion in
                subscriber.receive(completion: completion)
            }, receiveValue: { value in
                _ = subscriber.receive(value)
            })
        }
        
        func request(_ demand: Subscribers.Demand) {}
        
        func cancel() {
            self.cancellable?.cancel()
            self.cancellable = nil
            self.fetchPublisher?.dropSubscription()
            self.fetchPublisher = nil
        }
    }
}
