module Tests exposing (all)

import Test exposing (test, Test, describe)
import Expect


all : Test
all =
    describe "A dummy Test Suite."
        [ test "Addition" <|
            \_ ->
                Expect.equal 15 (8 + 7)
        , test "Substraction" <|
            \_ ->
                Expect.equal 13 (23 - 10)
        , test "Multiply" <|
            \_ ->
                Expect.equal 69 (23 * 3)
        , test "Concatenation" <|
            \_ ->
                Expect.equal "ab" ("a" ++ "b")
        ]