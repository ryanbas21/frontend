module Login.Test exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Login.Login exposing (LoadingState(..), Model, Msg(..), update)
import Test exposing (Test, describe, test)


m : Model
m =
    { loading = PageLoading
    , username = ""
    , password = ""
    , error = ""
    }


suite : Test
suite =
    describe "Home update"
        [ test "given a HandleUsername it returns updated state" <|
            \_ ->
                update (HandleUsername "testuser") m
                    |> Expect.equal
                        ( { loading = PageLoading
                          , username = "testuser"
                          , password = ""
                          , error = ""
                          }
                        , Cmd.none
                        )
        , test "given HandlePassword it updates state" <|
            \_ ->
                update (HandlePassword "testpass") m
                    |> Expect.equal
                        ( { loading = PageLoading
                          , username = ""
                          , password = "testpass"
                          , error = ""
                          }
                        , Cmd.none
                        )
        , test "given RegistrationSuccess it retuns state" <|
            \_ ->
                update RegistrationSuccess m
                    |> Expect.equal
                        ( m
                        , Cmd.none
                        )
        , test "given RegistrationFailure it returns error" <|
            \_ ->
                update (RegistrationFailure "bad email") m
                    |> Expect.equal
                        ( { loading = PageLoading
                          , username = ""
                          , password = ""
                          , error = "bad email"
                          }
                        , Cmd.none
                        )
        , test "Given Loading msg, loading is set" <|
            \_ ->
                update Loading m
                    |> Expect.equal
                        ( { loading = PageLoading
                          , username = ""
                          , password = ""
                          , error = ""
                          }
                        , Cmd.none
                        )
        , test "Given Loaded msg, loaded is set" <|
            \_ ->
                update Loaded m
                    |> Expect.equal
                        ( { loading = PageLoaded
                          , username = ""
                          , password = ""
                          , error = ""
                          }
                        , Cmd.none
                        )
        ]
