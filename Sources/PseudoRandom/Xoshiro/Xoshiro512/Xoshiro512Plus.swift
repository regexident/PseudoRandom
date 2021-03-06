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

/// Implementation of [Xoshiro512+](http://prng.di.unimi.it/xoshiro256plus.c)
/// ([Paper](http://vigna.di.unimi.it/ftp/papers/ScrambledLinear.pdf))
///
/// # Original documentation:
///
/// > This is `xoshiro512+` 1.0, our generator for floating-point numbers with
/// > increased state size. We suggest to use its upper bits for
/// > floating-point generation, as it is slightly faster than `xoshiro512**`.
/// > It passes all tests we are aware of except for the lowest three bits,
/// > which might fail linearity tests (and just those), so if low linear
/// > complexity is not considered an issue (as it is usually the case) it
/// > can be used to generate 64-bit outputs, too.
/// >
/// > We suggest to use a sign test to extract a random Boolean value, and
/// > right shifts to extract subsets of bits.
/// >
/// > The `state` must be seeded so that it is not everywhere zero. If you have
/// > a 64-bit seed, we suggest to seed a `splitmix64` generator and use its
/// > output to fill `state`.
public struct Xoshiro512Plus {
    public typealias State = Xoshiro512.State

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

        var state: State = Xoshiro512.invalidState
        repeat {
            state = (
                generator.next(),
                generator.next(),
                generator.next(),
                generator.next(),
                generator.next(),
                generator.next(),
                generator.next(),
                generator.next()
            )
        } while !Xoshiro512.isValid(state: state)

        self.init(state: state)
    }

    /// Creates a seeded generator.
    ///
    /// - Important:
    ///   The value of `state` must not be `(0, 0, 0, 0)`.
    ///
    /// - Parameter state: The initial seed
    public init(state: State) {
        precondition(
            Xoshiro512.isValid(state: state),
            "The state must not be all zeros"
        )
        self.s = state
    }
}

extension Xoshiro512Plus: Stateful {}

extension Xoshiro512Plus: RandomNumberGenerator {
    public mutating func next() -> UInt64 {
        self.next { s in
            let result = s.0 &+ s.2

            let t = s.1 << 11

            s.2 ^= s.0
            s.5 ^= s.1
            s.1 ^= s.2
            s.7 ^= s.3
            s.3 ^= s.4
            s.4 ^= s.5
            s.0 ^= s.6
            s.6 ^= s.7

            s.6 ^= t

            s.7 = rotl(s.7, 21)

            return result
        }
    }
}
