//
//  DeepLinkCoordinatorTests.swift
//  PokedexShowcase
//
//  Created by Matheus Martins on 15/01/26.
//

import XCTest
@testable import PokedexShowcase
import PokedexListing

@MainActor
final class DeepLinkCoordinatorTests: XCTestCase {

    // MARK: - pokemonDetails

    func test_handle_givenPokemonDetails_thenPresentsPokemon_andDoesNotChangeSelectedTab() {
        // Given
        let (sut, _) = makeSUT(initialTab: .team)

        // When
        sut.handle(.pokemonDetails(name: "bulbasaur"))

        // Then
        XCTAssertEqual(sut.selectedTab, .team)
        XCTAssertEqual(sut.presentedPokemon, PresentedPokemon(name: "bulbasaur"))
    }

    // MARK: - dismiss

    func test_dismissPresentedPokemon_givenPokemonPresented_thenClearsPresentedPokemon() {
        // Given
        let (sut, _) = makeSUT()
        sut.presentedPokemon = PresentedPokemon(name: "pikachu")

        // When
        sut.dismissPresentedPokemon()

        // Then
        XCTAssertNil(sut.presentedPokemon)
    }

    // MARK: - team

    func test_handle_givenTeam_thenSelectsTeamTab_andClearsPresentedPokemon() {
        // Given
        let (sut, _) = makeSUT(initialTab: .pokedex)
        sut.presentedPokemon = PresentedPokemon(name: "mew")

        // When
        sut.handle(.team)

        // Then
        XCTAssertEqual(sut.selectedTab, .team)
        XCTAssertNil(sut.presentedPokemon)
    }

    // MARK: - pokedex without generation

    func test_handle_givenPokedexWithNilGeneration_thenSelectsPokedexTab_andClearsPresentedPokemon_andDoesNotTouchContext() {
        // Given
        let context = PokedexListingSearchContext(selectedGenerationId: "generation-iii")
        let (sut, _) = makeSUT(searchContext: context, initialTab: .team)
        sut.presentedPokemon = PresentedPokemon(name: "mew")

        // When
        sut.handle(.pokedex(generationId: nil))

        // Then
        XCTAssertEqual(sut.selectedTab, .pokedex)
        XCTAssertNil(sut.presentedPokemon)
        XCTAssertEqual(context.selectedGenerationId, "generation-iii")
    }

    func test_handle_givenPokedexWithEmptyGeneration_thenSelectsPokedexTab_andClearsPresentedPokemon_andDoesNotTouchContext() {
        // Given
        let context = PokedexListingSearchContext(selectedGenerationId: "generation-ii")
        let (sut, _) = makeSUT(searchContext: context)

        // When
        sut.handle(.pokedex(generationId: ""))

        // Then
        XCTAssertEqual(sut.selectedTab, .pokedex)
        XCTAssertNil(sut.presentedPokemon)
        XCTAssertEqual(context.selectedGenerationId, "generation-ii")
    }

    func test_handle_givenPokedexWithWhitespaceGeneration_thenSelectsPokedexTab_andClearsPresentedPokemon_andDoesNotTouchContext() {
        // Given
        let context = PokedexListingSearchContext(selectedGenerationId: "generation-i")
        let (sut, _) = makeSUT(searchContext: context)

        // When
        sut.handle(.pokedex(generationId: "   "))

        // Then
        XCTAssertEqual(sut.selectedTab, .pokedex)
        XCTAssertNil(sut.presentedPokemon)
        XCTAssertEqual(context.selectedGenerationId, "generation-i")
    }

    // MARK: - pokedex with generation (normalization)

    func test_handle_givenPokedexWithGenerationAlreadyNormalized_thenWritesLowercasedToContext() {
        // Given
        let context = PokedexListingSearchContext(selectedGenerationId: nil)
        let (sut, _) = makeSUT(searchContext: context)

        // When
        sut.handle(.pokedex(generationId: "Generation-III"))

        // Then
        XCTAssertEqual(sut.selectedTab, .pokedex)
        XCTAssertNil(sut.presentedPokemon)
        XCTAssertEqual(context.selectedGenerationId, "generation-iii")
    }

    func test_handle_givenPokedexWithNumericGeneration_thenNormalizesToRomanAndWritesToContext() {
        // Given
        let context = PokedexListingSearchContext(selectedGenerationId: nil)
        let (sut, _) = makeSUT(searchContext: context)

        // When
        sut.handle(.pokedex(generationId: "3"))

        // Then
        XCTAssertEqual(context.selectedGenerationId, "generation-iii")
    }

    func test_handle_givenPokedexWithNumericGenerationAndSpaces_thenTrimsNormalizesAndWritesToContext() {
        // Given
        let context = PokedexListingSearchContext(selectedGenerationId: nil)
        let (sut, _) = makeSUT(searchContext: context)

        // When
        sut.handle(.pokedex(generationId: "  1  "))

        // Then
        XCTAssertEqual(context.selectedGenerationId, "generation-i")
    }

    func test_handle_givenPokedexWithOutOfRangeNumericGeneration_thenWritesLowercasedRawToContext() {
        // Given
        let context = PokedexListingSearchContext(selectedGenerationId: nil)
        let (sut, _) = makeSUT(searchContext: context)

        // When
        sut.handle(.pokedex(generationId: "10"))

        // Then
        XCTAssertEqual(context.selectedGenerationId, "10")
    }

    func test_handle_givenPokedexWithNonNumericNonNormalizedGeneration_thenWritesLowercasedRawToContext() {
        // Given
        let context = PokedexListingSearchContext(selectedGenerationId: nil)
        let (sut, _) = makeSUT(searchContext: context)

        // When
        sut.handle(.pokedex(generationId: "GENERATION_SPECIAL"))

        // Then
        XCTAssertEqual(context.selectedGenerationId, "generation_special")
    }

    // MARK: - binding behavior

    func test_handle_givenPokedexWithGeneration_andNoContextBound_thenDoesNotCrash_andStillSelectsPokedexTab() {
        // Given
        let (sut, _) = makeSUT(searchContext: nil, initialTab: .team)
        sut.presentedPokemon = PresentedPokemon(name: "mew")

        // When
        sut.handle(.pokedex(generationId: "3"))

        // Then
        XCTAssertEqual(sut.selectedTab, .pokedex)
        XCTAssertNil(sut.presentedPokemon)
    }

    func test_handle_givenPokedexWithGeneration_andContextDeallocated_thenDoesNotCrash() {
        // Given
        let (sut, _) = makeSUT(searchContext: nil)

        do {
            let context = PokedexListingSearchContext(selectedGenerationId: nil)
            sut.bind(searchContext: context)
            // context deallocates at end of scope
        }

        // When
        sut.handle(.pokedex(generationId: "2"))

        // Then
        XCTAssertEqual(sut.selectedTab, .pokedex)
        XCTAssertNil(sut.presentedPokemon)
    }

    // MARK: - Helpers

    @discardableResult
    private func makeSUT(
        searchContext: PokedexListingSearchContext? = nil,
        initialTab: AppTab = .pokedex,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: DeepLinkCoordinator, searchContext: PokedexListingSearchContext?) {
        let sut = DeepLinkCoordinator()
        sut.selectedTab = initialTab

        if let searchContext {
            sut.bind(searchContext: searchContext)
        }

        trackForMemoryLeaks(sut, file: file, line: line)
        if let searchContext {
            trackForMemoryLeaks(searchContext, file: file, line: line)
        }

        return (sut, searchContext)
    }

    private func trackForMemoryLeaks(
        _ instance: AnyObject,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Potential memory leak.", file: file, line: line)
        }
    }
}
