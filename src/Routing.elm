module Routing exposing (..)

import Browser.Navigation exposing (..)
import Url exposing (Url)
import Url.Parser exposing (..)


type Routes
    = Login
    | Register
    | Home
    | NotFound


parseUrl : Url -> Routes
parseUrl url =
    case parse matchRoute url of
        Just route ->
            route

        Nothing ->
            NotFound


matchRoute : Parser (Routes -> a) a
matchRoute =
    oneOf
        [ map Home top
        , map Home (s "home")
        , map Register (s "register")
        , map Login (s "login")
        , map NotFound top
        ]
