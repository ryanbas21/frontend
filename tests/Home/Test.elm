module Home.Test exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Home.Home exposing (Model(..), Msg(..), update)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "Home update"
        [ test "given a None it retuns Loaded" <|
            \_ -> update None Loading |> Expect.equal ( Loaded, Cmd.none )
        ]
