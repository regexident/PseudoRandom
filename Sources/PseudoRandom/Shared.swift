// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

@inlinable
@inline(__always)
internal func rotl(_ x: UInt64, _ k: UInt64) -> UInt64 {
    return (x << k) | (x >> (64 &- k))
}
