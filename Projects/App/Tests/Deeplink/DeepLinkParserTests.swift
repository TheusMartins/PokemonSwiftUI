//
//  DeepLinkParserTests.swift
//  PokedexShowcase
//
//  Created by Matheus Martins on 15/01/26.
//

import XCTest
@testable import PokedexShowcase

final class DeepLinkParserTests: XCTestCase {

    // MARK: - pokemonDetails

    func test_parse_givenSchemeIsNotPokedex_whenParsing_thenReturnsNil() {
        // Given
        let url = makeURL("http://team")

        // When
        let result = DeepLinkParser.parse(url)

        // Then
        XCTAssertNil(result)
    }

    func test_parse_givenHostIsPokemonAndNameInPath_whenParsing_thenReturnsPokemonDetailsLowercased() {
        // Given
        let url = makeURL("pokedex://pokemon/Bulbasaur")

        // When
        let result = DeepLinkParser.parse(url)

        // Then
        XCTAssertEqual(result, .pokemonDetails(name: "bulbasaur"))
    }

    func test_parse_givenHostIsPokemonAndNameInQuery_whenParsing_thenReturnsPokemonDetailsLowercased() {
        // Given
        let url = makeURL("pokedex://pokemon?name=Charmander")

        // When
        let result = DeepLinkParser.parse(url)

        // Then
        XCTAssertEqual(result, .pokemonDetails(name: "charmander"))
    }

    func test_parse_givenHostIsPokemonAndPathIsEmptyAndQueryMissing_whenParsing_thenReturnsNil() {
        // Given
        let url = makeURL("pokedex://pokemon")

        // When
        let result = DeepLinkParser.parse(url)

        // Then
        XCTAssertNil(result)
    }

    func test_parse_givenHostIsPokemonAndNameIsWhitespaceInQuery_whenParsing_thenReturnsNil() {
        // Given
        let url = makeURL("pokedex://pokemon?name=%20%20%20")

        // When
        let result = DeepLinkParser.parse(url)

        // Then
        XCTAssertNil(result)
    }

    func test_parse_givenHostIsPokemonAndNameInPathTakesPriorityOverQuery_whenParsing_thenUsesPath() {
        // Given
        let url = makeURL("pokedex://pokemon/Pikachu?name=Eevee")

        // When
        let result = DeepLinkParser.parse(url)

        // Then
        XCTAssertEqual(result, .pokemonDetails(name: "pikachu"))
    }

    func test_parse_givenHostIsPokemonAndNameHasLeadingTrailingSpacesInQuery_whenParsing_thenTrimsAndReturnsLowercased() {
        // Given
        // "  Mew  " encoded => %20%20Mew%20%20
        let url = makeURL("pokedex://pokemon?name=%20%20Mew%20%20")

        // When
        let result = DeepLinkParser.parse(url)

        // Then
        XCTAssertEqual(result, .pokemonDetails(name: "mew"))
    }

    func test_parse_givenHostIsPokemonAndHostHasMixedCase_whenParsing_thenStillParses() {
        // Given
        let url = makeURL("pokedex://PoKeMoN/Bulbasaur")

        // When
        let result = DeepLinkParser.parse(url)

        // Then
        XCTAssertEqual(result, .pokemonDetails(name: "bulbasaur"))
    }

    // MARK: - pokedex

    func test_parse_givenHostIsPokedexAndNoGenerationQuery_whenParsing_thenReturnsPokedexWithNilGeneration() {
        // Given
        let url = makeURL("pokedex://pokedex")

        // When
        let result = DeepLinkParser.parse(url)

        // Then
        XCTAssertEqual(result, .pokedex(generationId: nil))
    }

    func test_parse_givenHostIsPokedexAndGenerationQueryPresent_whenParsing_thenReturnsPokedexWithGeneration() {
        // Given
        let url = makeURL("pokedex://pokedex?generation=generation-iii")

        // When
        let result = DeepLinkParser.parse(url)

        // Then
        XCTAssertEqual(result, .pokedex(generationId: "generation-iii"))
    }

    func test_parse_givenHostIsPokedexAndGenerationQueryEmpty_whenParsing_thenReturnsPokedexWithEmptyString() {
        // Given
        let url = makeURL("pokedex://pokedex?generation=")

        // When
        let result = DeepLinkParser.parse(url)

        // Then
        XCTAssertEqual(result, .pokedex(generationId: ""))
    }

    func test_parse_givenHostIsPokedexAndMultipleQueryItems_whenParsing_thenUsesGenerationItem() {
        // Given
        let url = makeURL("pokedex://pokedex?foo=bar&generation=generation-i&baz=qux")

        // When
        let result = DeepLinkParser.parse(url)

        // Then
        XCTAssertEqual(result, .pokedex(generationId: "generation-i"))
    }

    func test_parse_givenHostIsPokedexAndHostHasMixedCase_whenParsing_thenStillParses() {
        // Given
        let url = makeURL("pokedex://PoKeDeX?generation=generation-ii")

        // When
        let result = DeepLinkParser.parse(url)

        // Then
        XCTAssertEqual(result, .pokedex(generationId: "generation-ii"))
    }

    // MARK: - team

    func test_parse_givenHostIsTeam_whenParsing_thenReturnsTeam() {
        // Given
        let url = makeURL("pokedex://team")

        // When
        let result = DeepLinkParser.parse(url)

        // Then
        XCTAssertEqual(result, .team)
    }

    func test_parse_givenHostIsTeamWithMixedCase_whenParsing_thenReturnsTeam() {
        // Given
        let url = makeURL("pokedex://TeAm")

        // When
        let result = DeepLinkParser.parse(url)

        // Then
        XCTAssertEqual(result, .team)
    }

    // MARK: - unknown

    func test_parse_givenHostIsUnknown_whenParsing_thenReturnsNil() {
        // Given
        let url = makeURL("pokedex://unknown")

        // When
        let result = DeepLinkParser.parse(url)

        // Then
        XCTAssertNil(result)
    }

    // MARK: - Helpers

    private func makeURL(_ string: String, file: StaticString = #filePath, line: UInt = #line) -> URL {
        guard let url = URL(string: string) else {
            XCTFail("Invalid test URL: \(string)", file: file, line: line)
            return URL(string: "pokedex://invalid")!
        }
        return url
    }
}
