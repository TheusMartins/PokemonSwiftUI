//
//  PokedexListingRouterTests.swift
//  PokedexListing
//
//  Created by Matheus Martins on 11/01/26.
//

import XCTest
@testable import PokedexListing

@MainActor
final class PokedexListingRouterTests: XCTestCase {

    func test_init_givenRouter_whenCreated_thenStartsWithEmptyPath() {
        // Given
        let sut = makeSUT()

        // Then
        XCTAssertTrue(sut.path.isEmpty)
    }

    func test_push_givenEmptyPath_whenPushingRoute_thenAppendsRouteToPath() {
        // Given
        let sut = makeSUT()

        // When
        sut.push(.pokemonDetails(name: "scizor"))

        // Then
        XCTAssertEqual(sut.path, [.pokemonDetails(name: "scizor")])
    }

    func test_pop_givenPathWithOneElement_whenCalled_thenRemovesLastElement() {
        // Given
        let sut = makeSUT()
        sut.push(.pokemonDetails(name: "scizor"))

        // When
        sut.pop()

        // Then
        XCTAssertTrue(sut.path.isEmpty)
    }

    func test_pop_givenEmptyPath_whenCalled_thenDoesNothing() {
        // Given
        let sut = makeSUT()

        // When
        sut.pop()

        // Then
        XCTAssertTrue(sut.path.isEmpty)
    }

    // MARK: - Pop to Root

    func test_popToRoot_givenMultipleRoutes_whenCalled_thenClearsPath() {
        // Given
        let sut = makeSUT()
        sut.push(.pokemonDetails(name: "scizor"))
        sut.push(.pokemonDetails(name: "pikachu"))

        // When
        sut.popToRoot()

        // Then
        XCTAssertTrue(sut.path.isEmpty)
    }

    func test_openPokemonDetails_givenExistingPath_whenCalled_thenReplacesPathWithSingleDetailsRoute() {
        // Given
        let sut = makeSUT()
        sut.push(.pokemonDetails(name: "pikachu"))

        // When
        sut.openPokemonDetails(name: "scizor")

        // Then
        XCTAssertEqual(sut.path, [.pokemonDetails(name: "scizor")])
    }

    // MARK: - Helpers

    private func makeSUT() -> PokedexListingRouter {
        PokedexListingRouter()
    }
}
