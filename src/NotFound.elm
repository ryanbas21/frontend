module NotFound exposing (..)

import Browser
import Html exposing (..)


type Model
    = NotFoundPageModel


type Msg
    = None


init : ( Model, Cmd Msg )
init =
    ( NotFoundPageModel, Cmd.none )


update : Msg -> Model -> Model
update _ _ =
    NotFoundPageModel


view : Model -> Html Msg
view model =
    div [] [ text "Page Not Found" ]
