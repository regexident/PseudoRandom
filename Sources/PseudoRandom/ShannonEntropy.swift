import Foundation

/// Implementation of Shannon entropy
public struct ShannonEntropy<T> where T: Hashable {
    public private(set) var observations: [T: Int]
    public private(set) var observationCount: Int
    public private(set) var domainCount: Int

    /// Creates a Shannon entropy analysis.
    ///
    /// - Parameters
    ///   - domain: The number of possible unique values in the domain.
    public init(domainCount: Int) {
        assert(domainCount > 0)

        self.observations = [:]
        self.observationCount = 0
        self.domainCount = domainCount
    }

    /// Add element observations to the analysis.
    ///
    /// - Parameters:
    ///   - observations: The observed elements to add.
    public mutating func add<S>(observations elements: S)
    where
        S: Sequence, S.Element == T
    {
        for element in elements {
            self.add(observation: element)
        }
    }

    /// Add an element observation to the analysis.
    ///
    /// - Parameters:
    ///   - observation: The observed element to add.
    public mutating func add(observation element: T) {
        self.observations[element, default: 0] += 1
    }

    /// Calculates the Shannon entropy of the observations.
    /// - Returns: The Shannon entropy
    public func entropy() -> Double {
        assert(self.observations.count <= self.domainCount)

        var entropy: Double = 0.0
        let domainScale: Double = 1.0 / Double(self.domainCount)

        let scaledProbabilities = self.observations.values.map { observation in
            Double(observation) * domainScale
        }

        let totalProbability = scaledProbabilities.reduce(0.0, +)
        let probabilityScale: Double = 1.0 / totalProbability

        for scaledProbability in scaledProbabilities {
            let probability = scaledProbability * probabilityScale
            entropy += probability * log2(probability)
        }

        return -entropy
    }

    /// Calculates the normalized Shannon entropy (aka efficiency) of the observations.
    /// - Returns: The normalized Shannon entropy (aka efficiency)
    public func efficiency() -> Double {
        let entropy = self.entropy()
        let base = log2(Double(self.domainCount))

        return entropy / base
    }
}
