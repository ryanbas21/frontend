module Main exposing (..)

import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Navbar as Navbar
import Browser
import Browser.Navigation as Nav
import Home.Home as Home
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)
import Json.Decode as Decode exposing (Value)
import Login.Login as Login
import NotFound
import Register.Register as Register
import Routing as Route
import Url exposing (Url)



-- MAIN


main : Program Value Model Msg
main =
    Browser.application
        { init = init
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MODEL


type alias Model =
    { route : Route.Routes
    , page : Page
    , navKey : Nav.Key
    , navbarState : Navbar.State
    }


type Page
    = HomePage Home.Model
    | LoginPage Login.Model
    | RegisterPage Register.Model
    | NotFoundPage NotFound.Model


init : flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        ( navbarState, navbarCmd ) =
            Navbar.initialState NavbarMsg

        model =
            { route = Route.parseUrl url
            , page = NotFoundPage NotFound.NotFoundPageModel
            , navKey = key
            , navbarState = navbarState
            }
    in
    initCurrentPage ( model, navbarCmd )


initCurrentPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
initCurrentPage ( model, existingCmds ) =
    let
        ( currentPage, mappedPageCmds ) =
            case model.route of
                Route.Login ->
                    let
                        ( pageModel, pageCmds ) =
                            Login.init
                    in
                    ( LoginPage pageModel, Cmd.map LoginMsg pageCmds )

                Route.Register ->
                    let
                        ( pageModel, pageCmds ) =
                            Register.init
                    in
                    ( RegisterPage pageModel, Cmd.map RegisterMsg pageCmds )

                Route.Home ->
                    let
                        ( pageModel, pageCmds ) =
                            Home.init
                    in
                    ( HomePage pageModel, Cmd.map HomeMsg pageCmds )

                Route.NotFound ->
                    let
                        ( pageModel, pageCmds ) =
                            NotFound.init
                    in
                    ( NotFoundPage pageModel, Cmd.map NotFoundMsg pageCmds )
    in
    ( { model | page = currentPage }
    , Cmd.batch [ existingCmds, mappedPageCmds ]
    )



-- UPDATE


type Msg
    = UrlChanged Url
    | LinkClicked Browser.UrlRequest
    | NavbarMsg Navbar.State
    | LoginMsg Login.Msg
    | RegisterMsg Register.Msg
    | HomeMsg Home.Msg
    | NotFoundMsg NotFound.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( NavbarMsg state, _ ) ->
            ( { model | navbarState = state }, Cmd.none )

        ( LinkClicked url, _ ) ->
            case url of
                Browser.Internal internalUrl ->
                    ( model, Nav.pushUrl model.navKey (Url.toString internalUrl) )

                Browser.External externalUrl ->
                    ( model
                    , Nav.load externalUrl
                    )

        ( UrlChanged url, _ ) ->
            ( { model | route = Route.parseUrl url }, Cmd.none )
                |> initCurrentPage

        ( LoginMsg pageMsg, LoginPage pageModel ) ->
            let
                ( updatedModel, pageCmd ) =
                    Login.update pageMsg pageModel
            in
            ( { model
                | page = LoginPage updatedModel
              }
            , Cmd.map LoginMsg pageCmd
            )

        ( RegisterMsg pageMsg, RegisterPage pageModel ) ->
            let
                ( updatedModel, pageCmd ) =
                    Register.update pageMsg pageModel
            in
            ( { model
                | page = RegisterPage updatedModel
              }
            , Cmd.map RegisterMsg pageCmd
            )

        ( HomeMsg pageMsg, HomePage pageModel ) ->
            let
                ( updatedModel, pageCmd ) =
                    Home.update pageMsg pageModel
            in
            ( { model
                | page = HomePage updatedModel
              }
            , Cmd.map HomeMsg pageCmd
            )

        ( NotFoundMsg pageMsg, NotFoundPage pageModel ) ->
            ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Pancakes"
    , body =
        [ Grid.container []
            [ CDN.stylesheet
            , Navbar.config NavbarMsg
                |> Navbar.withAnimation
                |> Navbar.brand [ href "/home" ] [ text "Home" ]
                |> Navbar.items
                    [ Navbar.itemLink [ href "/login" ] [ text "Login" ]
                    , Navbar.itemLink [ href "/register" ] [ text "Register" ]
                    ]
                |> Navbar.view model.navbarState
            , Grid.row []
                [ Grid.col
                    []
                    [ handleRoutes model ]
                ]
            ]
        ]
    }


handleRoutes : Model -> Html Msg
handleRoutes model =
    case model.page of
        LoginPage pageModel ->
            Login.view pageModel |> Html.map LoginMsg

        RegisterPage pageModel ->
            Register.view pageModel |> Html.map RegisterMsg

        HomePage pageModel ->
            Home.view pageModel |> Html.map HomeMsg

        NotFoundPage pageModel ->
            NotFound.view pageModel |> Html.map NotFoundMsg
