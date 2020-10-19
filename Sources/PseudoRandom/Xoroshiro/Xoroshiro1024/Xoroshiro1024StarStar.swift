// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// Original license:
//
// > Written in 2018 by David Blackman and Sebastiano Vigna (vigna@acm.org)
// >
// > To the extent possible under law, the author has dedicated all copyright
// > and related and neighboring rights to this software to the public domain
// > worldwide. This software is distributed without any warranty.
// >
// > See <http://creativecommons.org/publicdomain/zero/1.0/>. */

/// Implementation of [Xoshiro256+](http://prng.di.unimi.it/xoshiro256plus.c)
/// ([Paper](http://vigna.di.unimi.it/ftp/papers/ScrambledLinear.pdf))
///
/// # Original documentation:
///
/// > This is `xoroshiro1024**` 1.0, one of our all-purpose, rock-solid,
/// > large-state generators. It is extremely fast and it passes all
/// > tests we are aware of. Its state however is too large--in general,
/// > the `xoshiro256` family should be preferred.
/// >
/// > For generating just floating-point numbers, `xoroshiro1024*` is even
/// > faster (but it has a very mild bias, see notes in the comments).
/// >
/// > The `state` must be seeded so that it is not everywhere zero. If you have
/// > a 64-bit seed, we suggest to seed a `splitmix64` generator and use its
/// > output to fill `state`.
public struct Xoroshiro1024StarStar {
    public typealias Param = Xoroshiro1024.Param
    public typealias State = Xoroshiro1024.State

    public internal(set) var p: Param
    public internal(set) var s: State

    /// Creates a randomly seeded generator.
    public init() {
        var generator = SystemRandomNumberGenerator()
        let seed = generator.next()
        self.init(seed: seed)
    }

    /// Creates a seeded generator.
    /// - Parameter seed: The initial seed
    public init(seed: UInt64) {
        var generator = SplitMix64(state: seed)

        let paramRange = Xoroshiro1024.paramRange
        let param: Param = paramRange.randomElement(
            using: &generator
        )!

        var state: State = Xoroshiro1024.invalidState
        repeat {
            state = (0..<16).map { _ in generator.next() }
        } while !Xoroshiro1024.isValid(state: state)

        self.init(param: param, state: state)
    }

    /// Creates a seeded generator.
    ///
    /// - Important:
    ///   The value of `state` must not be `(0, 0)`.
    ///
    /// - Parameter state: The initial seed
    public init(param: Param, state: State) {
        precondition(
            Xoroshiro1024.isValid(param: param),
            "The param must be within 0..<16"
        )
        precondition(
            Xoroshiro1024.isValid(state: state),
            "The state must not be all zeros"
        )
        self.p = param
        self.s = state
    }
}

extension Xoroshiro1024StarStar: Stateful {}
extension Xoroshiro1024StarStar: ExtendedStateful {}

extension Xoroshiro1024StarStar: RandomNumberGenerator {
    public mutating func next() -> UInt64 {
        self.next { p, s in
            let q = p
            p = (p + 1) & 15
            let s0 = s[p]
            var s15 = s[q]
            let result = rotl(s0 * 5, 7) * 9

            s15 ^= s0
            s[q] = rotl(s0, 25) ^ s15 ^ (s15 << 27)
            s[p] = rotl(s15, 36)

            return result
        }
    }
}
