import XCTest
@testable import PseudoRandom

final class PseudoRandomTests: XCTestCase {
    typealias Domain = UInt16

    let domain: ClosedRange<Domain> = (Domain.min)...(Domain.max)

    let samples: Int = 500_000

    let minEfficiency: Double = 0.99

    func testSystemRandomNumberGenerator() throws {
        let efficiency = self.efficiency(
            using: SystemRandomNumberGenerator()
        )

        XCTAssertGreaterThanOrEqual(efficiency, self.minEfficiency)
    }

    // MARK: - SplitMix64

    func testSplitMix64() throws {
        let efficiency = self.efficiency(
            using: SplitMix64(
                state: 0
            )
        )

        XCTAssertGreaterThanOrEqual(efficiency, self.minEfficiency)
    }

    // MARK: - Xoroshiro128

    func testXoroshiro128Plus() throws {
        let efficiency = self.efficiency(
            using: Xoroshiro128Plus(
                seed: 0
            )
        )

        XCTAssertGreaterThanOrEqual(efficiency, self.minEfficiency)
    }

    func testXoroshiro128PlusPlus() throws {
        let efficiency = self.efficiency(
            using: Xoroshiro128PlusPlus(
                seed: 0
            )
        )

        XCTAssertGreaterThanOrEqual(efficiency, self.minEfficiency)
    }

    func testXoroshiro128StarStar() throws {
        let efficiency = self.efficiency(
            using: Xoroshiro128StarStar(
                seed: 0
            )
        )

        XCTAssertGreaterThanOrEqual(efficiency, self.minEfficiency)
    }

    // MARK: - Xoroshiro1024

    func testXoroshiro1024PlusPlus() throws {
        let efficiency = self.efficiency(
            using: Xoroshiro1024PlusPlus(
                seed: 0
            )
        )

        XCTAssertGreaterThanOrEqual(efficiency, self.minEfficiency)
    }

    func testXoroshiro1024Star() throws {
        let efficiency = self.efficiency(
            using: Xoroshiro1024Star(
                seed: 0
            )
        )

        XCTAssertGreaterThanOrEqual(efficiency, self.minEfficiency)
    }

    func testXoroshiro1024StarStar() throws {
        let efficiency = self.efficiency(
            using: Xoroshiro1024StarStar(
                seed: 0
            )
        )

        XCTAssertGreaterThanOrEqual(efficiency, self.minEfficiency)
    }

    // MARK: - Xoshiro256

    func testXoshiro256Plus() throws {
        let efficiency = self.efficiency(
            using: Xoshiro256Plus(
                seed: 0
            )
        )

        XCTAssertGreaterThanOrEqual(efficiency, self.minEfficiency)
    }

    func testXoshiro256PlusPlus() throws {
        let efficiency = self.efficiency(
            using: Xoshiro256PlusPlus(
                seed: 0
            )
        )

        XCTAssertGreaterThanOrEqual(efficiency, self.minEfficiency)
    }

    func testXoshiro256StarStar() throws {
        let efficiency = self.efficiency(
            using: Xoshiro256StarStar(
                seed: 0
            )
        )

        XCTAssertGreaterThanOrEqual(efficiency, self.minEfficiency)
    }

    // MARK: - Xoshiro512

    func testXoshiro512Plus() throws {
        let efficiency = self.efficiency(
            using: Xoshiro512Plus(
                seed: 0
            )
        )

        XCTAssertGreaterThanOrEqual(efficiency, self.minEfficiency)
    }

    func testXoshiro512PlusPlus() throws {
        let efficiency = self.efficiency(
            using: Xoshiro512PlusPlus(
                seed: 0
            )
        )

        XCTAssertGreaterThanOrEqual(efficiency, self.minEfficiency)
    }

    func testXoshiro512StarStar() throws {
        let efficiency = self.efficiency(
            using: Xoshiro512StarStar(
                seed: 0
            )
        )

        XCTAssertGreaterThanOrEqual(efficiency, self.minEfficiency)
    }
}

// MARK: - Auxiliary
extension PseudoRandomTests {
    func efficiency<Generator>(
        using generator: Generator
    ) -> Double
    where
        Generator: RandomNumberGenerator
    {
        var generator = generator
        let domain = self.domain

        var analysis: ShannonEntropy<Domain> = .init(
            domainCount: domain.count
        )

        for _ in 0..<self.samples {
            let observation = Domain.random(in: domain, using: &generator)
            analysis.add(observation: observation)
        }

        return analysis.efficiency()
    }

    static var allTests = [
        ("testSplitMix64", testSplitMix64),
    ]
}
