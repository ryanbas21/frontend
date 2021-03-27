module Register.Register exposing (..)

import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Checkbox as Checkbox
import Bootstrap.Form.Fieldset as Fieldset
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Radio as Radio
import Bootstrap.Form.Select as Select
import Bootstrap.Form.Textarea as Textarea
import Html exposing (Html, div, text)
import Html.Attributes exposing (for)


type LoadingState
    = Success
    | Failure
    | Loading
    | Loaded


type alias Model =
    { loadingState : LoadingState
    , email : String
    , password : String
    , confirmPassword : String
    }


type Msg
    = HandleEmail String
    | HandlePassword String
    | ConfirmPassword String


model : ( Model, Cmd Msg )
model =
    ( { loadingState = Loading
      , email = ""
      , password = ""
      , confirmPassword = ""
      }
    , Cmd.none
    )


init : ( Model, Cmd Msg )
init =
    model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg m =
    case msg of
        HandleEmail email ->
            ( { m | email = email }, Cmd.none )

        ConfirmPassword p ->
            ( { m | confirmPassword = p }, Cmd.none )

        HandlePassword p ->
            ( { m | password = p }, Cmd.none )


view : Model -> Html Msg
view _ =
    Form.form []
        [ Form.group []
            [ Form.label [ for "username" ] [ text "Username" ]
            , Input.email [ Input.onInput HandleEmail, Input.id "email" ]
            , Form.help [] [ text "We'll never share your email with anyone else." ]
            ]
        , Form.group []
            [ Form.label [ for "password" ] [ text "Password" ]
            , Input.password [ Input.onInput HandlePassword, Input.id "password" ]
            , Form.label [ for "confirm_password" ] [ text "Confirm Password" ]
            , Form.help [] [ text "Please Confirm Password" ]
            , Input.password
                [ Input.onInput ConfirmPassword
                , Input.id "confirm_password"
                ]
            ]
        , Button.button [ Button.primary ] [ text "Register" ]
        ]
