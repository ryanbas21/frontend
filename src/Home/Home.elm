module Home.Home exposing (..)

import Bootstrap.Spinner as Spinner
import Html exposing (Html, div, text)


type Model
    = Success
    | Failure
    | Loading
    | Loaded


type Msg
    = None


model : ( Model, Cmd Msg )
model =
    ( Loading, Cmd.none )


init : ( Model, Cmd Msg )
init =
    ( Loaded, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        None ->
            ( Loaded, Cmd.none )


view : Model -> Html Msg
view m =
    case m of
        Loading ->
            Spinner.spinner [ Spinner.grow ] []

        Loaded ->
            div [] [ text "Home" ]

        _ ->
            div [] [ text "Extra case" ]
