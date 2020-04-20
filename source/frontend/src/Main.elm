module Main exposing (Model, init, Msg, update, view, subscriptions)

import Html exposing (..)
import Html.Attributes exposing (..)
import Browser
import Browser.Navigation as Nav
import Url
import Url.Parser exposing (Parser, (</>), int, map, oneOf, s, string)

import Pages.Home as Home
import Pages.About as About

type Route = 
    Home
    | About

main : Program (Maybe Int) Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
    }


type alias Model =
    { flags : (Maybe Int)
    , key : Nav.Key
    , url : Url.Url
    , route: Route
    }


init : Maybe Int -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init flags url key =
    ( { flags = flags, key = key, url = url, route = Home }
    , Cmd.none
    )


type Msg =
    UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | HomeMsg Home.Msg
    | AboutMsg About.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        UrlRequested urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )

        HomeMsg content ->
            (model, Cmd.none)

        AboutMsg content ->
            (model, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Browser.Document Msg
view model =
    { title = "Home"
    , body =
      [ text "The current URL is: "
      , b [] [ text (Url.toString model.url) ]
      , ul []
          [ viewLink "/home"
          , viewLink "/about"
          , viewLink "/reviews/the-century-of-the-self"
          , viewLink "/reviews/public-opinion"
          , viewLink "https://github.com/edwinvautier"
          , viewLink "https://elmprogramming.com/virtual-dom.html"
          ],
        viewMain model
      ]
    }


viewLink : String -> Html Msg
viewLink path =
  li [] [ a [ href path ] [ text path ] ]

viewMain : Model -> Html Msg
viewMain model = 
    case model.url.path of
        "/home" ->
            Home.view ({name = "Edwin"}) |> Html.map HomeMsg
        "/about" ->
            About.view {name = "Edwin"} |> Html.map AboutMsg
        _ ->
            Home.view ({name = "Edwin"}) |> Html.map HomeMsg