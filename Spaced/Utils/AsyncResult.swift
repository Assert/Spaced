//
//  AsyncResult.swift
//  ZedgeBase
//
//  Created by Attila on 06/01/2017.
//  Copyright © 2017 Zedge AS. All rights reserved.
//

import Foundation

enum AsyncOperationState<ResultType> {
    case initialized
    case success(ResultType)
    case failure(Error)
}

struct AsyncOperationCompletion<ResultType> {
    
    let queue: DispatchQueue
    let onSuccess: (ResultType) -> ()
    let onFailure: (Error) -> ()
    
    func success(withValue value: ResultType) {
        queue.async {
            self.onSuccess(value)
        }
    }
    
    func failure(withError error: Error) {
        queue.async {
            self.onFailure(error)
        }
    }
}

public final class AsyncOperation<ResultType> {
    
    private let operationQueue = DispatchQueue(label: "async.operationqueue", qos: .userInitiated)
    private var state: AsyncOperationState<ResultType>
    private var completionBlocks: [AsyncOperationCompletion<ResultType>] = []
    
    public init(value: ResultType) {
        state = .success(value)
    }
    
    public init(error: Error) {
        state = .failure(error)
    }
    
    public init(_ operation: @escaping (_ success: @escaping (ResultType) -> (), _ failure: @escaping (Error) -> ()) throws -> () ) {
        state = .initialized
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try operation(self.success, self.failure)
            } catch let error {
                self.failure(withError: error)
            }
        }
    }
    
    func success(withValue value: ResultType) {
        operationQueue.sync {
            state = .success(value)
        }
        processCompletions()
    }
    
    func failure(withError error: Error) {
        operationQueue.sync {
            state = .failure(error)
        }
        processCompletions()
    }
    
    func processCompletions() {
        operationQueue.async {
            if case .initialized = self.state { return }
            for completion in self.completionBlocks {
                switch self.state {
                case let .success(result):
                    completion.success(withValue: result)
                    
                case let .failure(error):
                    completion.failure(withError: error)
                    
                default:
                    break
                }
            }
            
            self.completionBlocks.removeAll()
        }
    }
    
    func addCompletion(on queue: DispatchQueue = .main, onSuccess: @escaping (ResultType) -> (), onFailure: @escaping (Error) -> ()) {
        operationQueue.async(execute: {
            self.completionBlocks.append(AsyncOperationCompletion(queue: queue,
                                                                  onSuccess: onSuccess,
                                                                  onFailure: onFailure))
        })
        processCompletions()
    }
    
    @discardableResult
    public func then(on queue: DispatchQueue = .main, if condition: Bool = true, _ onSuccess: @escaping (ResultType) throws -> ()) -> AsyncOperation<ResultType> {
        return AsyncOperation<ResultType> { success, failure in
            self.addCompletion(on: queue,
                               onSuccess: { result in
                                guard condition else {
                                    success(result)
                                    return
                                }
                                
                                do {
                                    try onSuccess(result)
                                    success(result)
                                } catch {
                                    failure(error)
                                }
            },
                               onFailure: failure)
        }
    }
    
    @discardableResult
    public func then<NewResultType>(on queue: DispatchQueue = .main, _ onSuccess: @escaping (ResultType) throws -> (NewResultType)) -> AsyncOperation<NewResultType> {
        return then(on: queue) { result -> AsyncOperation<NewResultType> in
            do {
                return AsyncOperation<NewResultType>(value: try onSuccess(result))
            } catch {
                return AsyncOperation<NewResultType>(error: error)
            }
        }
    }
    
    @discardableResult
    public func then<NewResultType>(on queue: DispatchQueue = .main, _ onSuccess: @escaping (ResultType) throws -> AsyncOperation<NewResultType>) -> AsyncOperation<NewResultType> {
        return AsyncOperation<NewResultType> { success, failure in
            self.addCompletion(on: queue,
                               onSuccess: { result in
                                do {
                                    _ = try onSuccess(result).then(success).catch(failure)
                                } catch {
                                    failure(error)
                                }
            },
                               onFailure: failure)
        }
    }
    
    @discardableResult
    public func finally(_ completion: @escaping () -> ()) -> AsyncOperation<ResultType> {
        return AsyncOperation { success, failure in
            self.addCompletion(onSuccess: { _ in completion() },
                               onFailure: { _ in completion() })
        }
    }
    
    @discardableResult
    public func `catch`(_ onFailure: @escaping (Error) -> ()) -> AsyncOperation<ResultType> {
        return AsyncOperation { success, failure in
            self.addCompletion(
                onSuccess: success,
                onFailure: { error in
                    failure(error)
                    onFailure(error)
            }
            )
        }
    }
    
    public var isFailed: Bool {
        guard case .failure = state else { return false }
        return true
    }
    
    public var isPending: Bool {
        guard case .initialized = state else { return false }
        return true
    }
    
    public var value: ResultType? {
        guard case .success(let value) = state else { return nil }
        return value
    }
}

public enum AsyncOperations {
    
    public static func all<T>(_ operations: [AsyncOperation<T>]) -> AsyncOperation<[T]> {
        return AsyncOperation<[T]> { success, failure in
            guard operations.count > 0 else {
                success([])
                return
            }
            
            for operation in operations {
                operation.then { value in
                    if !operations.contains(where: { $0.isFailed || $0.isPending }) {
                        success(operations.flatMap({ $0.value }))
                    }
                    } .catch { error in
                        failure(error)
                }
            }
        }
    }
}
