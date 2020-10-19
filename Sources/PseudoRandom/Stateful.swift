// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

internal protocol Stateful {
    associatedtype State

    var s: State { get set }

    mutating func next(
        _ closure: (inout State) -> UInt64
    ) -> UInt64
}

extension Stateful {
    @usableFromInline
    internal mutating func next(
        _ closure: (inout State) -> UInt64
    ) -> UInt64 {
        closure(&self.s)
    }
}

internal protocol ExtendedStateful: Stateful {
    associatedtype Param

    var p: Param { get set }
    var s: State { get set }

    mutating func next(
        _ closure: (inout Param, inout State) -> UInt64
    ) -> UInt64
}

extension ExtendedStateful {
    @usableFromInline
    internal mutating func next(
        _ closure: (inout Param, inout State) -> UInt64
    ) -> UInt64 {
        var (p, s) = (self.p, self.s)
        defer {
            (self.p, self.s) = (p, s)
        }
        return closure(&p, &s)
    }
}
