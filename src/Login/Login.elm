module Login.Login exposing (..)

import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Checkbox as Checkbox
import Bootstrap.Form.Fieldset as Fieldset
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Radio as Radio
import Bootstrap.Form.Select as Select
import Bootstrap.Form.Textarea as Textarea
import Html exposing (Html, div, text)
import Html.Attributes exposing (for, placeholder)


type LoadingState
    = PageLoading
    | PageLoaded


type alias Model =
    { loading : LoadingState
    , username : String
    , password : String
    , error : String
    }


type Msg
    = HandleUsername String
    | HandlePassword String
    | RegistrationSuccess
    | RegistrationFailure String
    | Loading
    | Loaded


model : ( Model, Cmd Msg )
model =
    ( { loading = PageLoading
      , username = ""
      , password = ""
      , error = ""
      }
    , Cmd.none
    )


init : ( Model, Cmd Msg )
init =
    ( { loading = PageLoading
      , username = ""
      , password = ""
      , error = ""
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg m =
    case msg of
        HandleUsername s ->
            ( { m | username = s }, Cmd.none )

        HandlePassword p ->
            ( { m | password = p }, Cmd.none )

        RegistrationFailure error ->
            ( { m | error = error }, Cmd.none )

        RegistrationSuccess ->
            ( m, Cmd.none )

        Loading ->
            ( { m | loading = PageLoading }, Cmd.none )

        Loaded ->
            ( { m | loading = PageLoaded }, Cmd.none )


view : Model -> Html Msg
view _ =
    Form.form []
        [ Form.group []
            [ Form.label [ for "email" ] [ text "email" ]
            , Input.email [ Input.onInput HandleUsername, Input.id "email" ]
            , Form.help [] [ text "We'll never share your email with anyone else." ]
            ]
        , Form.group []
            [ Form.label [ for "password" ] [ text "Password" ]
            , Input.password [ Input.onInput HandlePassword, Input.id "password" ]
            , Button.button [ Button.primary ] [ text "Log in" ]
            ]
        ]
