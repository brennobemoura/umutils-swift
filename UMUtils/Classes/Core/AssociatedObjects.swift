//
//  AssociatedObjects.swift
//  Pods
//
//  Created by Ramon Vicente on 16/03/17.
//
//

public var AssociatedKey: UInt = 0

public final class ObjectAssociation<T> {

    private let policy: objc_AssociationPolicy

    /// - Parameter policy: An association policy that will be used when linking objects.
    public init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {

        self.policy = policy
    }

    /// Accesses associated object.
    /// - Parameter index: An object whose associated object is to be accessed.
    public subscript(index: AnyObject) -> T? {

        get { return objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as! T? }
        set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) }
    }
}

public func setAssociatedObject<T>(object: AnyObject, value: T, key: UnsafeRawPointer, policy: objc_AssociationPolicy) {
    if let associated = objc_getAssociatedObject(object, key) as? ObjectAssociation<T> {
        associated[object] = value
        return
    }

    let associated = ObjectAssociation<T>(policy: policy)
    associated[object] = value
    objc_setAssociatedObject(object, key, associated, .OBJC_ASSOCIATION_RETAIN)
}

public func getLazyObject<T>(object: AnyObject, key: UnsafeRawPointer, loader handler: (() -> T)) -> T {
    if let t: T = getAssociatedObject(object: object, key: key) {
        return t
    }
    
    let t = handler()
    setAssociatedObject(object: object, value: t, key: key, policy: .OBJC_ASSOCIATION_RETAIN)
    return t
}

public func getAssociatedObject<T>(object: AnyObject, key: UnsafeRawPointer) -> T? {
    return (objc_getAssociatedObject(object, key) as? ObjectAssociation<T>)?[object]
}
